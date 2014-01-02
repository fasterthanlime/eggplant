
// sdk
import io/File

// ours
import eggplant/[size, tree, egg, bsdiff, sha1, buffer]

egg_diff: func (oldie, kiddo: File) -> Egg {
    ot := Tree new(oldie)
    kt := Tree new(kiddo)

    d := Differ new(ot, kt)
    d egg()
}

Differ: class {
    ot, kt: Tree

    init: func (=ot, =kt)

    egg: func -> Egg {
        egg := Egg new()

        ot nodes each(|path, o|
            k := kt nodes get(o path)
            if (!k) {
                egg del add(EggPath new(EggMagic DEL, o path))
            } else if (!k sha1 equals?(o sha1)) {
                "Modified: #{k path}" println()
                diff := BSDiff diff(o file, k file)
                sum := SHA1 sum(k file)
                egg mod add(EggDiff new(k path, diff, sum))
            } else {
                egg equ add(EggPath new(EggMagic EQU, o path))
            }
        )

        kt nodes each(|path, k|
            o := ot nodes get(k path)
            if (!o) {
                buffer := EggBuffer new(k file)
                sum := SHA1 sum(k file)
                egg add add(EggData new(k path, buffer, sum))
            }
        )

        "#{egg del size} deleted," println()
        "#{egg add size} added," println()
        "#{egg mod size} modified," println()
        "#{egg equ size} equal" println()

        egg
    }
}

