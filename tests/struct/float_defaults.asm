import("float_defaults.inc");
emit.struct(ImportedFloatDefaults { });
fn emit_local_defaults(value: f64) {
    struct LocalFloatDefaults {
        narrow: f32 = imported_default(),
        wide: f64 = value,
    }
    emit.bytes(pack(LocalFloatDefaults { }));
}
emit_local_defaults(3.25);
