
// sdk
import io/[File, FileWriter, FileReader, BinarySequence]
import structs/[ArrayList]

// ours
import eggplant/[tree, sha1, bsdiff, buffer, xz, size]

Egg: class {
    startMagic: UInt32 = 0xBEEFDADD

    add := ArrayList<EggAdd> new()
    mod := ArrayList<EggMod> new()
    del := ArrayList<EggDel> new()
    equ := ArrayList<EggEqu> new()

    file: File

    init: func ~empty

    init: func ~load (=file) {
        tmp := File new(file path + ".raw")
        "Decompressing from #{file path}..." println()
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

        "Compressing to #{file path}..." println()
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
}

EggFlags: enum from UInt8 {
    EXC = 0x01
    UK2 = 0x02
    UK3 = 0x04
    UK4 = 0x08
    UK5 = 0x10
    UK6 = 0x20
    UK7 = 0x40
    UK8 = 0x80
}

EggNode: abstract class {
    path: String

    init: func (=path)
}

EggFileNode: abstract class extends EggNode {
    flags: UInt8
    sum: SHA1Sum

    init: func (.path, =flags, =sum) {
        super(path)
    }
}

EggAdd: class extends EggFileNode {
    buffer: EggBuffer

    init: func ~cons (.path, .flags, .sum, =buffer) {
        super(path, flags, sum)
    }

    init: func ~read (r: EggReader) {
        path = r readString()

        r checkMagic(EggMagic FLG)
        flags = r readFlags()

        r checkMagic(EggMagic DAT)
        buffer = r readBuffer()

        r checkMagic(EggMagic SHA)
        sum = SHA1Sum new(r readBuffer())
    }

    write: func (w: EggWriter) {
        w writeMagic(EggMagic ADD)
        w writeString(path)

        w writeMagic(EggMagic FLG)
        w writeFlags(flags)

        w writeMagic(EggMagic DAT)
        w writeBytes(buffer data, buffer size)

        w writeMagic(EggMagic SHA)
        w writeBytes(sum data, sum size)
    }
}

EggMod: class extends EggFileNode {
    diff: EggBuffer

    init: func ~cons (.path, .flags, .sum, =diff) {
        super(path, flags, sum)
    }

    init: func ~read (r: EggReader) {
        path = r readString()

        r checkMagic(EggMagic FLG)
        flags = r readFlags()

        r checkMagic(EggMagic DAT)
        diff = r readBuffer()

        r checkMagic(EggMagic SHA)
        sum = SHA1Sum new(r readBuffer())
    }

    write: func (w: EggWriter) {
        w writeMagic(EggMagic MOD)
        w writeString(path)

        w writeMagic(EggMagic FLG)
        w writeFlags(flags)

        w writeMagic(EggMagic DAT)
        w writeBytes(diff data, diff size)

        w writeMagic(EggMagic SHA)
        w writeBytes(sum data, sum size)
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

EggEqu: class {
    path: String
    sum: SHA1Sum

    init: func ~cons (=path, =sum)

    init: func ~read (r: EggReader) {
        path = r readString()

        r checkMagic(EggMagic SHA)
        sum = SHA1Sum new(r readBuffer())
    }

    write: func (w: EggWriter) {
        w writeMagic(EggMagic EQU)
        w writeString(path)

        w writeMagic(EggMagic SHA)
        w writeBytes(sum data, sum size)
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
        bin u32(length)
        fw write(data, length)
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
        len := bin u32()
        buff := Buffer new(len + 1)
        fr read(buff data, 0, len)
        buff data[len + 1] = '\0'
        buff size = len
        buff toString()
    }

    readBuffer: func -> EggBuffer {
        len := bin u32()
        off: SizeT = 0
        buff := EggBuffer new(len)
        while (off < len) {
            off += fr read(buff data, off, len - off)
        }
        buff
    }

    close: func {
        fr close()
    }

    hasNext?: func -> Bool {
        fr hasNext?()
    }
}

