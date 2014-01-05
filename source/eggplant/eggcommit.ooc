
// sdk
import io/File
import math/Random

// ours
import eggplant/[egg, tree, buffer, repo, utils]
import eggplant/[eggdiff, eggcheckout]

egg_commit: func (ver: String, kiddo: File) {
    repo := Repo new(File new("."))
    latest := repo getLatest()

    vers := repo getVersions()
    if (vers contains?(ver)) {
        bail("Can't commit version #{ver} as it already exists!")
    }

    "Committing #{ver} as current state of #{kiddo path}" println()

    // explore new version directory
    kt := Tree new(kiddo)

    // check out old version in temp directory
    oldie := tmpdir()
    if (latest != "null") {
        // null is a special bootstrap case - otherwise
        egg_checkout_silent(latest, oldie)
    }
    ot := Tree new(oldie)

    // build upgrade egg
    upgrade := repo eggFile("#{latest}-to-#{ver}.egg")
    egg_tree_diff(ot, kt, upgrade)

    // remove old, temporary directory
    oldie rm_rf()

    // build check egg
    check := repo eggFile("#{ver}.egg")
    egg_tree_diff(kt, kt, check)

    // store objects
    repo store(kt)

    // store version with egg paths
    repo addVersion(ver, upgrade getName(), check getName())

    "Version #{ver} was stored successfully." println()
}

tmpdir: func -> File {
    f := File new("./tmp-checkout-#{Random randInt(100000, 999999)}")
    f mkdirs()
    f
}

