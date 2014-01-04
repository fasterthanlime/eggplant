
// third
use yaml
import yaml/[Document, Parser]

// sdk
import io/File

// ours
import eggplant/[repo]

egg_log: func {
    r := Repo new(File new(".") getAbsoluteFile())

    "Channels: " println()

    for (c in r getChannels()) {
        v := r channelVersion(c)
        "- #{v} (#{c} channel)" println()
    }

    "Log: " println()

    for (v in r getVersions()) {
        "- #{v}" println()
    }
}
