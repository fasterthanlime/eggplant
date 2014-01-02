
// sdk
import io/File

// ours
import eggplant/[egg, tree, buffer]

egg_check: func (oldie, patch: File) {
    ot := Tree new(oldie)
    egg := Egg new(patch)

    errs := 0

    for (e in egg del) {
        if (ot nodes contains?(e path)) {
            errs += 1
            "#{e path} should not be there anymore" println()
        }
    }

    for (e in egg add) {
        n := ot nodes get(e path)
        if (!n) {
            errs += 1
            "#{e path} should be there" println()
            continue
        }

        if (!n sum equals?(e sum)) {
            errs += 1
            "#{e path} sha1 mismatch, expected: #{e sum}, got #{n sum}" println()
        }
    }

    for (e in egg mod) {
        n := ot nodes get(e path)
        if (!n) {
            errs += 1
            "#{e path} should be there" println()
            continue
        }

        if (!n sum equals?(e sum)) {
            errs += 1
            "#{e path} sha1 mismatch, expected: #{e sum}, got #{n sum}" println()
        }
    }

    for (e in egg equ) {
        n := ot nodes get(e path)
        if (!n) {
            errs += 1
            "#{e path} should be there" println()
            continue
        }

        if (!n sum equals?(e sum)) {
            errs += 1
            "#{e path} sha1 mismatch, expected: #{e sum}, got #{n sum}" println()
        }
    }

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

