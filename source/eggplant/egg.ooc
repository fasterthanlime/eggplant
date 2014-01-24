
// sdk
import io/[File, FileWriter, FileReader, BinarySequence]
import structs/[ArrayList]

// ours
import eggplant/[tree, sha1, bsdiff, buffer, xz, size]

Egg: class {
    startMagic: UInt32 = 0xBEEFDAD2

    add := ArrayList<EggAdd> new()
    mod := ArrayList<EggMod> new()
    del := ArrayList<EggDel> new()
    equ := ArrayList<EggEqu> new()

    file: File

    init: func ~empty

    init: func ~load (=file) {
        tmp := File new(file path + ".raw")
        XZ decompress(file, tmp)

        r := EggReader new(tmp)
        m := r bin u32()
        if (m != startMagic) {
            raise("Invalid magic: %0x" format(m))
        }
        while (r hasNext?()) {
            magic := r readMagic()
            match magic {
                case EggMagic ADD =>
                    add add(EggAdd new(r))
                case EggMagic MOD =>
                    mod add(EggMod new(r))
                case EggMagic DEL =>
                    del add(EggDel new(r))
                case EggMagic EQU =>
                    equ add(EggEqu new(r))
            }
        }
        r close()

        tmp rm()
    }

    write: func (=file) {
        raw := File new(file path + ".raw")

        w := EggWriter new(raw)
        w bin u32(startMagic)
        for (e in add) {
            e write(w)
        }
        for (e in mod) {
            e write(w)
        }
        for (e in del) {
            e write(w)
        }
        for (e in equ) {
            e write(w)
        }
        w close()

        XZ compress(raw, file)
        raw rm()
    }

    getName: func -> String {
        file ? file path : "<freshly hatched egg>"
    }

    getSize: func -> String {
        file ? Size format(file getSize()) : "unknown size"
    }

    stats: func -> String {
        "#{getName()} (#{getSize()}) #{del size} deleted, #{add size} added, #{mod size} modified, #{equ size} equal"
    }

    printStats: func {
        stats() println()
    }

    nodeCount: func -> Int {
        equ size + add size + mod size
    }
}

EggMagic: enum from UInt8 {
    ADD = 0xAD
    DEL = 0xD3
    MOD = 0x0D
    EQU = 0xE0
    DAT = 0xDA
    SHA = 0xA1
    FLG = 0xF1
    SIZ = 0xFA
}

EggFlags: enum from UInt8 {
    EXC = 0x01 // file is executable
    UK2 = 0x02 // reserved
    UK3 = 0x04 // reserved
    UK4 = 0x08 // reserved
    UK5 = 0x10 // reserved
    UK6 = 0x20 // reserved
    UK7 = 0x40 // reserved
    UK8 = 0x80 // reserved
}

EggNode: abstract class {
    path: String

    init: func (=path)

    write: abstract func (w: EggWriter)
}

EggFileNode: abstract class extends EggNode {
    flags: UInt8
    sum: SHA1Sum
    size: UInt64

    init: func (.path, =flags, =sum, =size) {
        super(path)
    }

    executable?: func -> Bool {
        (flags & EggFlags EXC) != 0
    }
}

EggFileBufferNode: abstract class extends EggFileNode {
    buffer: EggBuffer

    init: func (.path, .flags, .sum, .size, =buffer) {
        super(path, flags, sum, size)
    }

    init: func ~read (r: EggReader) {
        path = r readString()

        r checkMagic(EggMagic FLG)
        flags = r readFlags()

        r checkMagic(EggMagic DAT)
        buffer = r readBuffer()

        r checkMagic(EggMagic SHA)
        sum = SHA1Sum new(r readBuffer())

        r checkMagic(EggMagic SIZ)
        size = r readUInt64()
    }

    write: func ~withMagic (w: EggWriter, magic: UInt8) {
        w writeMagic(magic)
        w writeString(path)

        w writeMagic(EggMagic FLG)
        w writeFlags(flags)

        w writeMagic(EggMagic DAT)
        w writeBytes(buffer data, buffer size)

        w writeMagic(EggMagic SHA)
        w writeBytes(sum data, sum size)

        w writeMagic(EggMagic SIZ)
        w writeUInt64(size)
    }
}

EggAdd: class extends EggFileBufferNode {
    init: func ~cons (.path, .flags, .sum, .size, .buffer) {
        super(path, flags, sum, size, buffer)
    }

    init: func ~read (r: EggReader) {
        super(r)
    }

    write: func (w: EggWriter) {
        write(w, EggMagic ADD)
    }
}

EggMod: class extends EggFileBufferNode {
    init: func ~cons (.path, .flags, .sum, .size, .buffer) {
        super(path, flags, sum, size, buffer)
    }

    init: func ~read (r: EggReader) {
        super(r)
    }

    write: func (w: EggWriter) {
        write(w, EggMagic MOD)
    }
}

EggDel: class extends EggNode {
    init: func ~cons (.path) {
        super(path)
    }

    init: func ~read (r: EggReader) {
        path = r readString()
    }

    write: func (w: EggWriter) {
        w writeMagic(EggMagic DEL)
        w writeString(path)
    }
}

EggEqu: class extends EggFileNode {
    init: func ~cons (.path, .flags, .sum, .size) {
        super(path, flags, sum, size)
    }

    init: func ~read (r: EggReader) {
        path = r readString()

        r checkMagic(EggMagic FLG)
        flags = r readFlags()

        r checkMagic(EggMagic SHA)
        sum = SHA1Sum new(r readBuffer())

        r checkMagic(EggMagic SIZ)
        size = r readUInt64()
    }

    write: func (w: EggWriter) {
        w writeMagic(EggMagic EQU)
        w writeString(path)

        w writeMagic(EggMagic FLG)
        w writeFlags(flags)

        w writeMagic(EggMagic SHA)
        w writeBytes(sum data, sum size)

        w writeMagic(EggMagic SIZ)
        w writeUInt64(size)
    }
}

EggWriter: class {
    target: File
    fw: FileWriter
    bin: BinarySequenceWriter

    init: func (=target) {
        fw = FileWriter new(target)
        bin = BinarySequenceWriter new(fw)
        bin endianness = Endianness little
    }

    writeMagic: func (magic: UInt8) {
        bin u8(magic)
    }

    writeFlags: func (flags: UInt8) {
        bin u8(flags)
    }

    writeString: func (str: String) {
        writeBytes(str _buffer data, str size)
    }

    writeBytes: func (data: Pointer, length: SizeT) {
        bin u64(length)
        fw write(data, length)
    }

    writeUInt64: func (number: UInt64) {
        bin u64(number)
    }

    close: func {
        fw close()
    }
}

EggReader: class {
    source: File
    fr: FileReader
    bin: BinarySequenceReader

    init: func (=source) {
        fr = FileReader new(source)
        bin = BinarySequenceReader new(fr)
        bin endianness = Endianness little
    }

    readMagic: func -> UInt8 {
        bin u8()
    }

    readFlags: func -> UInt8 {
        bin u8()
    }

    checkMagic: func (magic: UInt8) {
        magic2 := readMagic()
        if (magic != magic2) {
            raise("Corrupted file: expected %0x, got %0x" format(magic, magic2))
        }
    }

    readString: func -> String {
        len := bin u64()
        buff := Buffer new(len + 1)
        fr read(buff data, 0, len)
        buff data[len + 1] = '\0'
        buff size = len
        buff toString()
    }

    readBuffer: func -> EggBuffer {
        len := bin u64() as SizeT
        off: SizeT = 0
        buff := EggBuffer new(len)
        while (off < len) {
            off += fr read(buff data, off, len - off)
        }
        buff
    }

    readUInt64: func -> UInt64 {
        bin u64()
    }

    close: func {
        fr close()
    }

    hasNext?: func -> Bool {
        fr hasNext?()
    }
}

