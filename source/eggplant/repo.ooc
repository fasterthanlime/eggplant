
// third
use yaml
import yaml/[Document, Parser, Utils]

// sdk
import io/File
import structs/[ArrayList]

// ours
import eggplant/[tree, utils]

/**
 * An eggplant repo
 */
Repo: class {
    folder: File
    index: MappingNode

    init: func (.folder) {
        this folder = folder getAbsoluteFile()
        refreshIndex()
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

    versionEgg: func (ver, type: String) -> File {
        eggFile(index["versions"][ver][type] _)
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

        node := MappingNode new()
        node["upgrade"] = upName
        node["check"] = checkName
        index["versions"][ver] = node

        saveAndRefresh()
    }

    removeVersion: func(ver: String) {
        index["versions"] asMap() map remove(ver)
        index write(getIndexFile())
        // re-read YAML file after writing it
        refreshIndex()
    }

    // loading/writing stuff

    getIndexFile: func -> File {
        File new(folder, "index.yml")
    }

    saveAndRefresh: func {
        index write(getIndexFile())
        refreshIndex()
    }

    refreshIndex: func {
        idxFile := getIndexFile()
        if (!idxFile exists?()) {
            bail("Not in an eggplant repo! (no index.yml) Bailing out.")
        }

        parser := YAMLParser new(idxFile)
        doc := parser parseDocument()
        index = doc getRootNode() asMap()
    }

}

