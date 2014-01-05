
// sdk
import io/File

// ours
import eggplant/[repo, utils]

egg_bump: func (channel: String, ver: String) {
    repo := Repo new(File new(".") getAbsoluteFile())

    chans := repo getChannels()
    if (!chans contains?(channel)) {
        bail("Unknown channel #{channel}, can't bump")
    }

    if (ver == "") {
        // default bmp to latest version
        ver = repo getLatest()
    }

    if (ver != "null" && !repo hasVersion?(ver)) {
        bail("Can't bump #{channel} to unknown version #{ver}")
    }

    "Bumping channel #{channel} to version #{ver}" println()
    repo setChannelVersion(channel, ver)
}

