
// sdk
import io/File

// ours
import eggplant/[egg, tree, bsdiff, sha1, buffer]

egg_patch: func (oldie, patch: File) {
    ot := Tree new(oldie)
    egg := Egg new(patch)

    errs := 0

    for (e in egg del) {
        n := ot nodes get(e path)

        if (n) {
            // delete that shit
            n file rm()
        } else {
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
        target := File new(ot file, e path)
        e buffer write(target)

        sum := SHA1 sum(target)
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

        news := BSDiff patch(n file, e buffer)
        sum := SHA1 sum(news)

        if (sum equals?(e sum)) {
            news write(n file)
        } else {
            "#{e path} to be modded but sha1 mismatch. expected: #{e sum}, got: #{sum}" println()
            errs += 1
            continue
        }
        news free()

        sum = SHA1 sum(n file)
        if (!sum equals?(e sum)) {
            "#{e path} was modded but sha1 mismatch. expected: #{e sum}, got: #{sum}" println()
            errs += 1
            continue
        }
    }
    egg printStats()
    "Done!" println()
}
