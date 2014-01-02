
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
        init(file getSize())

        fR := FileReader new(file)
        while (off < size) {
            off += fR read(data, off, size - off)
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

