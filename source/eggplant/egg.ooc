
// sdk
import io/[File, FileWriter, FileReader, BinarySequence]
import structs/[ArrayList]

// ours
import eggplant/[tree, sha1, bsdiff, buffer, xz]

Egg: class {
    startMagic: UInt32 = 0xBEEFDADD

    add := ArrayList<EggData> new()
    mod := ArrayList<EggDiff> new()
    del := ArrayList<EggDel> new()
    equ := ArrayList<EggEqu> new()

    init: func ~empty

    init: func ~load (f: File) {
        tmp := File new(f path + ".raw")
        "Decompressing..." println()
        XZ decompress(f, tmp)
        "Done decompressing!" println()

        r := EggReader new(tmp)
        m := r bin u32()
        if (m != startMagic) {
            raise("Invalid magic: %0x" format(m))
        }
        while (r hasNext?()) {
            magic := r readMagic()
            match magic {
                case EggMagic ADD =>
                    add add(EggData new(r))
                case EggMagic DIF =>
                    mod add(EggDiff new(r))
                case EggMagic DEL =>
                    del add(EggDel new(r))
                case EggMagic EQU =>
                    equ add(EggEqu new(r))
            }
        }
        r close()

        tmp rm()
    }

    write: func (f: File) {
        raw := File new(f path + ".raw")

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

        "Compressing..." println()
        XZ compress(raw, f)
        "Done compressing!" println()
        raw rm()
    }
}

EggMagic: enum from UInt8 {
    ADD = 0xAD
    DEL = 0xD3
    DIF = 0x0D
    EQU = 0xE0
    DAT = 0xDA
    SHA = 0xA1
}

EggData: class {
    path: String
    buffer: EggBuffer
    sum: SHA1Sum

    init: func ~cons (=path, =buffer, =sum)

    init: func ~read (r: EggReader) {
        path = r readString()

        r checkMagic(EggMagic DAT)
        buffer = r readBuffer()

        r checkMagic(EggMagic SHA)
        sum = SHA1Sum new(r readBuffer())
    }

    write: func (w: EggWriter) {
        w writeMagic(EggMagic ADD)
        w writeString(path)

        w writeMagic(EggMagic DAT)
        w writeBytes(buffer data, buffer size)

        w writeMagic(EggMagic SHA)
        w writeBytes(sum data, sum size)
    }

    apply: func (prefix: File) {
        raise("stub")
    }
}

EggDiff: class {
    path: String
    diff: EggBuffer
    sum: SHA1Sum

    init: func ~cons (=path, =diff, =sum)

    init: func ~read (r: EggReader) {
        path = r readString()

        r checkMagic(EggMagic DAT)
        diff = r readBuffer()

        r checkMagic(EggMagic SHA)
        sum = SHA1Sum new(r readBuffer())
    }

    write: func (w: EggWriter) {
        w writeMagic(EggMagic DIF)
        w writeString(path)

        w writeMagic(EggMagic DAT)
        w writeBytes(diff data, diff size)

        w writeMagic(EggMagic SHA)
        w writeBytes(sum data, sum size)
    }
}

EggDel: class {
    path: String

    init: func ~cons (=path)

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

