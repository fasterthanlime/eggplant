
// sdk
import io/File

// ours
import eggplant/[repo]

egg_log: func {
    r := Repo new(File new(".") getAbsoluteFile())

    "[#{r getName()}]" println()

    "Channels: " println()
    chans := r getChannels()
    if (chans empty?()) {
        "(no channels)" println()
    } else for (c in chans) {
        v := r channelVersion(c)
        "- #{v} (#{c} channel)" println()
    }

    println()

    "Versions: " println()
    vers := r getVersions()
    if (vers empty?()) {
        "(no versions)" println()
    } else for (v in vers) {
        "- #{v}" println()
    }
}

