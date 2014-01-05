
// sdk
import io/File

// ours
import eggplant/[egg, tree, buffer, repo, utils]
import eggplant/[eggdiff, eggcheckout]

egg_nuke: func (ver: String) {
    repo := Repo new(File new("."))

    vers := repo getVersions()
    if (!vers contains?(ver)) {
        bail("Unknown version #{ver} in repo #{repo getName()}")
    }

    up := repo versionEgg(ver, "upgrade")
    ck := repo versionEgg(ver, "check")

    "This will remove all traces of version #{ver} from repo #{repo getName()}" println()
    "This will delete the file #{up path}" println()
    "This will delete the file #{ck path}" println()
    if (!confirm()) {
        bail("Aborted by user demand.")
    }

    up rm()
    ck rm()

    repo removeVersion(ver)
    "Done!" println()
}

