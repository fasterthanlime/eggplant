
// ours
use eggplant
import eggplant/[eggdiff, eggpatch, eggcheck, eggdump, egghone]

// sdk
import structs/[ArrayList]
import io/[File]

Eggplant: class {

    args: ArrayList<String>

    init: func (=args) {
        popArg() // ours
        action := popArg()

        match action {
            case "diff" =>
                oldie := File new(popArg())
                kiddo := File new(popArg())
                patch := File new("plant.egg")
                egg_diff(oldie, kiddo, patch)
            case "check" =>
                kiddo := File new(popArg())
                patch := File new(popArg())
                egg_check(kiddo, patch)
            case "hone" =>
                oldie := File new(popArg())
                patch := File new(popArg())
                egg_hone(oldie, patch)
            case "patch" =>
                oldie := File new(popArg())
                patch := File new(popArg())
                egg_patch(oldie, patch)
            case "dump" =>
                patch := File new(popArg())
                egg_dump(patch)
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

