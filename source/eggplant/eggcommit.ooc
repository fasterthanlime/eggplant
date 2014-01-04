
// sdk
import io/File
import math/Random

// ours
import eggplant/[egg, tree, buffer, repo]
import eggplant/[eggdiff, eggcheckout]

egg_commit: func (ver: String, kiddo: File) {
    repo := Repo new(File new("."))
    latest := repo getLatest()

    errs := 0

    kt := Tree new(kiddo)

    oldie := tmpdir()
    if (latest != "null") {
        egg_checkout(latest, oldie)
    }
    ot := Tree new(oldie)

    upgrade := repo eggFile("#{latest}-to-#{ver}.egg")
    "Writing ugprade egg to #{upgrade}" println()
    egg_tree_diff(ot, kt, upgrade)

    check := repo eggFile("#{ver}.egg")
    "Writing ugprade egg to #{check}" println()
    egg_tree_diff(kt, kt, check)

    "Storing objects in repo #{repo getName()}" println()
    repo store(kt)

    "Adding versions to repo #{repo getName()}" println()
    repo addVersion(ver, upgrade getName(), check getName())

    "Removing oldie tmp dir" println()
    oldie rm_rf()

    if (errs > 0) {
        "#{errs} errors" println()
        exit(1)
    } else {
        "no errors" println()
    }
}

tmpdir: func -> File {
    f := File new("./tmp-checkout-#{Random randInt(100000, 999999)}")
    f mkdirs()
    f
}

