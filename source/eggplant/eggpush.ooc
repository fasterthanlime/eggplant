
// sdk
import io/File
import structs/ArrayList
import os/[Time, Process]

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
    "Pushing #{w base path}" println()
    "> #{args join(" ")}" println()

    timeout := 5
    "Giving you #{timeout} secs to change your mind..." println()

    while (timeout > 0) {
        "#{timeout}..." println()
        Time sleepSec(1)
        timeout -= 1
    }

    "There we go." println()

    p := Process new(args)
    p setCwd(w base path)
    ret := p execute()
    if (ret != 0) {
        bail("rsync has errors.")
    }
}

