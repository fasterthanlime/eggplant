
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

thinkingTime: func {
    timeout := 5
    "Giving you #{timeout} secs to change your mind... (Hit Ctrl-C to abort)" println()

    while (timeout > 0) {
        "#{timeout}..." println()
        Time sleepSec(1)
        timeout -= 1
    }
    "There we go." println()
}

