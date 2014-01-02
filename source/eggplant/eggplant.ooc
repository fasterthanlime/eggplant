
// ours
use eggplant
import eggplant/[eggdiff, eggpatch, egg, xz]
import eggplant/sillytest

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
                oldie := popArg()
                kiddo := popArg()
                egg := egg_diff(oldie, kiddo)
                src := File new("plant.egg")
                egg write(src)
                dst := File new("plant.egg.xz")
                "Compressing..." println()
                XZ compress(src, dst)
                "Done!" println()
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

