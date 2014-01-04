
// sdk
import io/File

// ours
import eggplant/[egg, tree, buffer, sha1, bsdiff]

egg_hone: func (oldie, patch: File) {
    ot := Tree new(oldie)
    egg := Egg new(patch)

    errs := 0

    for (e in egg del) {
        n := ot nodes get(e path)

        if (!n) {
            "#{e path} should be there so we can delete it" println()
            errs += 1
        }
    }

    for (e in egg equ) {
        n := ot nodes get(e path)

        if (!n) {
            "#{e path} should be there so we can equ it" println()
            errs += 1
            continue
        }

        buf := EggBuffer new(n file)
        sum := SHA1 sum(buf)
        buf free()

        if (!sum equals?(e sum)) {
            "#{e path} equ but sha1 mismatch. expected: #{e sum}, got: #{sum}" println()
            errs += 1
            continue
        }
    }

    for (e in egg add) {
        sum := SHA1 sum(e buffer)
        if (!sum equals?(e sum)) {
            "#{e path} added but sha1 mismatch. expected: #{e sum}, got: #{sum}" println()
            errs += 1
            continue
        }
    }

    for (e in egg mod) {
        n := ot nodes get(e path)

        if (!n) {
            "#{e path} should be there so we can mod it" println()
            errs += 1
            continue
        }

        news := BSDiff patch(n file, e diff)
        sum := SHA1 sum(news)
        news free()

        if (!sum equals?(e sum)) {
            "#{e path} modded but sha1 mismatch. expected: #{e sum}, got: #{sum}" println()
            errs += 1
            continue
        }
    }

    egg printStats()

    if (errs > 0) {
        "#{errs} errors" println()
        exit(1)
    } else {
        "no errors" println()
    }
}

