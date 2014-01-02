
import io/File

extend File {

    getSlashPath: func -> String {
        if (This separator == '/') {
            return path
        }

        path replaceAll(This separator, '/')
    }

}
