
// sdk
import io/File

// ours
import eggplant/[egg, tree, buffer]

egg_commit: func (kiddo, patch: File) {
    egg := Egg new(patch)

    errs := 0

    "#{egg del size} deleted," println()
    "#{egg add size} added," println()
    "#{egg mod size} modified," println()
    "#{egg equ size} equal" println()

    if (errs > 0) {
        "#{errs} errors" println()
        exit(1)
    } else {
        "no errors" println()
    }
}

