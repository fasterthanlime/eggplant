
// sdk
import io/File

// ours
import eggplant/[egg, buffer]

egg_dump: func (patch: File) {
    egg := Egg new(patch)

    for (e in egg del) {
        "#{e path} deleted" println()
    }
    for (e in egg equ) {
        "#{e path} equ, sha1 = #{e sum}" println()
    }
    for (e in egg add) {
        "#{e path} added, sha1 = #{e sum}, #{e buffer size} bytes" println()
    }
    for (e in egg mod) {
        "#{e path} modded, sha1 = #{e sum}, #{e diff size} bytes diff" println()
    }

    "#{egg del size} deleted," println()
    "#{egg add size} added," println()
    "#{egg mod size} modified," println()
    "#{egg equ size} equal" println()
}

