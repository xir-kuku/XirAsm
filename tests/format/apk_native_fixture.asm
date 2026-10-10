// Minimal NativeActivity library for the APK structure fixtures. The checker
// assembles this alongside each staged APK source before packaging it.
import("format/format.inc");

let image: map = format_elf64_so("libmain.so", list.of(format_segment(".text", format_load | format_readable | format_executable)))
map.set_mut(image, "load_align", 16384);
let exports = format_elfso_export_new()
format_elfso_export_many_mut(exports, list.of("ANativeActivity_onCreate"), ".text", 1);
let imports = format_elfso_import_new()
format_elfso_tables_mut(image, exports, imports);
format_begin(image);
format_segment_begin(image, ".text");
ANativeActivity_onCreate:
db(0xc3);
format_segment_end(image, ".text");
format_finish(image);
