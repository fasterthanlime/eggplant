
// sdk
import io/File

// ours
import eggplant/[size, tree, egg, bsdiff, sha1, buffer, utils]

egg_diff: func (oldie, kiddo, patch: File) {
    ot := Tree new(oldie)
    kt := Tree new(kiddo)
    egg_tree_diff(ot, kt, patch)
}

egg_tree_diff: func (ot, kt: Tree, patch: File) -> Egg {
    d := Differ new(ot, kt)
    egg := d egg()
    egg write(patch)
    egg printStats()
    egg
}

Differ: class {
    ot, kt: Tree

    init: func (=ot, =kt)

    egg: func -> Egg {
        egg := Egg new()

        ot nodes each(|path, o|
            k := kt nodes get(o path)
            if (!k) {
                egg del add(EggDel new(o path))
            } else if (!k sum equals?(o sum)) {
                "Modified: #{k path}" println()
                diff := BSDiff diff(o file, k file)
                sum := SHA1 sum(k file)
                egg mod add(EggMod new(k path, k file eggFlags(), sum, diff))
            } else {
                egg equ add(EggEqu new(k path, k file eggFlags(), k sum))
            }
        )

        kt nodes each(|path, k|
            o := ot nodes get(k path)
            if (!o) {
                buffer := EggBuffer new(k file)
                sum := SHA1 sum(k file)
                egg add add(EggAdd new(k path, k file eggFlags(), sum, buffer))
            }
        )

        egg
    }
}

