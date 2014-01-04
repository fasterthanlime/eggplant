
// ours
use eggplant
import eggplant/[eggdiff, eggpatch, eggcheck, eggdump, egghone, egglog, eggcommit, eggcheckout, eggpush]

// sdk
import structs/[ArrayList]
import io/[File]

Eggplant: class {

    us := "ep"
    action := "none"
    args: ArrayList<String>

    init: func (=args) {
        us = popArg() // executable path ($0)
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
                ver := popArg()
                kiddo := File new(popArg())
                egg_commit(ver, kiddo)

            case "checkout" =>
                ver := popArg()
                target := File new(popArg())
                egg_checkout(ver, target)

            case "push" =>
                egg_push()

            // help

            case "help" =>
                action = popArg("commands")
                showHelp()

            // fallthrough

            case =>
                "Unknown action: #{action}" println()
                exit(1)
        }
    }

    usage: func {
        match action {
            // egg stuff
            case "diff" =>
                "USAGE: #{us} diff OLDIE KIDDO PATCH.egg"
            case "check" =>
                "USAGE: #{us} check KIDDO PATCH.egg"
            case "hone" =>
                "USAGE: #{us} hone OLDIE PATCH.egg"
            case "patch" =>
                "USAGE: #{us} patch OLDIE PATCH.egg"
            case "dump" =>
                "USAGE: #{us} dump PATCH.egg"

            // repo stuff
            case "log" =>
                "USAGE: #{us} log"
            case "push" =>
                "USAGE: #{us} push"
            case "commit" =>
                "USAGE: #{us} commit VERSION KIDDO"
            case "checkout" =>
                "USAGE: #{us} checkout VERSION TARGET"

            // help
            case "help" =>
                "USAGE: #{us} help COMMAND"

            // general
            case =>
                "USAGE: #{us} ACTION ARGS"
        } println()
    }

    showHelp: func {
        usage()

        match action {
            // egg stuff
            case "diff" =>
                "Computes the difference between two directories, OLDIE" println()
                "and KIDDO, and stores the result along with checksums" println()
                "of the new files in PATCH.egg" println()

            case "check" =>
                "Checks that the KIDDO directory contents corresponds to" println()
                "the checksums in PATCH.egg" println()

            case "hone" =>
                "Checks that the upgrade contained in PATCH.egg would" println()
                "apply cleanly to the OLDIE directory" println()

            case "dump" =>
                "Shows the contents of PATCH.egg (paths and checksums)" println()

            // repo stuff
            case "log" =>
                "Lists all versions contained in a repo" println()

            case "push" =>
                "Push the contents of a warehouse to a remote location using" println()
                "rsync and the settings located in warehouse.yml" println()

            case "commit" =>
                "Builds an .egg that upgrades from the latest known" println()
                "version of the repo we're in, to the state in the KIDDO" println()
                "directory, then adds that version to the repo with both" println()
                "the upgrade .egg (diffs) and a check .egg (only checksums)" println()

            case "checkout" =>
                "Reproduces the content of the repo at a given version in" println()
                "the target directory (created if non-existent). If the target" println()
                "directory is not empty, no files are deleted." println()

            case "commands" =>
                println()
                "Egg commands (low-level interface)" println()
                "----------------------------------" println()
                println()
                " - #{us} diff OLDIE KIDDO PATCH.egg: craft an .egg file to upgrade from OLDIE to KIDDO" println()
                " - #{us} check KIDDO PATCH.egg: check that KIDDO corresponds to post-PATCH.egg state" println()
                " - #{us} hone OLDIE PATCH.egg: check that PATCH.egg applies cleanly to OLDIE" println()
                " - #{us} patch OLDIE PATCH.egg: patch the OLDIE directory with the diff in PATCH.egg" println()
                " - #{us} dump PATCH.egg: dump the contents (paths + checksums) of PATCH.egg" println()

                println()
                "Repo commands (high-level interface)" println()
                "------------------------------------" println()
                println()
                " - #{us} log: display all versions in the current repo" println()
                " - #{us} push: push new objects and eggs to a remote warehouse" println()
                " - #{us} commit VERSION KIDDO: craft an .egg to update repo to KIDDO state & add the version to repo" println()
                " - #{us} checkout VERSION TARGET: reproduce the state of the repo at VERSION in TARGET directory" println()
                println()
                "To get help about a specific command, do '#{us} help COMMAND'" println()

            // general
            case =>
                "Unknown command #{action}, no help found" println()
        }
    }

    popArg: func -> String {
        if (args empty?()) {
            match action {
                case "none" =>
                    action = "commands"
                    showHelp()
                case =>
                    usage()
                    "Do '#{us} help' to get some help" println()
            }
            exit(1)
        }
        args removeAt(0)
    }

    popArg: func ~withAlt (alternative: String) -> String {
        if (args empty?()) {
            return alternative
        }
        args removeAt(0)
    }

}

main: func (args: ArrayList<String>) {
    Eggplant new(args)
}

