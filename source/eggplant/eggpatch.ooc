
// sdk
import io/File

// ours
import eggplant/[egg, buffer]

egg_patch: func (oldie, patch: String) {
    egg := Egg new(File new(patch))

    for (mod in egg mod) {
        "mod: #{mod path}, #{mod diff size} bytes diff" println()
    }

    "#{egg del size} deleted," println()
    "#{egg add size} added," println()
    "#{egg mod size} modified," println()
    "#{egg equ size} equal" println()
}
