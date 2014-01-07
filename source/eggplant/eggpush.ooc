
// sdk
import io/File
import structs/ArrayList
import os/[Process]

// ours
import eggplant/[warehouse, utils]
import eggplant/[eggsanity]

egg_push: func {
    w := Warehouse new()

    "Doing a few sanity checks first..." println()
    repos := w getRepos()
    for (r in repos) {
        "#{r name}... " print()
        egg_sanity_for(r)
    }

    args := ArrayList<String> new()
    args add("rsync")
    args add("--archive")
    args add("--delete")
    args add("--progress")
    args add("--human-readable")
    args add("--rsh=ssh")
    args add(".") // src
    args add(w getUrl()) // dst
    "Will push #{w base path}, launching the following command:" println()
    "> #{args join(" ")}" println()

    if (!confirm()) {
        bail("Aborted by user demand.")
    }

    p := Process new(args)
    p setCwd(w base path)
    ret := p execute()
    if (ret != 0) {
        bail("rsync has errors.")
    }
}

