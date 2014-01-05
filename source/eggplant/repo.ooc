
// third
use yaml
import yaml/[Document, Parser, Utils]

// sdk
import io/File
import structs/[ArrayList]

// ours
import eggplant/[tree, utils, buffer, sha1, egg]

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
        File new(folder, "eggs/#{name}")
    }

    objFile: func (sum: String) -> File {
        prefix1 := sum[0..1]
        prefix2 := sum[1..2]
        full := "objects/#{prefix1}/#{prefix2}/#{sum}"
        File new(folder, full)
    }

    store: func (tree: Tree) {
        tree nodes each(|path, node|
            dest := objFile(node sum toString())

            if (dest exists?()) {
                // Already have it. Joy! Check it again just in case.
                exsum := SHA1 sum(dest)
                if (!exsum equals?(node sum)) {
                    // rewrite it then
                    "#{dest path} was corrupted, rewriting" println()
                    dest rm()
                }
            }
            
            if (!dest exists?()) {
                buf := EggBuffer new(node file)
                buf write(dest)
                buf free()
            }
        )
    }

    checkout: func (egg: Egg, target: File) {
        doSingle := func (path: String, sum: SHA1Sum) {
            obj := objFile(sum toString())
            dest := File new(target, path)

            buf := EggBuffer new(obj)
            buf write(dest)
            buf free()
        }

        for (e in egg equ) { doSingle(e path, e sum) }
        for (e in egg add) { doSingle(e path, e sum) }
        for (e in egg mod) { doSingle(e path, e sum) }
    }

    addVersion: func (ver: String, upName, checkName: String) {
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

