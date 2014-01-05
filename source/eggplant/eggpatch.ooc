
// sdk
import io/File

// ours
import eggplant/[egg, tree, bsdiff, sha1, buffer, faillog]

egg_patch: func (oldie, patch: File) {
    ot := Tree new(oldie)
    egg := Egg new(patch)

    log := FailLog new()

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
            log add(e path, e flags, e sum)
            continue
        }

        if (e executable?() != n file executable?()) {
            n file setExecutable(e executable?())
        }
    }

    for (e in egg add) {
        target := File new(ot file, e path)
        e buffer write(target)
        if (e executable?()) {
            target setExecutable(true)
        }

        sum := SHA1 sum(target)
        if (!sum equals?(e sum)) {
            "#{e path} added but sha1 mismatch. expected: #{e sum}, got: #{sum}" println()
            errs += 1
            log add(e path, e flags, e sum)
            continue
        }
    }

    for (e in egg mod) {
        n := ot nodes get(e path)

        if (!n) {
            "#{e path} should be there so we can mod it" println()
            errs += 1
            log add(e path, e flags, e sum)
            continue
        }

        news := BSDiff patch(n file, e buffer)
        sum := SHA1 sum(news)

        if (sum equals?(e sum)) {
            news write(n file)
            news free()
            n file setExecutable(e executable?())
        } else {
            news free()
            if (SHA1 sum(n file) equals?(e sum)) {
                "#{e path} was already modded?" println()
                continue
            } else {
                "#{e path} to be modded but sha1 mismatch. expected: #{e sum}, got: #{sum}" println()
                errs += 1
                log add(e path, e flags, e sum)
                continue
            }
        }

        sum = SHA1 sum(n file)
        if (!sum equals?(e sum)) {
            "#{e path} was modded but sha1 mismatch. expected: #{e sum}, got: #{sum}" println()
            errs += 1
            log add(e path, e flags, e sum)
            continue
        }
    }
    egg printStats()
    if (errs > 0) {
        "Had #{errs} oddities." println()
    }

    log write()

    if (errs > 0) {
        "#{errs} errors" println()
        exit(1)
    } else {
        "no errors" println()
    }
}
