
// sdk
import io/File
import structs/[ArrayList, HashMap]

// ours
import eggplant/[sha1]

Tree: class {

    file: File
    nodes := HashMap<String, TreeNode> new()

    init: func ~build (path: String) {
        file = File new(path)

        file walk(|f|
            add(TreeNode new(this, f))
            true
        )

        "For tree #{file path}, got #{nodes size} nodes" println()
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
    sha1: SHA1Sum

    init: func (=tree, =file) {
        path = file rebase(tree file) path
        size = file getSize()
        sha1 = SHA1 sum(file)
    }
}

