
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

    latest := repo getLatest()
    if (ver != latest) {
        bail("Can't nuke version #{ver} as it would break upgrade path. Latest is #{latest}.")
    }

    chans := repo getChannels()
    for (c in chans) {
        cver := repo channelVersion(c)
        if (cver == ver) {
            bail("Can't nuke version #{ver}, it's used by channel #{c}")
        }
    }

    up := repo versionEgg(ver, "upgrade")
    ck := repo versionEgg(ver, "check")

    "This will completely remove version #{ver} from repo #{repo getName()}" println()
    if (!confirm()) {
        bail("Aborted by user demand.")
    }

    up rm()
    ck rm()

    repo removeVersion(ver)
    "Done!" println()
}

