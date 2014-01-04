
// third
use yaml
import yaml/[Document, Parser, Utils]

// sdk
import io/File
import structs/[ArrayList]

// ours
import eggplant/[tree]

/**
 * An eggplant repo
 */
Repo: class {
    folder: File
    index: MappingNode

    init: func (=folder) {
        idxFile := File new(folder, "index.yml")
        if (!idxFile exists?()) {
            bail("Not in an eggplant repo! (no index.yml) Bailing out.")
        }

        parser := YAMLParser new(idxFile)
        doc := parser parseDocument()
        index = doc getRootNode() asMap()
    }

    getName: func -> String {
        folder getName()
    }

    getVersions: func -> ArrayList<String> {
        list := ArrayList<String> new()
        index["versions"] each(|name, val|
            list add(name)
        )
        list
    }

    getLatest: func -> String {
        vers := getVersions()
        if (vers empty?()) {
            return "null"
        }
        vers last()
    }

    getChannels: func -> ArrayList<String> {
        list := ArrayList<String> new()
        index["channels"] each(|name, val|
            list add(name)
        )
        list
    }

    channelVersion: func (chan: String) -> String {
        index["channels"][chan] _
    }

    eggFile: func (name: String) -> File {
        File new(folder, "eggs/#{name}.egg")
    }

    store: func (tree: Tree) {
        "Storing #{tree getPath()} in repo #{getName()}" println()
        "stub" println()
    }

    addVersion: func (ver: String, upName, checkName: String) {
        "Storing version #{ver} (upName #{upName}, checkName #{checkName}) in repo #{getName()}" println()
        "stub" println()
    }

}

bail: func (msg: String) {
    msg println()
    exit(1)
}

