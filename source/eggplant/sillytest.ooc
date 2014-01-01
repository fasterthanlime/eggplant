
import eggplant/bsdiff

sillytest: func {
    oldie := "Myes"
    oldiesz := oldie size + 1
    kiddo := "Mreally?"
    kiddosz := kiddo size + 1

    patchsz_max := bsdiff_patchsize_max(oldiesz, kiddosz)
    patch := gc_malloc(patchsz_max)

    patchsz := bsdiff(oldie _buffer data, oldiesz,
                      kiddo _buffer data, kiddosz,
                      patch, patchsz_max)

    "oldiesz     = #{oldiesz}" println()
    "kiddosz     = #{kiddosz}" println()
    "patchsz_max = #{patchsz_max}" println()
    "patchsz     = #{patchsz}" println()

    kiddo2sz := bspatch_newsize(patch, patchsz)
    kiddo2 := gc_malloc(kiddo2sz) as CString
    bspatch(oldie _buffer data, oldiesz, patch, patchsz, kiddo2, kiddo2sz)

    "oldie  = #{oldie}" println()
    "kiddo  = #{kiddo}" println()
    "kiddo2 = #{kiddo2 toString()}" println()
}
