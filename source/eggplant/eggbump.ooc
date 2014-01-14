
// sdk
import io/File

// ours
import eggplant/[repo, utils]

egg_bump: func (channel: String, ver: String) {
    repo := Repo new(File new(".") getAbsoluteFile())

    if (ver == "") {
        // default: bump to latest version
        ver = repo getLatest()
    }

    if (ver != "null" && !repo hasVersion?(ver)) {
        bail("Can't bump #{channel} to unknown version #{ver}")
    }


    chans := repo getChannels()

    match channel {
        case "@all" =>
            if (chans empty?()) {
                "No channels to bump!" println()
            } else for (c in chans) {
                egg_do_bump(repo, c, ver)
            }
        case =>
            if (!chans contains?(channel)) {
                bail("Unknown channel #{channel}, can't bump")
            }
            egg_do_bump(repo, channel, ver)
    }
}

egg_do_bump: func (repo: Repo, channel: String, ver: String) {
    "Bumping channel #{channel} to version #{ver}" println()
    repo setChannelVersion(channel, ver)
}

