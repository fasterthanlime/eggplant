
include bsdiff/bsdiff
include bsdiff/bspatch

// sdk
import io/File

bsdiff_patchsize_max: extern func (oldsz, newsz: SSizeT) -> SSizeT
bsdiff: extern func (
    oldp: Pointer, oldsz: SSizeT,
    newp: Pointer, newsz: SSizeT,
    patch: Pointer, patchsz: SSizeT) -> SSizeT

bspatch_newsize: extern func (patch: Pointer, patchsz: SSizeT) -> SSizeT
bspatch_valid_header: extern func (patch: Pointer, patchsz: SSizeT) -> SSizeT
bspatch: extern func (
    oldp: Pointer, oldsz: SSizeT,
    patch: Pointer, patchsz: SSizeT,
    newp: Pointer, newsz: SSizeT) -> SSizeT

BSDiff: class {

    diff: static func (oldf, newf: File) -> Buffer {
        olds := oldf read()
        news := newf read()

        oldp := olds _buffer data
        newp := news _buffer data
        oldsz := olds size
        newsz := news size

        szmax := bsdiff_patchsize_max(oldsz, newsz)
        buff := Buffer new(szmax)
        buff size = bsdiff(oldp, oldsz, newp, newsz, buff data, buff capacity)

        buff
    }

    patch: static func (oldf: File, patch: Buffer) -> Int {
        raise("BSDiff patch: stub")
        1
    }

}

