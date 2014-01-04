
// third
use yaml
import yaml/[Document, Parser, Utils]

// sdk
import io/File
import structs/[ArrayList]

Warehouse: class {
    war: MappingNode
    base: File

    init: func {
        base = File new(".")

        while (base != null && !base hasChild?("warehouse.yml")) {
            base = base parent
        }

        if (!base) {
            bail("Not in an eggplant warehouse! (no warehouse.yml found)")
        }

        warFile := File new(base, "warehouse.yml")
        if (!warFile exists?()) {
            bail("Not in an eggplant warehouse? (no warehouse.yml found)")
        }

        parser := YAMLParser new(warFile)
        doc := parser parseDocument()
        war = doc getRootNode() asMap()
    }

    getUser: func -> String {
        war["user"] _
    }

    getHost: func -> String {
        war["host"] _
    }

    getPath: func -> String {
        war["path"] _
    }

    getUrl: func -> String {
        "#{getUser()}@#{getHost()}:#{getPath()}"
    }

}

extend File {

    hasChild?: func (name: String) -> Bool {
        File new(this, name) exists?()
    }

}

bail: func (msg: String) {
    msg println()
    exit(1)
}

