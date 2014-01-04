
// third
use yaml
import yaml/[Document, Parser]

// sdk
import io/File

// ours
import eggplant/[repo]

egg_log: func {
    r := Repo new(File new(".") getAbsoluteFile())
}
