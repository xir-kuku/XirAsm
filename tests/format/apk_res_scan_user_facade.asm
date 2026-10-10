// Resource directory scanning: the tree under tests/format/apk_res declares the
// resources, their configurations and their archive entries.
//
// The tree is not itself named `res`, so the archive prefix is given
// explicitly. A project whose resource tree is already `res` uses the one
// argument form instead: `app = apk_res_dir(app, "res")`, which mirrors the
// scanned directory into the archive.
//
// tests/format/check_apk.py assembles this fixture and reads it back with
// aapt2, which is what makes the resource names, the density and locale
// configurations, and the archive paths independent of our own writers.
import("format/apk.inc");

origin(0);

let app: map = apk_new("com.example.xirasm.resdir", 3, "2.1", "main")
app = apk_set_sdk(app, 26, 34)
app = apk_res_dir_at(app, "apk_res", "res")
app = apk_native_lib(app, "x86_64", "libmain.so", "apk-native-fixture.so")
apk_emit(app);
