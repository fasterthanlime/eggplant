
// sdk
import io/File

// ours
import eggplant/[egg]

egg_patch: func (oldie, patch: File) {
    egg := Egg new(patch)

    "#{egg del size} deleted," println()
    "#{egg add size} added," println()
    "#{egg mod size} modified," println()
    "#{egg equ size} equal" println()
}
