
Size: class {

    format: static func (bytes: SizeT) -> String {
        kils: SizeT = 0
        megs: SizeT = 0

        kilNum : SizeT = 1024
        megNum : SizeT = 1024 * 1024

        if (bytes > megNum) {
            megs  = bytes / megNum
            bytes -= megs * megNum
        }

        if (bytes > kilNum) {
            kils  = bytes / kilNum
            bytes -= kils * kilNum
        }

        res := Buffer new()
        if (megs > 0) {
            res append("#{megs} MiB + ")
        }
        if (kils > 0) {
            res append("#{kils} KiB + ")
        }
        res append("#{bytes} B")
        res toString()
    }

}
