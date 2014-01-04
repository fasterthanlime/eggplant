
// sdk
import io/[File, FileReader]
import os/Process
import text/StringTokenizer

// ours
import eggplant/[buffer]

include sha1/sha1
SHA1ContextStruct: cover from SHA1_CTX

// must be 64 uchars long
SHA1_Final: extern func (context: SHA1Context, result: UChar*)

SHA1Context: cover from SHA1ContextStruct* {
    new: static func -> This {
        c := gc_malloc(SHA1ContextStruct size) as This
        c _init()
        c
    }

    _init: extern(SHA1_Init) func

    update: extern(SHA1_Update) func (data: Pointer, size: SizeT)

    finish: func -> SHA1Sum {
        result := SHA1Sum new()
        SHA1_Final(this, result data as UChar*)
        result
    }
}

SHA1Sum: class {
    data: UChar*
    size: Int { get { 20 } }

    init: func ~empty {
        data = gc_malloc(size * UChar size) as UChar*
    }

    init: func ~buff (buffer: EggBuffer) {
        init()
        memcpy(data, buffer data, size * UChar size)
        buffer free()
    }

    toString: func -> String {
        res := Buffer new()
        for (i in 0..size) {
            res append("%02x" format(data[i] as Int))
        }
        res toString()
    }

    equals?: func (o: This) -> Bool {
        for (i in 0..size) {
            if (o data[i] != data[i]) return false
        }

        true
    }
}

SHA1: class {

    sum: static func ~fil (file: File) -> SHA1Sum {
        m := SHA1Context new()
        fr := FileReader new(file)
        buff := Buffer new(16384)
        while (fr hasNext?()) {
            fr read(buff)
            m update(buff data as UChar*, buff size)
        }
        fr close()
        m finish()
    }

    sum: static func ~buf (buf: EggBuffer) -> SHA1Sum {
        m := SHA1Context new()
        off: SizeT = 0

        tmp := EggBuffer new(4096)
        while (off < buf size) {
            copied := buf copy(tmp, off)
            m update(tmp data, copied)
            off += copied
        }
        tmp free()

        m finish()
    }

}


