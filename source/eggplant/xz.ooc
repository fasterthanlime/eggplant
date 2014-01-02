
include lzma

// ours
import eggplant/[buffer]

// sdk
import io/[File, FileReader, FileWriter]

XZ: class {

    preset: static UInt32 = 9
    bufSize: static SizeT = 16384

    compress: static func (src, dst: File) -> Bool {

        inbuf := EggBuffer new(bufSize)
        outbuf := EggBuffer new(bufSize)

        stream := LZMA_STREAM_INIT
        {
            ret := lzma_easy_encoder(stream&, preset, LZMA_CHECK_CRC64)
            if (ret != LZMA_OK) {
                match ret {
                    case LZMA_MEM_ERROR =>
                        raise("lzma: Memory allocation failed")
                    case LZMA_OPTIONS_ERROR =>
                        raise("lzma: Specified preset is not supported")
                    case LZMA_UNSUPPORTED_CHECK =>
                        raise("lzma: Specified integrity check is not supported")
                    case =>
                        raise("lzma: Unknown error, possibly a bug!")
                }
            }
        }

        action := LZMA_RUN

        stream next_in = null
        stream avail_in = 0
        stream next_out = outbuf data
        stream avail_out = outbuf size

        fR := FileReader new(src)
        fW := FileWriter new(dst)

        while (true) {
            // Fill the input buffer if it is empty.
            if (stream avail_in == 0 && fR hasNext?()) {
                stream next_in = inbuf data
                stream avail_in = fR read(inbuf data, 0, inbuf size)

                if (!fR hasNext?()) {
                    action = LZMA_FINISH
                }
            }

            // Tell liblzma do the actual encoding.
            ret := lzma_code(stream&, action)

            if (stream avail_out == 0 || ret == LZMA_STREAM_END) {
                writeSize := outbuf size - stream avail_out

                if (fW write(outbuf data, writeSize) != writeSize) {
                    raise("lzma: Write error")
                }

                // reset next_out and avail_out
                stream next_out = outbuf data
                stream avail_out = outbuf size
            }

            if (ret != LZMA_OK) {
                if (ret == LZMA_STREAM_END) {
                    fR close()
                    fW close()
                    break
                }

                match ret {
                    case LZMA_MEM_ERROR =>
                        raise("lzma: Memory allocation failed")
                    case LZMA_DATA_ERROR =>
                        raise("lzma: File size limits exceeded")
                    case =>
                        raise("lzma: Unknown error, possibly a bug #{ret}")
                }
            }
        }

        lzma_end(stream&)

        inbuf free()
        outbuf free()
        true
    }

    decompress: static func (src, dst: File) -> Bool {
        inbuf := EggBuffer new(bufSize)
        outbuf := EggBuffer new(bufSize)

        stream := LZMA_STREAM_INIT
        {
            ret := lzma_stream_decoder(stream&, UINT32_MAX, LZMA_CONCATENATED)
            if (ret != LZMA_OK) {
                match ret {
                    case LZMA_MEM_ERROR =>
                        raise("lzma: Memory allocation failed")
                    case LZMA_OPTIONS_ERROR =>
                        raise("lzma: Unsupported decompressor flag")
                    case =>
                        raise("lzma: Unknown error, possibly a bug!")
                }
            }
        }

        action := LZMA_RUN

        stream next_in = null
        stream avail_in = 0
        stream next_out = outbuf data
        stream avail_out = outbuf size

        fR := FileReader new(src)
        fW := FileWriter new(dst)

        while (true) {
            // Fill the input buffer if it is empty.
            if (stream avail_in == 0 && fR hasNext?()) {
                stream next_in = inbuf data
                stream avail_in = fR read(inbuf data, 0, inbuf size)

                if (!fR hasNext?()) {
                    action = LZMA_FINISH
                }
            }

            // Tell liblzma do the actual encoding.
            ret := lzma_code(stream&, action)

            if (stream avail_out == 0 || ret == LZMA_STREAM_END) {
                writeSize := outbuf size - stream avail_out

                if (fW write(outbuf data, writeSize) != writeSize) {
                    raise("lzma: Write error")
                }

                // reset next_out and avail_out
                stream next_out = outbuf data
                stream avail_out = outbuf size
            }

            if (ret != LZMA_OK) {
                if (ret == LZMA_STREAM_END) {
                    fR close()
                    fW close()
                    break
                }

                match ret {
                    case LZMA_MEM_ERROR =>
                        raise("lzma: Memory allocation failed")
                    case LZMA_FORMAT_ERROR =>
                        raise("lzma: The input is not in the .xz format")
                    case LZMA_OPTIONS_ERROR =>
                        raise("lzma: Unsupported compression options")
                    case LZMA_DATA_ERROR =>
                        raise("lzma: Compressed file is corrupt")
                    case LZMA_BUF_ERROR =>
                        raise("lzma: Compressed file is truncated or otherwise corrupt")
                    case =>
                        raise("lzma: Unknown error, possibly a bug #{ret}")
                }
            }
        }

        lzma_end(stream&)

        inbuf free()
        outbuf free()
        true
    }

}

// c interface

LZMAStream: cover from lzma_stream {
    next_in: UChar*
    avail_in: SizeT
    next_out: UChar*
    avail_out: SizeT
}

LZMA_STREAM_INIT: extern LZMAStream

// check enum
LZMA_CHECK_CRC64: extern Int

// ret enum
LZMA_OK: extern Int
LZMA_STREAM_END: extern Int
LZMA_NO_CHECK: extern Int
LZMA_UNSUPPORTED_CHECK: extern Int
LZMA_GET_CHECK: extern Int
LZMA_MEM_ERROR: extern Int
LZMA_MEMLIMIT_ERROR: extern Int
LZMA_FORMAT_ERROR: extern Int
LZMA_OPTIONS_ERROR: extern Int
LZMA_DATA_ERROR: extern Int
LZMA_BUF_ERROR: extern Int
LZMA_PROG_ERROR: extern Int

// action enum
LZMA_RUN: extern Int
LZMA_SYNC_FLUSH: extern Int
LZMA_FULL_FLUSH: extern Int
LZMA_FINISH: extern Int

lzma_easy_encoder: extern func (stream: LZMAStream*, preset: UInt32, check: Int) -> Int
lzma_code: extern func (stream: LZMAStream*, action: Int) -> Int
lzma_end: extern func (stream: LZMAStream*)

// flags
LZMA_CONCATENATED: extern Int

// limits
UINT32_MAX: extern Int

lzma_stream_decoder: extern func (stream: LZMAStream*, limit: UInt64, flags: UInt32) -> Int

