// Framework resource IDs: the platform's public catalog, used to set an
// application theme the way `@android:style/...` does.
//
// The catalog is a data file that the platform jar generated, and one call
// loads it. Lookups then read the loaded table, so a program that resolves
// several IDs parses the file once.
//
// tests/format/check_apk.py assembles this fixture and asks aapt2 what the
// manifest says, so the ID that reaches the archive is one the platform reads
// back as the framework style it names.
import("format/apk.inc");
import("format/android/generated/framework_ids.inc");

origin(0);

const ids: map = android_framework_ids()

// Two constants this repository already verifies against a reference manifest.
assert(android_attr_id(ids, "label") == 0x01010001);
assert(android_attr_id(ids, "icon") == 0x01010002);

// Values the platform jar reports for the same names, read from its own resource
// dump, so the catalog is checked against the platform and not only itself.
assert(android_style_id(ids, "Theme.DeviceDefault") == 0x01030128);
assert(android_string_id(ids, "ok") == 0x0104000a);

// The general form answers the same as the per-type helper.
assert(android_style_id(ids, "Theme.DeviceDefault") == android_id(ids, "style", "Theme.DeviceDefault"));
assert(android_drawable_id(ids, "ic_delete") == android_id(ids, "drawable", "ic_delete"));

const icon: bytes = bytes.from_hex("89504E470D0A1A0A0000000D49484452000000010000000108060000001F15C4890000000B49444154789C6360000200000500017A5EAB3F0000000049454E44AE426082")

let app: map = apk_new("com.example.xirasm.framework", 1, "1.0", "main")
app = apk_set_sdk(app, 26, 34)
app = apk_label(app, "XIRASM Framework")
app = apk_use_theme_id(app, android_style_id(ids, "Theme.DeviceDefault"));
app = apk_icon_bytes(app, "mdpi", "res/mipmap-mdpi-v4/ic_launcher.png", icon)
app = apk_native_lib(app, "x86_64", "libmain.so", "apk-native-fixture.so")
apk_emit(app);
