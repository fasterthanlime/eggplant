
// sdk
import io/File

// third
use yaml
import yaml/[Document, Emitter, Utils]

// ours
import eggplant/[egg, buffer, sha1, utils]

FailLog: class {
    root: MappingNode
    list: SequenceNode

    init: func {
        root = MappingNode new()

        list = SequenceNode new()
        root["items"] = list
    }
    
    add: func (path: String, flags: UInt8, sum: SHA1Sum) {
        map := MappingNode new()
        map["path"] = path
        map["exec"] = ((flags & EggFlags EXC) != 0) toString()
        map["sha1"] = sum toString()
        list nodes add(map)
    }

    write: func {
        file := File tmpfile("faillog")
        root write(file)
        buffer := EggBuffer new(file)
        stderr write(buffer toString())
        buffer free()
        file rm()
    }

}

