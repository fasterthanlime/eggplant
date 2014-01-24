
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
        "#{e path} equ, sha1 = #{e sum}, size = #{e size}" println()
    }
    for (e in egg add) {
        "#{e path} added, sha1 = #{e sum}, size = #{e size}, #{e buffer size} bytes, #{e flags} flags" println()
    }
    for (e in egg mod) {
        "#{e path} modded, sha1 = #{e sum}, size = #{e size}, #{e buffer size} bytes diff, #{e flags} flags" println()
    }

    egg printStats()
}

