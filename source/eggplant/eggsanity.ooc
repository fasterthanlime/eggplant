
// sdk
import io/File
import structs/HashMap

// ours
import eggplant/[egg, tree, buffer, repo, utils, sha1]

egg_sanity: func {
    repo := Repo new(File new("."))

    errs := 0
    vers := repo getVersions()
    missings := HashMap<String, String> new()

    checkSingle := func (egg: Egg, sum: SHA1Sum) {
        ss := sum toString()
        f := repo objFile(ss)
        if (!f exists?()) {
            if (!missings contains?(ss)) {
                missings put(ss, ss)
                "Missing object: #{ss} for egg: #{egg file path}" println()
                errs += 1
            } else {
                // already warned about that.
            }
        }
    }

    for (ver in vers) {
        up := repo versionEgg(ver, "upgrade")
        if (!up exists?()) {
            "Missing update egg: #{up path}" println()
            errs += 1
        }

        ck := repo versionEgg(ver, "check")
        if (!ck exists?()) {
            "Missing check egg: #{up path}" println()
            errs += 1
            continue
        }

        egg := Egg new(ck)
        for (e in egg equ) { checkSingle(egg, e sum) }
        for (e in egg add) { checkSingle(egg, e sum) }
        for (e in egg mod) { checkSingle(egg, e sum) }
    }

    if (errs > 0) {
        "#{errs} errors" println()
        exit(1)
    } else {
        "no errors" println()
    }
}

