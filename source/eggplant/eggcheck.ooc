
// sdk
import io/File

// ours
import eggplant/[egg, tree, buffer, faillog]

egg_check: func (kiddo, patch: File) {
    kt := Tree new(kiddo)
    egg := Egg new(patch)

    log := FailLog new()

    errs := 0

    for (e in egg del) {
        if (kt nodes contains?(e path)) {
            errs += 1
            "#{e path} should not be there anymore" println()
        }
    }

    for (e in egg add) {
        n := kt nodes get(e path)
        if (!n) {
            errs += 1
            log add(e path, e flags, e sum, e size)
            "#{e path} should be there" println()
            continue
        }

        if (!n sum equals?(e sum)) {
            errs += 1
            log add(e path, e flags, e sum, e size)
            "#{e path} sha1 mismatch, expected: #{e sum}, got #{n sum}" println()
        }
    }

    for (e in egg mod) {
        n := kt nodes get(e path)
        if (!n) {
            errs += 1
            log add(e path, e flags, e sum, e size)
            "#{e path} should be there" println()
            continue
        }

        if (!n sum equals?(e sum)) {
            errs += 1
            log add(e path, e flags, e sum, e size)
            "#{e path} sha1 mismatch, expected: #{e sum}, got #{n sum}" println()
        }
    }

    for (e in egg equ) {
        n := kt nodes get(e path)
        if (!n) {
            errs += 1
            log add(e path, e flags, e sum, e size)
            "#{e path} should be there" println()
            continue
        }

        if (!n sum equals?(e sum)) {
            errs += 1
            log add(e path, e flags, e sum, e size)
            "#{e path} sha1 mismatch, expected: #{e sum}, got #{n sum}" println()
        }
    }

    egg printStats()

    log write()

    if (errs > 0) {
        "#{errs} errors" println()
        exit(1)
    } else {
        "no errors" println()
    }
}

