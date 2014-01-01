
// sdk
import io/File

// ours
import eggplant/[size, tree]

egg_diff: func (oldie, kiddo: String) {
    ot := Tree new(oldie)
    kt := Tree new(kiddo)

    Differ new(ot, kt)

    "egg_diff: stub!" println()
}

Differ: class {
    ot, kt: Tree

    del := Tree new()
    add := Tree new()
    mod := Tree new()
    equ := Tree new()

    init: func (=ot, =kt) {
        ot nodes each(|path, o|
            k := kt nodes get(o path)
            if (!k) {
                del add(o)
            } else if (!k md5 equals?(o md5)) {
                mod add(o)
            } else {
                equ add(o)
            }
        )

        kt nodes each(|path, k|
            o := ot nodes get(k path)
            if (!o) {
                add add(k)
            }
        )

        "#{del size} deleted," println()
        "#{add size} added," println()
        "#{mod size} modified," println()
        "#{equ size} equal" println()
    }
}

