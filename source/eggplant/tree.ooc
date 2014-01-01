
// sdk
import io/File
import structs/[ArrayList, HashMap]

// ours
import eggplant/[md5]

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
    md5: MD5Sum

    init: func (=tree, =file) {
        path = file rebase(tree file) path
        size = file getSize()
        md5 = MD5 sum(file)
    }
}

