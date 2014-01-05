
// sdk
import io/File
import os/Time

// ours
import  eggplant/egg

extend File {

    getSlashPath: func -> String {
        if (This separator == '/') {
            return path
        }

        path replaceAll(This separator, '/')
    }

    hasChild?: func (name: String) -> Bool {
        File new(this, name) exists?()
    }

    eggFlags: func -> UInt8 {
        flags := 0x0
        if (executable?()) {
            flags |= EggFlags EXC
        }
        flags
    }

}

bail: func (msg: String) {
    msg println()
    exit(1)
}

ASK_QUESTIONS := true

confirm: func -> Bool {
    if (!ASK_QUESTIONS) {
        "Have no questions, continuing..." println()
        return true
    }

    "Are you sure you want to go ahead? [y/N]" println()
    c := stdin readChar()
    match (c toLower()) {
        case 'y' =>
            true
        case =>
            false
    }
}

