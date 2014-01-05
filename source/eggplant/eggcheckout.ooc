
// sdk
import io/File

// ours
import eggplant/[egg, tree, buffer, repo, utils]

egg_checkout: func (ver: String, target: File) {
    egg := egg_checkout_silent(ver, target)
    "Done! #{egg nodeCount()} files created." println()
}

egg_checkout_silent: func (ver: String, target: File) -> Egg {
    repo := Repo new(File new("."))

    vers := repo getVersions()
    if (!vers contains?(ver)) {
        bail("Unknown version #{ver} in repo #{repo getName()}")
    }

    ck := repo versionEgg(ver, "check")
    egg := Egg new(ck)
    repo checkout(egg, target)
    egg
}

