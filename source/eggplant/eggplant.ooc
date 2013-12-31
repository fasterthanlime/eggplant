
use eggplant
import bsdiff

main: func {
    oldie := "Myes"
    kiddo := "Mreally?"

    size := BSDiff patchsize_max(oldie size, kiddo size)

    "A size of #{size}" println()
}
