
// sdk
import io/File
import structs/ArrayList
import os/Process

// ours
import eggplant/[warehouse]

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
    "> #{args join(" ")}" println()

    p := Process new(args)
    p setCwd(w base getAbsolutePath())
    ret := p execute()
    if (ret != 0) {
        bail("rsync has errors.")
    }
}

