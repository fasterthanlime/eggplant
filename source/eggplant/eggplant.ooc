
// ours
use eggplant
import eggplant/[eggdiff, eggpatch, eggcheck, eggdump, egghone, egglog, eggcommit, eggcheckout, eggpush]

// sdk
import structs/[ArrayList]
import io/[File]

Eggplant: class {

    action := "null"
    args: ArrayList<String>

    init: func (=args) {
        popArg() // executable path ($0)
        action = popArg()

        match action {
            case "diff" =>
                oldie := File new(popArg())
                kiddo := File new(popArg())
                patch := File new(popArg())
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
            // repo methods
            case "log" =>
                egg_log()
            case "commit" =>
                kiddo := File new(popArg())
                patch := File new(popArg())
                egg_commit(kiddo, patch)
            case "checkout" =>
                target := File new(popArg())
                ver := popArg()
                egg_checkout(target, ver)
            case "push" =>
                egg_push()
            case =>
                "Unknown action: #{action}" println()
                exit(1)
        }
    }

    usage: func {
        match action {
            case "diff" =>
                "USAGE: eggplant diff OLDIE KIDDO PATCH.egg"
            case "check" =>
                "USAGE: eggplant diff KIDDO PATCH.egg"
            case "hone" =>
                "USAGE: eggplant diff OLDIE PATCH.egg"
            case "patch" =>
                "USAGE: eggplant diff OLDIE PATCH.egg"
            case "dump" =>
                "USAGE: eggplant dump PATCH.egg"
            case =>
                "USAGE: eggplant ACTION ARGS"
        } println()
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

