
// sdk
import io/[File, FileWriter, FileReader, BinarySequence]
import structs/[ArrayList]

// ours
import eggplant/[tree, md5, bsdiff]

Egg: class {
    add := ArrayList<EggData> new()
    mod := ArrayList<EggDiff> new()
    del := ArrayList<EggPath> new()
    equ := ArrayList<EggPath> new()

    init: func

    write: func (f: File) {
        w := EggWriter new(f)
        for (e in add) { e write(w) }
        for (e in mod) { e write(w) }
        for (e in del) { e write(w) }
        w close()
    }
}

EggMagic: enum from UInt8 {
    ADD = 0xAD
    DEL = 0xD3
    DIF = 0x0D
    DAT = 0xDA
    MD5 = 0xD5
}

EggData: class {
    path: String
    buffer: Buffer
    sum: MD5Sum

    init: func (=path, =buffer, =sum)

    apply: func (prefix: File) {
        oldf := File new(prefix, path)
        BSDiff patch(oldf, buffer)
    }

    write: func (w: EggWriter) {
        w writeMagic(EggMagic ADD)
        w writeString(path)

        w writeMagic(EggMagic DAT)
        w writeBytes(buffer data, buffer size)

        w writeMagic(EggMagic MD5)
        w writeBytes(sum data, sum size)
    }
}

EggDiff: class {
    path: String
    diff: Buffer
    sum: MD5Sum

    init: func (=path, =diff, =sum)

    write: func (w: EggWriter) {
        w writeMagic(EggMagic DIF)
        w writeString(path)

        w writeMagic(EggMagic DAT)
        w writeBytes(diff data, diff size)

        w writeMagic(EggMagic MD5)
        w writeBytes(sum data, sum size)
    }
}

EggPath: class {
    path: String

    init: func (=path)

    write: func (w: EggWriter) {
        w writeMagic(EggMagic DEL)
        w writeString(path)
    }
}

EggWriter: class {
    target: File
    fw: FileWriter
    bin: BinarySequenceWriter

    init: func (=target) {
        fw = FileWriter new(target)
        bin = BinarySequenceWriter new(fw)
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

