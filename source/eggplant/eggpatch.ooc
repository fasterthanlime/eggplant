
// sdk
import io/File

// ours
import eggplant/[egg, buffer]

egg_patch: func (oldie, eggFile: File) {
    egg := Egg new(eggFile)

    for (mod in egg mod) {
        "mod: #{mod path}, #{mod diff size} bytes diff" println()
    }

    "#{egg del size} deleted," println()
    "#{egg add size} added," println()
    "#{egg mod size} modified," println()
    "#{egg equ size} equal" println()
}
