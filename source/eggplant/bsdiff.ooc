
include bsdiff/bsdiff
include bsdiff/bspatch

BSDiff: class {

    patchsize_max: extern(bsdiff_patchsize_max) static func (oldsize, newsize: SizeT) -> SizeT

}

