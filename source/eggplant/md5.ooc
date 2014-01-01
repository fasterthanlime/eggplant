
// sdk
import io/[File, FileReader]
import os/Process
import text/StringTokenizer

include md5/md5

MD5ContextStruct: cover from MD5_CTX

// must be 16 uchars long
MD5_Final: extern func (result: UChar*, context: MD5Context)

MD5Context: cover from MD5ContextStruct* {
    new: static func -> This {
        c := gc_malloc(MD5ContextStruct size) as This
        c _init()
        c
    }

    _init: extern(MD5_Init) func

    update: extern(MD5_Update) func (data: Pointer, size: SizeT)

    finish: func -> MD5Sum {
        result := MD5Sum new()
        MD5_Final(result data, this)
        result
    }
}

MD5Sum: class {
    data: UChar*
    size: Int { get { 16 } }

    init: func {
        data = gc_malloc(size * UChar size) as UChar*
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

MD5: class {

    sum: static func (file: File) -> MD5Sum {
        m := MD5Context new()
        fr := FileReader new(file)
        buff := Buffer new(4096)
        while (fr hasNext?()) {
            fr read(buff)
            m update(buff data, buff size)
        }
        fr close()
        m finish()
    }

}

