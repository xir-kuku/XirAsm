// Whole-application APK through the apk.inc facade: binary manifest, resource
// table, two density icon variants, an asset, and the bootstrap DEX, all from
// one compile-time document. The icon payload is an inline 1x1 PNG, so the
// fixture needs no external files and assembles anywhere.
//
// The checker builds apk_native_fixture.asm to apk-native-fixture.so first,
// supplying the main NativeActivity library for this ABI.
//
// This include is a DSL-layer format helper and is deliberately outside the
// Zig build: it is not listed in build.zig and carries no api-matrix markers.
// Assemble it and verify the archive with tests/format/check_apk.py.
import("../../include/format/apk.inc");

const icon_mdpi: bytes = bytes.from_hex("89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000B49444154789C6360000200000500017A5EAB3F0000000049454E44AE426082")
const icon_hdpi: bytes = bytes.from_hex("89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000B49444154789C6360000200000500017A5EAB3F0000000049454E44AE426082")

origin(0);

let app: map = apk_new("com.example.xirasm.facade", 7, "1.2", "main")
app = apk_set_sdk(app, 26, 34)
app = apk_label_string(app, "app_name", "XIRASM Facade")
app = apk_icon_bytes(app, "mdpi", "res/mipmap-mdpi-v4/ic_launcher.png", icon_mdpi)
app = apk_icon_bytes(app, "hdpi", "res/mipmap-hdpi-v4/ic_launcher.png", icon_hdpi)
app = apk_asset_bytes(app, "assets/facade.txt", b"assembled by xirasm\n")
app = apk_native_lib(app, "x86_64", "libmain.so", "apk-native-fixture.so")
apk_emit(app);
