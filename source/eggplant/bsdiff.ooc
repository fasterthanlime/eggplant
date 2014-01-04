
include bsdiff/bsdiff
include bsdiff/bspatch

// sdk
import io/File

// ours
import eggplant/[buffer]

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

    diff: static func (oldf, newf: File) -> EggBuffer {
        olds := EggBuffer new(oldf)
        news := EggBuffer new(newf)

        oldp := olds data
        newp := news data
        oldsz := olds size
        newsz := news size

        szmax := bsdiff_patchsize_max(oldsz, newsz)
        buff := EggBuffer new(szmax)
        sz := bsdiff(oldp, oldsz, newp, newsz, buff data, buff size)
        "szmax = #{szmax}, sz = #{sz} newsz / sz % = #{(newsz as Float) * 100.0f / (sz as Float)}" println()
        buff trim!(sz)

        buff
    }

    patch: static func (oldf: File, patch: EggBuffer) -> EggBuffer {
        patchp  := patch data
        patchsz := patch size

        newsz := bspatch_newsize(patchp, patchsz)
        news := EggBuffer new(newsz)
        newp := news data

        olds := EggBuffer new(oldf)
        oldp  := olds data
        oldsz := olds size

        bspatch(oldp, oldsz, patchp, patchsz, newp, newsz)

        olds free()
        news
    }

}

