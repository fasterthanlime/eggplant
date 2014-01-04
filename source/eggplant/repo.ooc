
// third
use yaml
import yaml/[Document, Parser]

// sdk
import io/File
import structs/[ArrayList]

// ours
import eggplant/yaml

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

        parser := YAMLParser new()
        parser setInputFile(idxFile)
        doc := parser parseDocument()
        index = doc getRootNode() asMap()
    }

    getVersions: func -> ArrayList<String> {
        list := ArrayList<String> new()
        index["versions"] each(|name, val|
            list add(name)
        )
        list
    }

    getChannels: func -> ArrayList<String> {
        list := ArrayList<String> new()
        index["channels"] each(|name, val|
            list add(name)
        )
        list
    }

}

bail: func (msg: String) {
    msg println()
    exit(1)
}
