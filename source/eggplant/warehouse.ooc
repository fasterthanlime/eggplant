
// third
use yaml
import yaml/[Document, Parser, Utils]

// sdk
import io/File
import structs/[ArrayList]

// ours
import eggplant/[utils]

Warehouse: class {
    war: MappingNode
    base: File

    init: func {
        base = File new(".") getAbsoluteFile()

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

    getRepos: func -> ArrayList<File> {
        repos := ArrayList<File> new()
        children := base getChildren()
        for (c in children) {
            if (!c dir?()) continue
            idx := File new(c, "index.yml")
            if (idx exists?()) {
                repos add(c)
            }
        }
        repos
    }

    getUrl: func -> String {
        "#{getUser()}@#{getHost()}:#{getPath()}"
    }

}

