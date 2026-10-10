# A64 include package

Use `import("arm/a64-macros.inc")` for the complete natural instruction package.
Use `import("arm/a64-base-macros.inc")` for scalar and fixed-width SIMD workloads
that do not need scalable SVE/SME/ZA encodings. Choose one profile per module.

```asm
import("arm/a64-base-macros.inc")
mov x0, x1
add x2, x3, x4
ldr x7, [x8, #24]
```

`a64.inc` and `a64-base.inc` expose the corresponding direct APIs without natural
instruction macros. Existing `a64_<name>`, `_word`, `_shape`, `a64_e5_<name>` and
the older B2 import entry points remain available. New source-derived forms use
natural instruction macros. Forward branch labels retain caller bindings.

The active encoding inventory and file hashes are in
`a64/generated/latest/manifest.json`. Encodings come from one locked Arm inventory;
identical validation and numerical encoding bodies share generated functions.
The older batch manifests describe historical coverage and are not the active
inventory. Old instruction include paths are compatibility imports of this
package, not separate encoding implementations.

The full profile enables all represented instruction features. The base profile
deliberately excludes scalable instruction families. Inventory coverage describes
translated records, not an exhaustive runtime test of every operand combination.
Arm data and source license notices are retained alongside the active manifest.
