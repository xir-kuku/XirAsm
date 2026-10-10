// Compressed archive entries next to uncompressed ones.
//
// DEFLATE is a per-entry choice: the resource table and shared libraries stay
// stored and aligned because Android requires that, while assets and other
// payloads that shrink are deflated. A reader checks the CRC-32 recorded for
// each entry against the bytes it decodes, so the table, the icons, and the
// assets all have to survive a round trip.
//
// tests/format/check_apk.py assembles this fixture and reads it back with
// Python's zipfile (an independent decompressor), aapt2, and zipalign.
import("format/apk.inc");

origin(0);

const icon: bytes = bytes.from_hex("89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000B49444154789C6360000200000500017A5EAB3F0000000049454E44AE426082")
const notes: bytes = b"XIRASM XIRASM XIRASM XIRASM XIRASM XIRASM XIRASM XIRASM XIRASM XIRASM XIRASM XIRASM"

let app: map = apk_new("com.example.xirasm.deflate", 1, "1.0", "main")
app = apk_set_sdk(app, 26, 34)
app = apk_label(app, "XIRASM Deflate")
app = apk_icon_bytes(app, "mdpi", "res/mipmap-mdpi-v4/ic_launcher.png", icon)
app = apk_asset_bytes_compressed(app, "assets/notes.txt", notes)
app = apk_asset_compressed(app, "assets/strings.txt", "apk_zh_strings.txt")
app = apk_asset(app, "assets/stored.txt", "apk_zh_strings.txt")
app = apk_native_lib(app, "x86_64", "libmain.so", "apk-native-fixture.so")
apk_emit(app);
