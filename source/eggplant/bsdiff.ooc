
include bsdiff/bsdiff
include bsdiff/bspatch

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

