
// sdk
import io/[File, FileReader]

EggBuffer: class {
    data: UChar*
    size: SizeT

    init: func (=size) {
        data = malloc(size * UChar size)
    }

    init: func ~readFile (file: File) {
        off: SizeT = 0
        bufsize: SizeT = 4096
        init(file getSize())

        fR := FileReader new(file)
        while (fR hasNext?()) {
            off += fR read(data, off, bufsize)
        }
        fR close()
    }

    trim!: func (=size) {
        data = realloc(data, size)
    }

    free: func {
        free(data)
    }
}

malloc: extern func (s: SizeT) -> UChar*
realloc: extern func (p: UChar*, s: SizeT) -> UChar*
free: extern func (p: UChar*)

