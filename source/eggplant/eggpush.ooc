
// sdk
import io/File
import structs/ArrayList
import os/[Process]

// ours
import eggplant/[warehouse, utils]

egg_push: func {
    w := Warehouse new()

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

    thinkingTime()

    p := Process new(args)
    p setCwd(w base path)
    ret := p execute()
    if (ret != 0) {
        bail("rsync has errors.")
    }
}

