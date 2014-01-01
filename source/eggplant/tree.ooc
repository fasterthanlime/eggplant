
// sdk
import io/File
import structs/ArrayList

// ours
import eggplant/[md5]

Tree: class {

    file: File
    nodes := ArrayList<TreeNode> new()

    init: func (path: String) {
        file = File new(path)

        file walk(|f|
            nodes add(TreeNode new(this, f))
            true
        )

        "For tree #{file path}, got #{nodes size} nodes" println()
    }

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
        "New node, path = #{path}, md5 = #{md5}" println()
    }
}

