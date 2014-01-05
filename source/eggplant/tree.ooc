
// sdk
import io/File
import structs/[ArrayList, HashMap]

// ours
import eggplant/[sha1, utils]

Tree: class {

    file: File
    nodes := HashMap<String, TreeNode> new()

    init: func ~build (=file) {
        if (file) {
            file walk(|f|
                add(TreeNode new(this, f))
                true
            )
        }
    }

    getPath: func -> String {
        file ? file path : "<null>"
    }

    init: func ~empty

    add: func (node: TreeNode) {
        nodes put(node path, node)
    }

    size: Int { get {
        nodes size
    } }

}

TreeNode: class {
    tree: Tree

    file: File
    path: String

    size: SizeT
    sum: SHA1Sum

    init: func (=tree, =file) {
        path = file rebase(tree file) getSlashPath()
        size = file getSize()
        sum = SHA1 sum(file)
    }
}

