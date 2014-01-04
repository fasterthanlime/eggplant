
// sdk
import io/[File, FileReader, FileWriter]

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

    copy: func (dst: This, off: SizeT) -> SizeT {
        diff := size - off
        tocopy := match {
            case (diff >= dst size) =>
                dst size
            case =>
                diff
        }
        memcpy(dst data, data + off, tocopy)
        tocopy
    }

    write: func (file: File) {
        file parent mkdirs()
        fW := FileWriter new(file)
        written := fW write(data, size)
        fW close()
    }

    trim!: func (=size) {
        data = realloc(data, size)
    }

    free: func {
        free(data)
    }

    toString: func -> String {
        String new(data as CString, size)
    }
}

malloc: extern func (s: SizeT) -> UChar*
realloc: extern func (p: UChar*, s: SizeT) -> UChar*
free: extern func (p: UChar*)

