
use eggplant
import eggplant/[eggdiff, eggpatch]
import eggplant/sillytest

import bsdiff

// sdk
import structs/[ArrayList]

Eggplant: class {

    args: ArrayList<String>

    init: func (=args) {
        popArg() // ours
        action := popArg()

        match action {
            case "diff" =>
                oldie := popArg()
                kiddo := popArg()
                egg_diff(oldie, kiddo)
            case "patch" =>
                diff := popArg()
                patch := popArg()
                egg_patch(diff, patch)
            case "test" =>
                sillytest()
                exit(0)
            case =>
                "Unknown action: #{action}" println()
                exit(1)
        }
    }

    usage: func {
        "USAGE: eggplant ACTION ARGS" println()
    }

    popArg: func -> String {
        if (args empty?()) {
            usage()
            exit(1)
        }
        args removeAt(0)
    }

}

main: func (args: ArrayList<String>) {
    Eggplant new(args)
}

