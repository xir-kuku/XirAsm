const std = @import("std");
const manifest = @import("build.zig.zon");
// Generated from the manual by `tools/doc_examples.py`.
const tutorial_manifest = @import("tests/tutorial/manifest.zig");

// Although this function looks imperative, it does not perform the build
// directly and instead it mutates the build graph (`b`) that will be then
// executed by an external runner. The functions in `std.Build` implement a DSL
// for defining build steps and express dependencies between them, allowing the
// build runner to parallelize the build automatically (and the cache system to
// know when a step doesn't need to be re-run).
pub fn build(b: *std.Build) void {
    // Standard target options allow the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});
    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});
    // It's also possible to define more custom flags to toggle optional features
    // of this build script using `b.option()`. All defined flags (including
    // target and optimize options) will be listed when running `zig build --help`
    // in this directory.
    const backend_dep = b.dependency("xirasm_lib", .{
        .target = target,
        .optimize = optimize,
    });
    const backend_mod = backend_dep.module("xirasm_backend");

    const build_opts = b.addOptions();
    build_opts.addOption([]const u8, "version", manifest.version);

    // This creates a module, which represents a collection of source files alongside
    // some compilation options, such as optimization mode and linked system libraries.
    // Zig modules are the preferred way of making Zig code available to consumers.
    // addModule defines a module that we intend to make available for importing
    // to our consumers. We must give it a name because a Zig package can expose
    // multiple modules and consumers will need to be able to specify which
    // module they want to access.
    const mod = b.addModule("xirasm", .{
        // The root source file is the "entry point" of this module. Users of
        // this module will only be able to access public declarations contained
        // in this file, which means that if you have declarations that you
        // intend to expose to consumers that were defined in other files part
        // of this module, you will have to make sure to re-export them from
        // the root file.
        .root_source_file = b.path("src/root.zig"),
        // Later on we'll use this module as the root module of a test executable
        // which requires us to specify a target.
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "xirasm_backend", .module = backend_mod },
        },
    });

    // Here we define an executable. An executable needs to have a root module
    // which needs to expose a `main` function. While we could add a main function
    // to the module defined above, it's sometimes preferable to split business
    // logic and the CLI into two separate modules.
    //
    // If your goal is to create a Zig library for others to use, consider if
    // it might benefit from also exposing a CLI tool. A parser library for a
    // data serialization format could also bundle a CLI syntax checker, for example.
    //
    // If instead your goal is to create an executable, consider if users might
    // be interested in also being able to embed the core functionality of your
    // program in their own executable in order to avoid the overhead involved in
    // subprocessing your CLI tool.
    //
    // If neither case applies to you, feel free to delete the declaration you
    // don't need and to put everything under a single module.
    const exe_mod = b.createModule(.{
        // b.createModule defines a new module just like b.addModule but,
        // unlike b.addModule, it does not expose the module to consumers of
        // this package, which is why in this case we don't have to give it a name.
        .root_source_file = b.path("src/main.zig"),
        // Target and optimization levels must be explicitly wired in when
        // defining an executable or library (in the root module), and you
        // can also hardcode a specific target for an executable or library
        // definition if desireable (e.g. firmware for embedded devices).
        .target = target,
        .optimize = optimize,
        // List of modules available for import in source files part of the
        // root module.
        .imports = &.{
            // Here "xirasm" is the name you will use in your source code to
            // import this module (e.g. `@import("xirasm")`). The name is
            // repeated because you are allowed to rename your imports, which
            // can be extremely useful in case of collisions (which can happen
            // importing modules from different packages).
            .{ .name = "xirasm", .module = mod },
            .{ .name = "xirasm_backend", .module = backend_mod },
        },
    });
    exe_mod.addOptions("build_options", build_opts);

    const exe = b.addExecutable(.{
        .name = "xirasm",
        .root_module = exe_mod,
    });

    // This declares intent for the executable to be installed into the
    // install prefix when running `zig build` (i.e. when executing the default
    // step). By default the install prefix is `zig-out/` but can be overridden
    // by passing `--prefix` or `-p`.
    b.installArtifact(exe);
    b.installDirectory(.{
        .source_dir = b.path("include"),
        .install_dir = .{ .custom = "bin/include" },
        .install_subdir = "",
    });

    // This creates a top level step. Top level steps have a name and can be
    // invoked by name when running `zig build` (e.g. `zig build run`).
    // This will evaluate the `run` step rather than the default step.
    // For a top level step to actually do something, it must depend on other
    // steps (e.g. a Run step, as we will see in a moment).
    const run_step = b.step("run", "Run the app");

    // This creates a RunArtifact step in the build graph. A RunArtifact step
    // invokes an executable compiled by Zig. Steps will only be executed by the
    // runner if invoked directly by the user (in the case of top level steps)
    // or if another step depends on it, so it's up to you to define when and
    // how this Run step will be executed. In our case we want to run it when
    // the user runs `zig build run`, so we create a dependency link.
    const run_cmd = b.addRunArtifact(exe);
    run_step.dependOn(&run_cmd.step);

    // By making the run step depend on the default step, it will be run from the
    // installation directory rather than directly from within the cache directory.
    run_cmd.step.dependOn(b.getInstallStep());

    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    run_cmd.addPassthruArgs();

    // Creates an executable that will run `test` blocks from the provided module.
    // Here `mod` needs to define a target, which is why earlier we made sure to
    // set the releative field.
    const mod_tests = b.addTest(.{
        .root_module = mod,
    });

    // A run step that will run the test executable.
    const run_mod_tests = b.addRunArtifact(mod_tests);
    const unit_step = b.step("test-unit", "Run frontend unit and allocation-failure tests");
    unit_step.dependOn(&run_mod_tests.step);

    // Creates an executable that will run `test` blocks from the executable's
    // root module. Note that test executables only test one module at a time,
    // hence why we have to create two separate ones.
    const exe_tests = b.addTest(.{
        .root_module = exe.root_module,
    });

    // A run step that will run the second test executable.
    const run_exe_tests = b.addRunArtifact(exe_tests);

    const fixture_checker = b.addExecutable(.{
        .name = "xirasm-check-fixture-bytes",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_bytes.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const text_contains_checker = b.addExecutable(.{
        .name = "xirasm-check-text-contains",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_text_contains.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const file_size_checker = b.addExecutable(.{
        .name = "xirasm-check-file-size",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_file_size.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const coff_checker = b.addExecutable(.{
        .name = "xirasm-check-coff",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_coff.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const coff_weak_checker = b.addExecutable(.{
        .name = "xirasm-check-coff-weak",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_coff_weak.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const elf_checker = b.addExecutable(.{
        .name = "xirasm-check-elf",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_elf.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const elf_program_header_checker = b.addExecutable(.{
        .name = "xirasm-check-elf-program-headers",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_elf_program_headers.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const elf_obj_checker = b.addExecutable(.{
        .name = "xirasm-check-elf-obj",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_elf_obj.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const elf_so_checker = b.addExecutable(.{
        .name = "xirasm-check-elf-so",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_elf_so.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const elf_so_import_checker = b.addExecutable(.{
        .name = "xirasm-check-elf-so-import",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_elf_so_import.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const elf_exe_import_checker = b.addExecutable(.{
        .name = "xirasm-check-elf-exe-import",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_elf_exe_import.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const pe_export_checker = b.addExecutable(.{
        .name = "xirasm-check-pe-export",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_pe_export.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const pe_reloc_checker = b.addExecutable(.{
        .name = "xirasm-check-pe-reloc",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_pe_reloc.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const pe_checksum_checker = b.addExecutable(.{
        .name = "xirasm-check-pe-checksum",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_pe_checksum.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const pe_resource_checker = b.addExecutable(.{
        .name = "xirasm-check-pe-resource",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_pe_resource.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const api_matrix_checker = b.addExecutable(.{
        .name = "xirasm-check-api-matrix",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_api_matrix.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const release_boundary_checker = b.addExecutable(.{
        .name = "xirasm-check-release-boundary",
        .root_module = b.createModule(.{
            .root_source_file = b.path("tests/integration/check_release_boundary.zig"),
            .target = b.graph.host,
            .optimize = optimize,
        }),
    });

    const api_matrix_step = b.step("test-api-matrix", "Validate Meta v1 user API fixture coverage");
    const run_api_matrix = b.addRunArtifact(api_matrix_checker);
    run_api_matrix.addFileArg(b.path("tests/api/user-api-matrix.tsv"));
    run_api_matrix.addFileArg(b.path("src/frontend/lower.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/lower/root.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/lower/collection_mutation.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/lower/api.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/lower/deferred.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/lower/late_layout.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/lower/meta_condition.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/expr.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/parser.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/ast.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/lexer.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/module.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/meta_data.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/meta_io.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/meta_std.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/token_match.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/value.zig"));
    run_api_matrix.addFileArg(b.path("src/frontend/types.zig"));
    run_api_matrix.addFileArg(b.path("include/format/format.inc"));
    run_api_matrix.addFileArg(b.path("include/format/coff.inc"));
    run_api_matrix.addFileArg(b.path("include/format/coff32.inc"));
    run_api_matrix.addFileArg(b.path("include/format/coff64.inc"));
    run_api_matrix.addFileArg(b.path("include/format/pe.inc"));
    run_api_matrix.addFileArg(b.path("include/format/pe32.inc"));
    run_api_matrix.addFileArg(b.path("include/format/pe64.inc"));
    run_api_matrix.addFileArg(b.path("include/format/pe_import.inc"));
    run_api_matrix.addFileArg(b.path("include/format/pe_export.inc"));
    run_api_matrix.addFileArg(b.path("include/format/pe_reloc.inc"));
    run_api_matrix.addFileArg(b.path("include/format/pe_resource.inc"));
    run_api_matrix.addFileArg(b.path("include/format/elf32.inc"));
    run_api_matrix.addFileArg(b.path("include/format/elf64.inc"));
    run_api_matrix.addFileArg(b.path("include/format/elfexe.inc"));
    run_api_matrix.addFileArg(b.path("include/format/elfexe_import.inc"));
    run_api_matrix.addFileArg(b.path("include/format/elfobj.inc"));
    run_api_matrix.addFileArg(b.path("include/format/elfso.inc"));
    run_api_matrix.addFileArg(b.path("include/format/elf_export.inc"));
    run_api_matrix.addFileArg(b.path("include/format/elfso_import.inc"));
    run_api_matrix.addFileArg(b.path("include/format/elf_const.inc"));
    run_api_matrix.addFileArg(b.path("include/format/macho_const.inc"));
    run_api_matrix.addFileArg(b.path("include/format/macho_obj.inc"));
    run_api_matrix.addFileArg(b.path("include/format/macho_exe.inc"));
    run_api_matrix.addFileArg(b.path("include/format/macho_dylib.inc"));
    run_api_matrix.addFileArg(b.path("include/format/macho_export.inc"));
    run_api_matrix.addFileArg(b.path("include/format/macho_import.inc"));
    run_api_matrix.addFileArg(b.path("include/os/win32/guid.inc"));
    run_api_matrix.addFileArg(b.path("include/os/android.inc"));
    run_api_matrix.addFileArg(b.path("include/os/android/imports/liblog.inc"));
    run_api_matrix.addArg("--fixtures");
    run_api_matrix.addFileArg(b.path("tests/x86/basic.asm"));
    run_api_matrix.addFileArg(b.path("tests/x86/branch.asm"));
    run_api_matrix.addFileArg(b.path("tests/isa/riscv/rv32-integer-control.asm"));
    run_api_matrix.addFileArg(b.path("tests/isa/riscv/rv64-integer-control.asm"));
    run_api_matrix.addFileArg(b.path("tests/isa/riscv/rv64-system-float-atomic.asm"));
    run_api_matrix.addFileArg(b.path("tests/isa/riscv/rv64-bit-vector-compressed.asm"));
    run_api_matrix.addFileArg(b.path("tests/isa/riscv/rv64-compressed-control.asm"));
    run_api_matrix.addFileArg(b.path("tests/isa/spv/minimal-compute.asm"));
    run_api_matrix.addFileArg(b.path("tests/flat/data.asm"));
    run_api_matrix.addFileArg(b.path("tests/flat/data_aliases.asm"));
    run_api_matrix.addFileArg(b.path("tests/flat/emit_align_queries.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/coff32_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/coff32_facade_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/coff32_facade_tail_reserve.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/coff32_reloc.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/coff64_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/coff64_facade_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/coff64_facade_tail_reserve.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/coff64_facade_late_tables.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/coff64_reloc.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/coff64_weak_alias.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_coff32_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_coff64_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe64_facade_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe64_facade_large_text.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe64_facade_large_multisection.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe64_facade_tail_reserve.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe_multisection.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe_dll64_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe_dll64_import_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe64_export_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe64_import_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe64_reloc_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe64_reloc_grouped.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe64_resource_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe64_resource_from_res.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe64_checksum_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe32_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe32_facade_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe32_facade_large_text.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe32_facade_large_multisection.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe32_facade_tail_reserve.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe32_multisection.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe_dll32_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe_dll32_import_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe32_export_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe32_import_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe32_reloc_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe32_reloc_grouped.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe32_resource_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/pe32_checksum_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_pe32_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_pe64_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_pe32_dll_export_reloc_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_pe64_dll_export_reloc_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf64_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf64_facade_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf64_pie_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf64_segment_attributes.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf64_facade_tail_reserve.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf64_multisegment.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf64_exe_import.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf64_exe_import_plt.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf64_reloc.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf64_facade_late_tables.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_elf64_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_elf64_pie_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_elf64_exe_import_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_elf64_obj_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_elf64_so_export_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_elf64_so_import_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_elf64_so_aarch64_import_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf32_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf32_facade_minimal.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf32_segment_attributes.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf32_facade_tail_reserve.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf32_multisegment.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf32_reloc.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_elf32_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_elf32_obj_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf64_so_export.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/elf64_so_import.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/macho64_arm64_exe_import.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/macho64_x86_64_exe_import.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/macho64_arm64_dylib.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/macho64_arm64_dylib_exports.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/macho64_arm64_exe.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/macho64_arm64_exe_dylinker.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/macho64_arm64_obj.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/macho64_format_entry.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/macho64_x86_64_callee_obj.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/macho64_x86_64_data_obj.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/macho64_x86_64_dylib_exports.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/macho64_x86_64_exe.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/macho64_x86_64_exe_dylinker.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/macho64_x86_64_ffi_ref_obj.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/macho64_x86_64_obj.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/macho64_x86_64_unsigned_obj.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_macho64_arm64_duplicate_sections.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_macho64_arm64_dylib_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_macho64_arm64_obj_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/format/format_macho64_x86_64_exe_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/diagnostics.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/err_negative.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/assignment.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/functions_scopes.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/same_line_else.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/control_flow.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/multiline_function_args.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/multiline_function_params.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/return_functions.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/return_functions_finalizer.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/final_byte_fold.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/loops.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/virtual_load_store.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/virtual_load_store_gaps.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/finalization_backfill.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/finalization_forbid_emit.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/finalization_forbid_output_section.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/late_layout_virtual_append.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/custom_format_backfill.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/custom_format_tail_reserve.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/output_area_section_tail_reserve.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/output_area_org_middle_reserve.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/output_area_cursor_facts.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/region_place_generated_code.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/string_bytes_helpers.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/crypto_helpers.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/deflate_helpers.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/list_helpers.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/collection_mutation.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/split_join_helpers.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/map_helpers.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/token_match_helpers.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/dynamic_symbols.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/isa_text.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/macro_core.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/include_import/defs.inc"));
    run_api_matrix.addFileArg(b.path("tests/meta/include_import/inline.inc"));
    run_api_matrix.addFileArg(b.path("tests/meta/include_import/main.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/data_file/main.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/data_file/list_dir.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/data_file/range.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/data_file/range_oob.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/data_file/auto.inc"));
    run_api_matrix.addFileArg(b.path("tests/meta/data_file/config.json"));
    run_api_matrix.addFileArg(b.path("tests/meta/data_file/json.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/data_file/project.toml"));
    run_api_matrix.addFileArg(b.path("tests/meta/floats.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/target_conditions.asm"));
    run_api_matrix.addFileArg(b.path("tests/meta/x86_modes.asm"));
    run_api_matrix.addFileArg(b.path("tests/struct/natural_emit_struct.asm"));
    run_api_matrix.addFileArg(b.path("tests/struct/pack_sizeof.asm"));
    run_api_matrix.addFileArg(b.path("tests/struct/aggregate_builtin_arg.asm"));
    run_api_matrix.addFileArg(b.path("tests/struct/nested_union.inc"));
    run_api_matrix.addFileArg(b.path("tests/struct/nested_union.asm"));
    run_api_matrix.addFileArg(b.path("tests/api/reference/03-aggregates.asm"));
    run_api_matrix.addFileArg(b.path("tests/win32/generated-guid.asm"));
    run_api_matrix.addFileArg(b.path("tests/os/android/catalog_import_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/os/android/catalog_import_x86_64_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/os/android/catalog_query_user_facade.asm"));
    run_api_matrix.addFileArg(b.path("tests/os/android/defs_user_facade.asm"));
    api_matrix_step.dependOn(&run_api_matrix.step);

    const release_boundary_step = b.step("test-release-boundary", "Validate release candidate path, docs, and brand boundary");
    const run_release_boundary = b.addRunArtifact(release_boundary_checker);
    run_release_boundary.addFileArg(b.path("build.zig"));
    run_release_boundary.addFileArg(b.path("build.zig.zon"));
    run_release_boundary.addFileArg(b.path("LICENSE"));
    run_release_boundary.addFileArg(b.path("README.md"));
    run_release_boundary.addFileArg(b.path("README.zh-CN.md"));
    run_release_boundary.addFileArg(b.path("document/advanced-formats.md"));
    run_release_boundary.addFileArg(b.path("document/api-reference.md"));
    run_release_boundary.addFileArg(b.path("document/format-tutorial.md"));
    run_release_boundary.addFileArg(b.path("document/format-tutorial/01-choose-a-template.md"));
    run_release_boundary.addFileArg(b.path("document/format-tutorial/02-windows-pe.md"));
    run_release_boundary.addFileArg(b.path("document/format-tutorial/03-linux-elf.md"));
    run_release_boundary.addFileArg(b.path("document/format-tutorial/04-object-files.md"));
    run_release_boundary.addFileArg(b.path("document/format-tutorial/05-common-rules.md"));
    run_release_boundary.addFileArg(b.path("document/language.md"));
    run_release_boundary.addFileArg(b.path("tests/integration/check_release_boundary.zig"));
    run_release_boundary.addFileArg(b.path("tests/api/user-api-matrix.tsv"));
    run_release_boundary.addFileArg(b.path("include/format/coff.inc"));
    run_release_boundary.addFileArg(b.path("include/format/coff32.inc"));
    run_release_boundary.addFileArg(b.path("include/format/coff64.inc"));
    run_release_boundary.addFileArg(b.path("include/format/elf_const.inc"));
    run_release_boundary.addFileArg(b.path("include/format/elf32.inc"));
    run_release_boundary.addFileArg(b.path("include/format/elf64.inc"));
    run_release_boundary.addFileArg(b.path("include/format/elf_export.inc"));
    run_release_boundary.addFileArg(b.path("include/format/elfexe.inc"));
    run_release_boundary.addFileArg(b.path("include/format/elfexe_import.inc"));
    run_release_boundary.addFileArg(b.path("include/format/elfobj.inc"));
    run_release_boundary.addFileArg(b.path("include/format/elfso.inc"));
    run_release_boundary.addFileArg(b.path("include/format/elfso_import.inc"));
    run_release_boundary.addFileArg(b.path("include/format/pe.inc"));
    run_release_boundary.addFileArg(b.path("include/format/pe32.inc"));
    run_release_boundary.addFileArg(b.path("include/format/pe64.inc"));
    run_release_boundary.addFileArg(b.path("include/format/pe_const.inc"));
    run_release_boundary.addFileArg(b.path("include/format/pe_export.inc"));
    run_release_boundary.addFileArg(b.path("include/format/pe_import.inc"));
    run_release_boundary.addFileArg(b.path("include/format/pe_resource.inc"));
    run_release_boundary.addFileArg(b.path("deps/xirasm-lib/THIRD_PARTY_NOTICES.md"));
    release_boundary_step.dependOn(&run_release_boundary.step);

    const fixture_step = b.step("test-fixtures", "Assemble source fixtures with the compiled CLI");
    const macro_step = b.step("test-macros", "Validate statement macros");
    macro_step.dependOn(&run_mod_tests.step);
    fixture_step.dependOn(macro_step);
    // A64 differential checks use the installed CLI via tests/isa/arm.
    const api_reference_step = b.step(
        "test-api-reference",
        "Validate API Reference examples and diagnostics",
    );
    addAsmFixture(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/01-source-bindings.asm",
        "api-reference-01-source-bindings.bin",
        "x64",
        "b80100000001",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/01-assign-const.asm",
        "x64",
        &.{},
        "InvalidValueDeclaration",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/01-block-scope.asm",
        "x64",
        &.{},
        "UndefinedSymbol",
    );
    addAsmFixture(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/02-functions-control.asm",
        "api-reference-02-functions-control.bin",
        "x64",
        "010205aa101120213031",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/02-return-in-procedure.asm",
        "x64",
        &.{},
        "InvalidMetaFunction",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/02-missing-return.asm",
        "x64",
        &.{},
        "ended without a return statement",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/02-return-type-mismatch.asm",
        "x64",
        &.{},
        "declares a u64 return value",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/02-value-side-effect.asm",
        "x64",
        &.{},
        "SideEffectInValueFunction",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/02-descending-range.asm",
        "x64",
        &.{},
        "InvalidMetaFor",
    );
    addAsmFixture(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/03-aggregates.asm",
        "api-reference-03-aggregates.bin",
        "x64",
        "41000000443322110804443322114243440122114433556677040301fffefffdfffffffcffffffffffffff",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/03-signed-underflow.asm",
        "x64",
        &.{},
        "InvalidValueDeclaration",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/03-unknown-field.asm",
        "x64",
        &.{},
        "UnknownField",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/03-duplicate-field.asm",
        "x64",
        &.{},
        "DuplicateFieldName",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/03-missing-field.asm",
        "x64",
        &.{},
        "MissingStructFieldValue",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/03-union-multiple-fields.asm",
        "x64",
        &.{},
        "InvalidValueDeclaration",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/03-union-field-default.asm",
        "x64",
        &.{},
        "union fields cannot declare defaults",
    );
    addAsmFixture(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/04-finalization.asm",
        "api-reference-04-finalization.bin",
        "x64",
        "08000a0141424344",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/04-defer-layout-change.asm",
        "x64",
        &.{},
        "FinalizerCannotChangeLayout",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/04-late-layout-local.asm",
        "x64",
        &.{},
        "InvalidLateLayout",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/04-nested-late-layout.asm",
        "x64",
        &.{},
        "FinalizerCannotChangeLayout",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/04-trimmed-tail-store.asm",
        "x64",
        &.{},
        "InvalidApiArgument",
    );
    addDiagnosticAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/05-modules-diagnostics/main.asm",
        "api-reference-05-modules-diagnostics.bin",
        "x64",
        "1111332244",
        &.{
            "tests/api/reference/05-modules-diagnostics/repeat.inc",
            "tests/api/reference/05-modules-diagnostics/module/once.inc",
            "tests/api/reference/05-modules-diagnostics/module/nested.inc",
        },
        &.{
            "note: module bytes 4",
            "warning: diagnostic example true",
        },
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/05-err.asm",
        "x64",
        &.{},
        "stop 7",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/05-assert-false.asm",
        "x64",
        &.{},
        "assertion failed",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/05-scoped-import.asm",
        "x64",
        &.{},
        "InvalidMetaBlock",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/05-cycle/main.asm",
        "x64",
        &.{
            "tests/api/reference/negative/05-cycle/a.inc",
            "tests/api/reference/negative/05-cycle/b.inc",
        },
        "IncludeCycle",
    );
    addAsmFixture(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/06-targets-symbols.asm",
        "api-reference-06-targets-symbols.bin",
        "x64",
        "281000000000000086aa09000a00b83412b87856341248b808070605040302019300100013012000",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/06-cmp-r64-imm64.asm",
        "x64",
        &.{},
        "x86-64 cmp r64 accepts only imm8 or sign-extended imm32 immediates; load wider constants into a register first",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/06-empty-isa.asm",
        "x64",
        &.{},
        "InvalidApiArgument",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/06-isa-line-semicolon.asm",
        "x64",
        &.{},
        "does not end with a semicolon",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/06-isa-call-semicolon.asm",
        "x64",
        &.{},
        "does not end with a semicolon",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/06-invalid-label-name.asm",
        "x64",
        &.{},
        "InvalidApiArgument",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/06-missing-label.asm",
        "x64",
        &.{},
        "UndefinedSymbol",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/06-target-isa-value.asm",
        "x64",
        &.{},
        "UnknownField",
    );
    addAsmFixture(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/07-emission-reservation-alignment.asm",
        "api-reference-07-emission-reservation-alignment.bin",
        "x64",
        "11332277665544ffeeddccbbaa998810415a42433412cdab40302010080706050403020158595a000000000000000000000000000000000044aaaa00bbbbbbcc55",
    );
    addAsmFixture(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/07-pad-to-reserved-gap.asm",
        "api-reference-07-pad-to-reserved-gap.bin",
        "x64",
        "11000000aaaaaaaa22",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/07-emit-range.asm",
        "x64",
        &.{},
        "InvalidApiInteger",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/07-empty-data.asm",
        "x64",
        &.{},
        "InvalidApiArity",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/07-data-type.asm",
        "x64",
        &.{},
        "InvalidApiArgument",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/07-emit-bytes-type.asm",
        "x64",
        &.{},
        "InvalidApiArgument",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/07-reserve-overflow.asm",
        "x64",
        &.{},
        "InvalidApiInteger",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/07-pad-to-backward.asm",
        "x64",
        &.{},
        "InvalidApiInteger",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/07-pad-to-before-logical.asm",
        "x64",
        &.{},
        "InvalidApiInteger",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/07-invalid-alignment.asm",
        "x64",
        &.{},
        "InvalidAlignment",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/07-fill-range.asm",
        "x64",
        &.{},
        "InvalidApiInteger",
    );
    addAsmFixture(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/08-regions-cursors.asm",
        "api-reference-08-regions-cursors.bin",
        "x64",
        "0000000000000000000000000000000000000000000000000000000000000000112200003300000000000000",
    );
    addAsmFixture(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/08-virtual-output.asm",
        "api-reference-08-virtual-output.bin",
        "x64",
        "aabb",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/08-invalid-file-alignment.asm",
        "x64",
        &.{},
        "InvalidAlignment",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/08-output-after-file-align.asm",
        "x64",
        &.{},
        "OutputRegionClosed",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/08-output-section-in-virtual.asm",
        "x64",
        &.{},
        "InvalidApiCall",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/08-unclosed-virtual.asm",
        "x64",
        &.{},
        "UnclosedVirtualOutput",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/08-unmatched-virtual-end.asm",
        "x64",
        &.{},
        "UnmatchedVirtualEnd",
    );
    addAsmFixture(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/09-loads-stores.asm",
        "api-reference-09-loads-stores.bin",
        "x64",
        "aa332277665544080706050403020158595a",
    );
    addAsmFixture(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/09-region-facts-overlap.asm",
        "api-reference-09-region-facts-overlap.bin",
        "x64",
        "112233447788",
    );
    addAsmFixture(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/09-local-shadow-address.asm",
        "api-reference-09-local-shadow-address.bin",
        "x64",
        "11223344",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/09-store-overflow.asm",
        "x64",
        &.{},
        "InvalidApiInteger",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/09-load-past-file.asm",
        "x64",
        &.{},
        "InvalidApiArgument",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/09-trimmed-tail-load.asm",
        "x64",
        &.{},
        "InvalidApiArgument",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/09-facts-before-final.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/09-facts-outside.asm",
        "x64",
        &.{},
        "InvalidApiArgument",
    );
    addAsmFixture(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/10-text-conversion-symbols.asm",
        "api-reference-10-text-conversion-symbols.bin",
        "x64",
        "78697261736d007265647c677265656e7c0076325f74727565a1b2",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/10-lengthof-bool.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/10-len-scalar.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/10-to-string-aggregate.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/10-contains-mixed-types.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/10-replace-empty-needle.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/10-split-empty-separator.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/10-join-non-string.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addAsmFixture(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/11-byte-sequences.asm",
        "api-reference-11-byte-sequences.bin",
        "x64",
        "7f58595a3412aaaaaadeadbeef",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/11-new-arity.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/11-push-byte-range.asm",
        "x64",
        &.{},
        "InvalidApiInteger",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/11-concat-type.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/11-repeat-byte-range.asm",
        "x64",
        &.{},
        "InvalidApiInteger",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/11-le-width.asm",
        "x64",
        &.{},
        "InvalidApiInteger",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/11-insert-index.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/11-replace-range.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/11-from-hex-odd.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/11-from-hex-digit.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addAsmFixture(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/12-lists-maps.asm",
        "api-reference-12-lists-maps.bin",
        "x64",
        "00101112aa030404044003030204",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/12-list-new-arity.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/12-list-push-type.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/12-list-get-index.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/12-list-set-index.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/12-list-slice-range.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/12-list-eq-type.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/12-map-new-arity.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/12-map-key-type.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/12-map-get-missing.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/12-map-eq-type.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/13-files-data/main.asm",
        "api-reference-13-files-data.bin",
        "x64",
        "42434458520a4a534f4e400102034f4b544f4d4c200405035a656272612e747874",
        &.{
            "tests/api/reference/13-files-data/banner.txt",
            "tests/api/reference/13-files-data/config.json",
            "tests/api/reference/13-files-data/config.toml",
            "tests/api/reference/13-files-data/nested/reader.inc",
            "tests/api/reference/13-files-data/nested/payload.bin",
            "tests/api/reference/13-files-data/listing/Zebra.txt",
            "tests/api/reference/13-files-data/listing/apple.txt",
            "tests/api/reference/13-files-data/listing/sub/inner.txt",
        },
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/13-read-text-missing.asm",
        "x64",
        &.{},
        "FileNotAvailable",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/13-read-bytes-range.asm",
        "x64",
        &.{"tests/api/reference/13-files-data/nested/payload.bin"},
        "InvalidApiInteger",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/13-json-type.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/13-json-syntax.asm",
        "x64",
        &.{},
        "InvalidApiArgument",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/13-json-duplicate-key.asm",
        "x64",
        &.{"tests/api/reference/13-files-data/duplicate.json"},
        "InvalidApiArgument",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/13-json-negative-integer.asm",
        "x64",
        &.{},
        "InvalidApiInteger",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/13-json-float.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/13-toml-syntax.asm",
        "x64",
        &.{},
        "InvalidApiArgument",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/13-toml-negative-integer.asm",
        "x64",
        &.{},
        "InvalidApiInteger",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/13-toml-float.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/13-late-layout-file.asm",
        "x64",
        &.{"tests/api/reference/13-files-data/banner.txt"},
        "FileNotAvailable",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/13-defer-file.asm",
        "x64",
        &.{"tests/api/reference/13-files-data/banner.txt"},
        "FileNotAvailable",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/13-late-layout-dir.asm",
        "x64",
        &.{"tests/api/reference/13-files-data/listing/sub/inner.txt"},
        "InvalidLateLayout",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/13-defer-dir.asm",
        "x64",
        &.{"tests/api/reference/13-files-data/listing/sub/inner.txt"},
        "FileNotAvailable",
    );
    addAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        fixture_checker,
        "tests/api/reference/14-tokens-matching.asm",
        "api-reference-14-tokens-matching.bin",
        "x64",
        "0c6c6f6164207261782c205b7262782b287263782a34295d7261782a4f4b6e616d6500",
        &.{},
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/14-tokens-of-type.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/14-tokens-join-type.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/14-tokens-join-element.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/14-match-pattern-type.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/14-match-input-type.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/14-match-invalid-piece.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/14-match-duplicate-capture.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/14-match-unknown-kind.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/14-match-empty-literal.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addFailingAsmFixtureWithInputs(
        b,
        api_reference_step,
        exe,
        "tests/api/reference/negative/14-tokens-unterminated-quote.asm",
        "x64",
        &.{},
        "InvalidExpression",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/format/batch_idempotence.asm",
        "format-batch-idempotence.bin",
        "x64",
        "02",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/negative/pe64_import_odd_pairs.asm",
        "x64",
        &.{},
        "PE64 import pairs require slot/name entries",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/negative/pe64_import_conflict.asm",
        "x64",
        &.{},
        "PE import slot already maps to a different name",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/negative/pe64_export_empty.asm",
        "x64",
        &.{},
        "PE export target label is empty",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/negative/elfso_import_odd_pairs.asm",
        "x64",
        &.{},
        "ELF SO import pairs require slot/name entries",
    );
    const init_build_step = b.step("test-init-build", "Validate init-generated project builds with the CLI");
    addInitBuildFixture(
        b,
        init_build_step,
        exe,
        file_size_checker,
        "xirasm-init-build-demo",
        "rv64",
        "4",
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/win32/generated-import.asm",
        "win32-generated-import.exe",
        "x64",
        "1536",
        &.{
            "include/format/format.inc",
            "include/os/win32/imports/kernel32.inc",
        },
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/macho64_arm64_exe_import.asm",
        "format-macho64-arm64-exe-import",
        "x64",
        "32904",
        &.{
            "include/format/macho_import.inc",
            "include/format/macho_exe.inc",
            "include/format/macho_dylib.inc",
            "include/format/macho_obj.inc",
            "include/format/macho_const.inc",
        },
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/format_elf64_so_aarch64_import_user_facade.asm",
        "format-elf64-so-aarch64-import-user-facade",
        "x64",
        "1456",
        &.{
            "include/format/format.inc",
            "include/format/elfso.inc",
            "include/format/elfso_import.inc",
            "include/format/elf_export.inc",
            "include/format/elf_const.inc",
            "include/arm/a64-macros.inc",
            "include/arm/a64.inc",
        },
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/isa/arm/label_case.asm",
        "isa-arm-label-case",
        "x64",
        "48",
        &.{
            "include/arm/a64-macros.inc",
            "include/arm/a64.inc",
            "include/arm/a64/operands.inc",
            "include/arm/a64/memory.inc",
        },
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/os/android/catalog_import_user_facade.asm",
        "os-android-catalog-import",
        "x64",
        "1640",
        &.{
            "include/format/format.inc",
            "include/arm/a64-macros.inc",
            "include/os/android/imports/liblog.inc",
            "include/os/android/imports/libGLESv2.inc",
        },
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/os/android/catalog_query_user_facade.asm",
        "os-android-catalog-query",
        "x64",
        "1",
        &.{
            "include/os/android/catalog.inc",
            "include/os/android/catalog/symbols.toml",
            "include/os/android/imports/libnativewindow.inc",
        },
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/os/android/defs_user_facade.asm",
        "os-android-defs",
        "x64",
        "992",
        &.{
            "include/format/format.inc",
            "include/arm/a64-macros.inc",
            "include/os/android/defs/native_activity.inc",
            "include/os/android/defs/native_window.inc",
            "include/os/android/defs/input.inc",
            "include/os/android/defs/keycodes.inc",
        },
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/os/android/catalog_import_x86_64_user_facade.asm",
        "os-android-catalog-import-x86-64",
        "x64",
        "1752",
        &.{
            "include/format/format.inc",
            "include/os/android/imports/liblog.inc",
            "include/os/android/imports/libandroid.inc",
        },
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/macho64_x86_64_exe_import.asm",
        "format-macho64-x86-64-exe-import",
        "x64",
        "8328",
        &.{
            "include/format/macho_import.inc",
            "include/format/macho_exe.inc",
            "include/format/macho_dylib.inc",
            "include/format/macho_obj.inc",
            "include/format/macho_const.inc",
        },
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/win32/runtime-multi-dll.asm",
        "win32-runtime-multi-dll.exe",
        "x64",
        "1536",
        &.{
            "include/format/format.inc",
            "include/os/win32/imports/kernel32.inc",
            "include/os/win32/imports/user32.inc",
        },
    );
    addAsmFixtureInstalled(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/win32/generated-defs.asm",
        "win32-generated-defs.bin",
        "x64",
        "010000000200000057",
        &.{"include/os/win32/defs/foundation.inc"},
    );
    addAsmFixtureInstalled(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/win32/generated-nested-aggregate.asm",
        "win32-generated-nested-aggregate.bin",
        "x64",
        "0000000000000000",
        &.{"include/os/win32/defs/networkmanagement_dhcp.inc"},
    );
    addAsmFixtureInstalled(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/win32/generated-guid.asm",
        "win32-generated-guid.bin",
        "x64",
        "42f3fd566dfdd011958a006097c9a09044f3fd566dfdd011958a006097c9a090",
        &.{
            "include/os/win32/guid.inc",
            "include/os/win32/comdefs/ui_shell.inc",
        },
    );
    addAsmFixtureInstalled(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/win32/generated-com.asm",
        "win32-generated-com64.bin",
        "x64",
        "31c9488b01ff5008c3",
        &.{
            "include/format/com64.inc",
            "include/os/win32/comdefs/system_com.inc",
        },
    );
    addAsmFixtureInstalled(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/win32/generated-com32.asm",
        "win32-generated-com32.bin",
        "x86",
        "6a026a0131c0508b00ff10c3",
        &.{
            "include/format/com32.inc",
            "include/os/win32/comdefs/system_com.inc",
        },
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/win32/runtime-com64.asm",
        "win32-runtime-com64.exe",
        "x64",
        "3072",
        &.{
            "include/format/format.inc",
            "include/format/com64.inc",
            "include/os/win32/imports/kernel32.inc",
            "include/os/win32/imports/ole32.inc",
            "include/os/win32/comdefs/ui_shell.inc",
        },
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe_include_search.asm",
        "format-pe-include-search.exe",
        "x64",
        "1024",
        &.{"include/format/pe.inc"},
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/format_pe32_user_facade.asm",
        "format-pe32-user-facade.exe",
        "x86",
        "3072",
        &.{
            "include/format/format.inc",
            "include/format/pe32.inc",
            "include/format/pe64.inc",
        },
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/format_pe64_user_facade.asm",
        "format-pe64-user-facade.exe",
        "x64",
        "3072",
        &.{
            "include/format/format.inc",
            "include/format/pe32.inc",
            "include/format/pe64.inc",
            "include/format/pe_import.inc",
        },
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/format_pe32_dll_export_reloc_user_facade.asm",
        "format-pe32-dll-export-reloc-user-facade.dll",
        "x86",
        "3584",
        &.{
            "include/format/format.inc",
            "include/format/pe32.inc",
            "include/format/pe64.inc",
            "include/format/pe_import.inc",
            "include/format/pe_export.inc",
            "include/format/pe_reloc.inc",
        },
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/format_pe64_dll_export_reloc_user_facade.asm",
        "format-pe64-dll-export-reloc-user-facade.dll",
        "x64",
        "3584",
        &.{
            "include/format/format.inc",
            "include/format/pe32.inc",
            "include/format/pe64.inc",
            "include/format/pe_import.inc",
            "include/format/pe_export.inc",
            "include/format/pe_reloc.inc",
        },
    );
    addCoffFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        coff_checker,
        "tests/format/format_coff32_user_facade.asm",
        "format-coff32-user-facade.obj",
        "x86",
        "240",
        &.{
            "include/format/format.inc",
            "include/format/coff.inc",
            "include/format/coff32.inc",
        },
        &.{ "0x14c", "3", "164", "4", "0", "152", "1", "1", "3", "0x14" },
    );
    addCoffFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        coff_checker,
        "tests/format/format_coff64_user_facade.asm",
        "format-coff64-user-facade.obj",
        "x64",
        "240",
        &.{
            "include/format/format.inc",
            "include/format/coff.inc",
            "include/format/coff64.inc",
        },
        &.{ "0x8664", "3", "164", "4", "0", "152", "1", "1", "3", "0x4" },
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/format_invalid_section_attribute.asm",
        "x64",
        &.{"include/format/format.inc"},
        "unknown format section attribute",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/format_pe_duplicate_section_names.asm",
        "x64",
        &.{"include/format/format.inc"},
        "format section name is duplicated",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/format_pe_duplicate_special_sections.asm",
        "x64",
        &.{"include/format/format.inc"},
        "format special-purpose section is duplicated",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/format_pe_missing_entry.asm",
        "x64",
        &.{
            "include/format/format.inc",
            "include/format/pe64.inc",
        },
        "PE executable or DLL requires an entry address",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/format_object_entry_unsupported.asm",
        "x64",
        &.{"include/format/format.inc"},
        "format plan does not use an executable entry",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/format_elfobj64_invalid_machine.asm",
        "x64",
        &.{"include/format/format.inc"},
        "unsupported ELF64 object machine",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/format_pe_aslr_requires_fixups.asm",
        "x64",
        &.{
            "include/format/format.inc",
            "include/format/pe64.inc",
        },
        "PE ASLR required needs a fixups section",
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/format_elf32_user_facade.asm",
        "format-elf32-user-facade",
        "x86",
        "173",
        &.{
            "include/format/format.inc",
            "include/format/elf32.inc",
            "include/format/elfexe.inc",
        },
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/format_elf64_user_facade.asm",
        "format-elf64-user-facade",
        "x64",
        "309",
        &.{
            "include/format/format.inc",
            "include/format/elf64.inc",
            "include/format/elfexe.inc",
        },
    );
    addAsmSizeFixtureInstalled(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/format_elf64_pie_user_facade.asm",
        "format-elf64-pie-user-facade",
        "x64",
        "316",
        &.{
            "include/format/format.inc",
            "include/format/elf64.inc",
            "include/format/elfexe.inc",
        },
    );
    addElfExeImportFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_exe_import_checker,
        "tests/format/format_elf64_exe_import_user_facade.asm",
        "format-elf64-exe-import-user-facade",
        "x64",
        "752",
        &.{
            "include/format/format.inc",
            "include/format/elfexe_import.inc",
            "include/format/elfexe.inc",
        },
        &.{
            "752",
            "0x400160",
            "0x1b0",
            "0x1d0",
            "0x4021d0",
            "0x200",
            "0x402200",
            "18",
            "0x214",
            "0x402214",
            "0x228",
            "0x402228",
            "24",
            "0x240",
            "0x402240",
            "176",
            "0x1a8",
            "0x4021a8",
            "getpid",
            "libc.so.6",
            "0x170",
            "0x401170",
            "0x190",
            "0x402190",
            "0x228",
            "0x402228",
            "24",
            "0x1a8",
            "0x4021a8",
        },
    );
    addElfFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_program_header_checker,
        "tests/format/format_elf64_exe_import_user_facade.asm",
        "format-elf64-exe-import-user-facade-phdr",
        "x64",
        "752",
        &.{
            "include/format/format.inc",
            "include/format/elfexe_import.inc",
            "include/format/elfexe.inc",
        },
        &.{
            "2",
            "62",
            "64",
            "5",
            "0x400160",
            "2",
            "1",
            "5",
            "0",
            "0x400000",
            "0x400000",
            "366",
            "366",
            "4096",
            "1",
            "5",
            "368",
            "0x401170",
            "0x401170",
            "32",
            "32",
            "4096",
            "1",
            "6",
            "400",
            "0x402190",
            "0x402190",
            "352",
            "352",
            "4096",
            "3",
            "4",
            "432",
            "0x4021b0",
            "0x4021b0",
            "28",
            "28",
            "1",
            "2",
            "6",
            "576",
            "0x402240",
            "0x402240",
            "176",
            "176",
            "8",
        },
    );
    addElfObjFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_obj_checker,
        "tests/format/format_elf32_obj_user_facade.asm",
        "format-elf32-obj-user-facade.o",
        "x86",
        "692",
        &.{
            "include/format/format.inc",
            "include/format/elfobj.inc",
            "include/format/elf_const.inc",
        },
        &.{
            "1",
            "3",
            "0x14c",
            "9",
            "7",
            "4",
            "9",
            "1",
            "0x702",
            "3",
            "64",
            "1",
        },
    );
    addElfObjFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_obj_checker,
        "tests/format/format_elf64_obj_user_facade.asm",
        "format-elf64-obj-user-facade.o",
        "x64",
        "1000",
        &.{
            "include/format/format.inc",
            "include/format/elfobj.inc",
            "include/format/elf_const.inc",
        },
        &.{
            "2",
            "0x3e",
            "0x1a8",
            "9",
            "7",
            "4",
            "4",
            "1",
            "0x700000004",
            "2",
            "64",
            "1",
        },
    );
    addElfObjFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_obj_checker,
        "tests/format/format_elf64_obj_aarch64_user_facade.asm",
        "format-elf64-obj-aarch64-user-facade.o",
        "x64",
        "1016",
        &.{
            "include/format/format.inc",
            "include/format/elfobj.inc",
            "include/format/elf_const.inc",
        },
        &.{
            "2",
            "0xb7",
            "0x1b8",
            "9",
            "7",
            "3",
            "4",
            "0",
            "0x50000011b",
        },
    );
    addElfFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_program_header_checker,
        "tests/format/format_elf64_so_export_user_facade.asm",
        "format-elf64-so-export-user-facade.so",
        "x64",
        "1120",
        &.{
            "include/format/format.inc",
            "include/format/elfso.inc",
            "include/format/elf_export.inc",
        },
        &.{
            "2",
            "62",
            "64",
            "4",
            "0x0",
            "3",
            "1",
            "5",
            "0",
            "0x0",
            "0x0",
            "296",
            "296",
            "4096",
            "1",
            "6",
            "296",
            "0x1128",
            "0x1128",
            "8",
            "8",
            "4096",
            "1",
            "6",
            "304",
            "0x2130",
            "0x2130",
            "816",
            "816",
            "4096",
            "2",
            "6",
            "440",
            "0x21b8",
            "0x21b8",
            "112",
            "112",
            "8",
        },
    );
    addElfFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_program_header_checker,
        "tests/format/format_elf64_so_import_user_facade.asm",
        "format-elf64-so-import-user-facade.so",
        "x64",
        "1744",
        &.{
            "include/format/format.inc",
            "include/format/elfso.inc",
            "include/format/elfso_import.inc",
        },
        &.{
            "2",
            "62",
            "64",
            "6",
            "0x0",
            "3",
            "1",
            "5",
            "0",
            "0x0",
            "0x0",
            "413",
            "413",
            "4096",
            "1",
            "6",
            "416",
            "0x11a0",
            "0x11a0",
            "0",
            "64",
            "4096",
            "1",
            "6",
            "416",
            "0x21a0",
            "0x21a0",
            "19",
            "19",
            "4096",
            "1",
            "5",
            "448",
            "0x31c0",
            "0x31c0",
            "32",
            "32",
            "4096",
            "1",
            "6",
            "480",
            "0x41e0",
            "0x41e0",
            "1264",
            "1264",
            "4096",
            "2",
            "6",
            "696",
            "0x42b8",
            "0x42b8",
            "192",
            "192",
            "8",
        },
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/format_elf_duplicate_segment_names.asm",
        "x64",
        &.{"include/format/format.inc"},
        "format segment name is duplicated",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/format_elf_missing_entry.asm",
        "x64",
        &.{
            "include/format/format.inc",
            "include/format/elfexe.inc",
        },
        "ELF executable requires an entry address",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/format_elf32_pie_unsupported.asm",
        "x86",
        &.{"include/format/format.inc"},
        "format.inc ELF32 layer currently supports executable mode",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/format_elf64_pie_import_unsupported.asm",
        "x64",
        &.{
            "include/format/format.inc",
            "include/format/elfexe_import.inc",
            "include/format/elfexe.inc",
        },
        "ELF executable imports require fixed-address EXEC mode",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/format_elf_invalid_segment_purpose.asm",
        "x64",
        &.{"include/format/format.inc"},
        "unknown format segment attribute",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/format_elfobj_invalid_section_purpose.asm",
        "x64",
        &.{"include/format/format.inc"},
        "ELF object format API supports code, data, and uninitialized-data sections",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/format_elfobj_discardable_section.asm",
        "x64",
        &.{"include/format/format.inc"},
        "ELF object format API does not expose discardable sections",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/format/format_elf_empty_segment_list.asm",
        "x64",
        &.{"include/format/format.inc"},
        "format plan requires at least one segment",
    );
    addProjectIncludeFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "project-include-search.bin",
        "07c3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/format/pe64_stack_struct_member_access/stack_member_offsets.asm",
        "format-pe64-stack-struct-member-access.bin",
        "x64",
        "4883ec0cc7442404112233448b44240466c744240855664883c40c4883ec07c7442401556677888b44240166c744240599aa4883c4074883ec08c7442403aabbccdd8b4424034883c408",
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe_minimal.asm",
        "format-pe-minimal.exe",
        "x64",
        "1024",
        &.{ "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe64_facade_minimal.asm",
        "format-pe64-facade-minimal.exe",
        "x64",
        "1024",
        &.{ "include/format/pe64.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addPeChecksumFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        pe_checksum_checker,
        "tests/format/pe64_checksum_minimal.asm",
        "format-pe64-checksum-minimal.exe",
        "x64",
        "1536",
        &.{ "include/format/pe64.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe64_direct_four_sections.asm",
        "format-pe64-direct-four-sections.exe",
        "x64",
        "3072",
        &.{ "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe64_facade_large_text.asm",
        "format-pe64-facade-large-text.exe",
        "x64",
        "8704",
        &.{ "include/format/pe64.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe64_facade_large_multisection.asm",
        "format-pe64-facade-large-multisection.exe",
        "x64",
        "9216",
        &.{ "include/format/pe64.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe64_facade_tail_reserve.asm",
        "format-pe64-facade-tail-reserve.exe",
        "x64",
        "1536",
        &.{ "include/format/pe64.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe64_import_minimal.asm",
        "format-pe64-import-minimal.exe",
        "x64",
        "1536",
        &.{ "include/format/pe_import.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe64_stack_struct_member_access/runtime_pe64.asm",
        "format-pe64-stack-struct-member-runtime.exe",
        "x64",
        "1536",
        &.{ "include/format/pe64.inc", "include/format/pe_import.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe64_reloc_minimal.asm",
        "format-pe64-reloc-minimal.dll",
        "x64",
        "1536",
        &.{ "include/format/pe_reloc.inc", "include/format/pe64.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addPeRelocFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        pe_reloc_checker,
        "tests/format/pe64_reloc_grouped.asm",
        "format-pe64-reloc-grouped.dll",
        "x64",
        "5632",
        &.{ "include/format/pe_reloc.inc", "include/format/pe64.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
        &.{ "64", "0x3000", "24", "001000000c00000006a00ea0002000000c00000006a00000" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe64_resource_minimal.asm",
        "format-pe64-resource-minimal.exe",
        "x64",
        "1536",
        &.{ "include/format/pe_resource.inc", "include/format/pe64.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addPeResourceFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        pe_resource_checker,
        "tests/format/pe64_resource_from_res.asm",
        "format-pe64-resource-from-res.exe",
        "x64",
        "1536",
        &.{
            "tests/format/data/pe_resource_named_multilang.res",
            "include/format/pe_resource.inc",
            "include/format/pe64.inc",
            "include/format/pe.inc",
            "include/format/pe_const.inc",
        },
    );
    addElfFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_checker,
        "tests/format/elf64_minimal.asm",
        "format-elf64-minimal",
        "x64",
        "144",
        &.{ "include/format/elfexe.inc", "include/format/elf_const.inc" },
        &.{
            "2",
            "62",
            "64",
            "1",
            "0x400080",
            "0x80",
            "0x400080",
            "9",
        },
    );
    addElfFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_checker,
        "tests/format/elf64_facade_minimal.asm",
        "format-elf64-facade-minimal",
        "x64",
        "144",
        &.{ "include/format/elf64.inc", "include/format/elfexe.inc", "include/format/elf_const.inc" },
        &.{
            "2",
            "62",
            "64",
            "1",
            "0x400080",
            "0x80",
            "0x400080",
            "16",
        },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/elf64_pie_minimal.asm",
        "format-elf64-pie-minimal",
        "x64",
        "144",
        &.{ "include/format/elf64.inc", "include/format/elfexe.inc", "include/format/elf_const.inc" },
    );
    addElfFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_program_header_checker,
        "tests/format/elf64_segment_attributes.asm",
        "format-elf64-segment-attributes",
        "x64",
        "416",
        &.{ "include/format/elf64.inc", "include/format/elfexe.inc", "include/format/elf_const.inc" },
        &.{
            "2",
            "62",
            "64",
            "5",
            "0x400160",
            "2",
            "1",
            "5",
            "0x160",
            "0x400160",
            "0x400160",
            "16",
            "16",
            "0x1000",
            "4",
            "4",
            "0x170",
            "0x400170",
            "0x400170",
            "16",
            "16",
            "1",
            "0x6474e550",
            "4",
            "0x180",
            "0x400180",
            "0x400180",
            "16",
            "16",
            "1",
            "0x6474e552",
            "6",
            "0x190",
            "0x400190",
            "0x400190",
            "16",
            "16",
            "1",
            "0x6474e551",
            "6",
            "0x1a0",
            "0x4001a0",
            "0x4001a0",
            "0",
            "0",
            "1",
        },
    );
    addElfFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_checker,
        "tests/format/elf64_facade_tail_reserve.asm",
        "format-elf64-facade-tail-reserve",
        "x64",
        "144",
        &.{ "include/format/elf64.inc", "include/format/elfexe.inc", "include/format/elf_const.inc" },
        &.{
            "2",
            "62",
            "64",
            "1",
            "0x400080",
            "0x80",
            "0x400080",
            "16",
        },
    );
    addElfFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_program_header_checker,
        "tests/format/elf32_segment_attributes.asm",
        "format-elf32-segment-attributes",
        "x86",
        "288",
        &.{ "include/format/elf32.inc", "include/format/elfexe.inc", "include/format/elf_const.inc" },
        &.{
            "1",
            "3",
            "52",
            "5",
            "0x80480e0",
            "2",
            "1",
            "5",
            "0xe0",
            "0x80480e0",
            "0x80480e0",
            "16",
            "16",
            "0x1000",
            "4",
            "4",
            "0xf0",
            "0x80480f0",
            "0x80480f0",
            "16",
            "16",
            "1",
            "0x6474e550",
            "4",
            "0x100",
            "0x8048100",
            "0x8048100",
            "16",
            "16",
            "1",
            "0x6474e552",
            "6",
            "0x110",
            "0x8048110",
            "0x8048110",
            "16",
            "16",
            "1",
            "0x6474e551",
            "6",
            "0x120",
            "0x8048120",
            "0x8048120",
            "0",
            "0",
            "1",
        },
    );
    addElfExeImportFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_exe_import_checker,
        "tests/format/elf64_exe_import.asm",
        "format-elf64-exe-import",
        "x64",
        "8960",
        &.{ "include/format/elfexe_import.inc", "include/format/elfexe.inc", "include/format/elf_const.inc" },
        &.{
            "8960",
            "0x401000",
            "8448",
            "8512",
            "0x402140",
            "8560",
            "0x402170",
            "18",
            "8580",
            "0x402184",
            "8600",
            "0x402198",
            "24",
            "8624",
            "0x4021b0",
            "160",
            "8192",
            "0x402000",
            "getpid",
            "libc.so.6",
        },
    );
    addElfExeImportFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_exe_import_checker,
        "tests/format/elf64_exe_import_plt.asm",
        "format-elf64-exe-import-plt",
        "x64",
        "8960",
        &.{ "include/format/elfexe_import.inc", "include/format/elfexe.inc", "include/format/elf_const.inc" },
        &.{
            "8960",
            "0x401000",
            "8448",
            "8512",
            "0x402140",
            "8560",
            "0x402170",
            "18",
            "8580",
            "0x402184",
            "8600",
            "0x402198",
            "24",
            "8624",
            "0x4021b0",
            "176",
            "8192",
            "0x402000",
            "getpid",
            "libc.so.6",
            "4352",
            "0x401100",
            "8192",
            "0x402000",
            "8600",
            "0x402198",
            "24",
            "8216",
            "0x402018",
        },
    );
    addElfFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_checker,
        "tests/format/elf64_multisegment.asm",
        "format-elf64-multisegment",
        "x64",
        "193",
        &.{ "include/format/elfexe.inc", "include/format/elf_const.inc" },
        &.{
            "2",
            "62",
            "64",
            "2",
            "0x4000b0",
            "0xb0",
            "0x4000b0",
            "13",
            "0xbd",
            "0x4010bd",
            "4",
        },
    );
    addElfObjFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_obj_checker,
        "tests/format/elf64_reloc.asm",
        "format-elf64-reloc.o",
        "x64",
        "1040",
        &.{ "include/format/elfobj.inc", "include/format/elf_const.inc" },
        &.{
            "2",
            "62",
            "464",
            "9",
            "7",
            "4",
            "4",
            "2",
            "0x200000002",
            "3",
            "64",
            "1",
        },
    );
    addElfObjFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_obj_checker,
        "tests/format/elf64_facade_late_tables.asm",
        "format-elf64-facade-late-tables.o",
        "x64",
        "528",
        &.{ "include/format/elfobj.inc", "include/format/elf_const.inc" },
        &.{
            "2",
            "62",
            "208",
            "5",
            "4",
            "2",
            "4",
            "1",
            "0x200000002",
        },
    );
    addElfSoFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_so_checker,
        "tests/format/elf64_so_export.asm",
        "format-elf64-so-export.so",
        "x64",
        "984",
        &.{ "include/format/elf_export.inc", "include/format/elfso.inc", "include/format/elf_const.inc" },
        &.{
            "536",
            "7",
            "6",
            "248",
            "248",
            "0x10f8",
            "240",
            "376",
            "0x1178",
            "112",
            "248",
            "0x10f8",
            "320",
            "0x1140",
            "31",
            "352",
            "0x1160",
            "2",
            "x_add7",
            "240",
            "4",
            "x_sub3",
            "244",
            "4",
        },
    );
    addElfSoImportFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_so_import_checker,
        "tests/format/elf64_so_import.asm",
        "format-elf64-so-import.so",
        "x64",
        "1448",
        &.{ "include/format/elfso_import.inc", "include/format/elfso.inc", "include/format/elf_const.inc" },
        &.{
            "1448",
            "808",
            "320",
            "320",
            "0x1140",
            "32",
            "352",
            "0x2160",
            "384",
            "384",
            "0x2180",
            "456",
            "0x21c8",
            "55",
            "512",
            "0x2200",
            "536",
            "0x2218",
            "24",
            "560",
            "0x2230",
            "176",
            "376",
            "0x2178",
            "336",
            "0x1150",
            "352",
            "0x2160",
            "536",
            "0x2218",
            "24",
            "puts",
        },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe_multisection.asm",
        "format-pe-multisection.exe",
        "x64",
        "1536",
        &.{ "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe_dll64_minimal.asm",
        "format-pe-dll64-minimal.dll",
        "x64",
        "1024",
        &.{ "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe_dll64_import_minimal.asm",
        "format-pe-dll64-import-minimal.dll",
        "x64",
        "1536",
        &.{ "include/format/pe_import.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addPeExportFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        pe_export_checker,
        "tests/format/pe64_export_minimal.asm",
        "format-pe64-export-minimal.dll",
        "x64",
        "1536",
        &.{ "include/format/pe_export.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
        &.{ "64", "0x2000", "100", "1", "xirasm_export64.dll", "xir_add7", "0x1000", "xir_sub3", "0x1006" },
    );
    addElfFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_checker,
        "tests/format/elf32_minimal.asm",
        "format-elf32-minimal",
        "x86",
        "112",
        &.{ "include/format/elfexe.inc", "include/format/elf_const.inc" },
        &.{
            "1",
            "3",
            "52",
            "1",
            "0x8048060",
            "0x60",
            "0x8048060",
            "9",
        },
    );
    addElfFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_checker,
        "tests/format/elf32_facade_tail_reserve.asm",
        "format-elf32-facade-tail-reserve",
        "x86",
        "112",
        &.{ "include/format/elf32.inc", "include/format/elfexe.inc", "include/format/elf_const.inc" },
        &.{
            "1",
            "3",
            "52",
            "1",
            "0x8048060",
            "0x60",
            "0x8048060",
            "16",
        },
    );
    addElfFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_checker,
        "tests/format/elf32_facade_minimal.asm",
        "format-elf32-facade-minimal",
        "x86",
        "112",
        &.{ "include/format/elf32.inc", "include/format/elfexe.inc", "include/format/elf_const.inc" },
        &.{
            "1",
            "3",
            "52",
            "1",
            "0x8048060",
            "0x60",
            "0x8048060",
            "16",
        },
    );
    addElfFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_checker,
        "tests/format/elf32_multisegment.asm",
        "format-elf32-multisegment",
        "x86",
        "145",
        &.{ "include/format/elfexe.inc", "include/format/elf_const.inc" },
        &.{
            "1",
            "3",
            "52",
            "2",
            "0x8048080",
            "0x80",
            "0x8048080",
            "13",
            "0x8d",
            "0x804908d",
            "4",
        },
    );
    addElfObjFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        elf_obj_checker,
        "tests/format/elf32_reloc.asm",
        "format-elf32-reloc.o",
        "x86",
        "704",
        &.{ "include/format/elfobj.inc", "include/format/elf_const.inc" },
        &.{
            "1",
            "3",
            "344",
            "9",
            "7",
            "4",
            "9",
            "2",
            "0x201",
            "3",
            "64",
            "1",
        },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/coff64_minimal.asm",
        "format-coff64-minimal.obj",
        "x64",
        "178",
        &.{ "include/format/coff.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/coff64_facade_minimal.asm",
        "format-coff64-facade-minimal.obj",
        "x64",
        "108",
        &.{ "include/format/coff64.inc", "include/format/coff.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/coff64_facade_tail_reserve.asm",
        "format-coff64-facade-tail-reserve.obj",
        "x64",
        "170",
        &.{ "include/format/coff64.inc", "include/format/coff.inc", "include/format/pe_const.inc" },
    );
    addCoffFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        coff_checker,
        "tests/format/coff64_facade_late_tables.asm",
        "format-coff64-facade-late-tables.obj",
        "x64",
        "138",
        &.{ "include/format/coff64.inc", "include/format/coff.inc", "include/format/pe_const.inc" },
        &.{
            "0x8664",
            "1",
            "80",
            "3",
            "0",
            "68",
            "1",
            "1",
            "2",
            "0x0004",
        },
    );
    addCoffWeakFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        coff_checker,
        coff_weak_checker,
        "tests/format/coff64_weak_alias.asm",
        "format-coff64-weak-alias.obj",
        "x64",
        "182",
        &.{ "include/format/coff.inc", "include/format/pe_const.inc" },
        &.{
            "0x8664",
            "1",
            "88",
            "5",
            "0",
            "76",
            "1",
            "1",
            "3",
            "0x0004",
        },
        &.{
            "0x8664",
            "88",
            "5",
            "3",
            "2",
            "0x00006e666b616577",
            "0x20",
        },
    );
    addCoffFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        coff_checker,
        "tests/format/coff64_reloc.asm",
        "format-coff64-reloc.obj",
        "x64",
        "138",
        &.{ "include/format/coff.inc", "include/format/pe_const.inc" },
        &.{
            "0x8664",
            "1",
            "80",
            "3",
            "0",
            "68",
            "1",
            "1",
            "2",
            "0x0004",
        },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/coff32_minimal.asm",
        "format-coff32-minimal.obj",
        "x86",
        "108",
        &.{ "include/format/coff.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/coff32_facade_minimal.asm",
        "format-coff32-facade-minimal.obj",
        "x86",
        "108",
        &.{ "include/format/coff32.inc", "include/format/coff.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/coff32_facade_tail_reserve.asm",
        "format-coff32-facade-tail-reserve.obj",
        "x86",
        "170",
        &.{ "include/format/coff32.inc", "include/format/coff.inc", "include/format/pe_const.inc" },
    );
    addCoffFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        coff_checker,
        "tests/format/coff32_reloc.asm",
        "format-coff32-reloc.obj",
        "x86",
        "138",
        &.{ "include/format/coff.inc", "include/format/pe_const.inc" },
        &.{
            "0x14c",
            "1",
            "80",
            "3",
            "0",
            "68",
            "1",
            "1",
            "2",
            "0x0014",
        },
    );
    addCoffWeakFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        coff_checker,
        coff_weak_checker,
        "tests/format/coff32_weak_alias.asm",
        "format-coff32-weak-alias.obj",
        "x86",
        "182",
        &.{ "include/format/coff.inc", "include/format/pe_const.inc" },
        &.{
            "0x14c",
            "1",
            "88",
            "5",
            "0",
            "76",
            "1",
            "1",
            "3",
            "0x0014",
        },
        &.{
            "0x14c",
            "88",
            "5",
            "3",
            "2",
            "0x006e666b6165775f",
            "0x20",
        },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe32_minimal.asm",
        "format-pe32-minimal.exe",
        "x86",
        "1024",
        &.{ "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe32_facade_minimal.asm",
        "format-pe32-facade-minimal.exe",
        "x86",
        "1024",
        &.{ "include/format/pe32.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addPeChecksumFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        pe_checksum_checker,
        "tests/format/pe32_checksum_minimal.asm",
        "format-pe32-checksum-minimal.exe",
        "x86",
        "1024",
        &.{ "include/format/pe32.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe32_direct_four_sections.asm",
        "format-pe32-direct-four-sections.exe",
        "x86",
        "3072",
        &.{ "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe32_facade_large_text.asm",
        "format-pe32-facade-large-text.exe",
        "x86",
        "8704",
        &.{ "include/format/pe32.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe32_facade_large_multisection.asm",
        "format-pe32-facade-large-multisection.exe",
        "x86",
        "9216",
        &.{ "include/format/pe32.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe32_facade_tail_reserve.asm",
        "format-pe32-facade-tail-reserve.exe",
        "x86",
        "1536",
        &.{ "include/format/pe32.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addPeExportFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        pe_export_checker,
        "tests/format/pe32_export_minimal.asm",
        "format-pe32-export-minimal.dll",
        "x86",
        "1536",
        &.{ "include/format/pe_export.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
        &.{ "32", "0x2000", "100", "1", "xirasm_export32.dll", "xir_add7", "0x1000", "xir_sub3", "0x1006" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe32_multisection.asm",
        "format-pe32-multisection.exe",
        "x86",
        "1536",
        &.{ "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe_dll32_minimal.asm",
        "format-pe-dll32-minimal.dll",
        "x86",
        "1024",
        &.{ "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe_dll32_import_minimal.asm",
        "format-pe-dll32-import-minimal.dll",
        "x86",
        "1536",
        &.{ "include/format/pe_import.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe32_import_minimal.asm",
        "format-pe32-import-minimal.exe",
        "x86",
        "1536",
        &.{ "include/format/pe_import.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe32_reloc_minimal.asm",
        "format-pe32-reloc-minimal.dll",
        "x86",
        "1536",
        &.{ "include/format/pe_reloc.inc", "include/format/pe32.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addPeRelocFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        pe_reloc_checker,
        "tests/format/pe32_reloc_grouped.asm",
        "format-pe32-reloc-grouped.dll",
        "x86",
        "5632",
        &.{ "include/format/pe_reloc.inc", "include/format/pe32.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
        &.{ "32", "0x3000", "24", "001000000c00000006300a30002000000c00000006300000" },
    );
    addAsmSizeFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        "tests/format/pe32_resource_minimal.asm",
        "format-pe32-resource-minimal.exe",
        "x86",
        "1536",
        &.{ "include/format/pe_resource.inc", "include/format/pe32.inc", "include/format/pe.inc", "include/format/pe_const.inc" },
    );
    addPeResourceFixtureWithInputs(
        b,
        fixture_step,
        exe,
        file_size_checker,
        pe_resource_checker,
        "tests/format/pe32_resource_from_res.asm",
        "format-pe32-resource-from-res.exe",
        "x86",
        "1536",
        &.{
            "tests/format/data/pe_resource_named_multilang.res",
            "include/format/pe_resource.inc",
            "include/format/pe32.inc",
            "include/format/pe.inc",
            "include/format/pe_const.inc",
        },
    );

    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/x86/basic.asm",
        "x86-basic.bin",
        "x64",
        "b8010000004883c002c3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/backend_risk_matrix.asm",
        "isa-x86-backend-risk-matrix.bin",
        "x64",
        "00000000000000000000000041424344000000008b05eeffffff48813ddbffffff44332211483dffffff7f483d00000080488d35d4ffffff488d3dd1ffffffb904000000f3a4c3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/frontend_const_fixup_matrix.asm",
        "isa-x86-frontend-const-fixup-matrix.bin",
        "x64",
        "00000000000000000000000000000000000000000000000000000000000000004883fa078b05deffffff8b0dd8ffffff488d1dd1ffffff48833dc9ffffffff833dc2ffffff00ff15ccffffffff25beffffffc3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/addressing64_matrix.asm",
        "isa-x86-addressing64-matrix.bin",
        "x64",
        "908b407f8b80800000008b40808b807fffffff8b4500418b45008b0424418b04248b048d785634128b4408108b4408108b44c880438b845d7fffffff8b05beffffff80387f8038ff6681383412813878563412488338ff48813844332211f2aef3a6",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/addressing32_matrix.asm",
        "isa-x86-addressing32-matrix.bin",
        "x64",
        "908b407f8b80800000008b40808b807fffffff8b45008b04248b048d785634128b4408108b4408108b44c88080387f8038ff6681383412813878563412f2aef3a6",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/branch_boundary_matrix.asm",
        "isa-x86-branch-boundary-matrix.bin",
        "x64",
        "eb0090eb7f9090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090eb80e90d000000e8090000000f850400000090c3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/branch_call_forward_edges.asm",
        "isa-x86-branch-call-forward-edges.bin",
        "x64",
        "eb7f90909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090e9800000009090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090757f909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090900f85800000009090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090e87f00000090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090e8800000009090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090c3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/branch_call_backward_edges.asm",
        "isa-x86-branch-call-backward-edges.bin",
        "x64",
        "909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090eb8090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090e97fffffff90909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909075809090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090900f857fffffff909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090e880ffffff90909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090909090e87fffffff",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/branch_cross_region.asm",
        "isa-x86-branch-cross-region.bin",
        "x64",
        "e9fb0f0000e8f60f00000f85f00f0000e8ec0f0000e9e80f0000c39090",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/rip_relative_indirect_matrix.asm",
        "isa-x86-rip-relative-indirect-matrix.bin",
        "x64",
        "ff1527000000ff2529000000488b052a000000488d1d2b000000813d190000004433221148833d19000000ff900000000000000000000000000000000000000000000000000000000000000000",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/immediate_rules_matrix.asm",
        "isa-x86-immediate-rules-matrix.bin",
        "x64",
        "047f6605341205785634124805785634124883c0ff2c7f662d34122d78563412482d785634123c7f663d34123d78563412483d78563412a87f66a93412a97856341248a97856341266b83412b87856341248b8f0debc9a785634126a7f68341200006878563412",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/frontend_expression_immediate_matrix.asm",
        "isa-x86-frontend-expression-immediate-matrix.bin",
        "x64",
        "4981c37fffffff4983c3804983c37f4981c3800000004981c3ff0000004981c3000100004981c3ff0f00004981eb800000004981fb80000000688000000049d1e3c3",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/negative/symbolic_signed_immediate_overflow.asm",
        "x64",
        &.{},
        "does not fit the signed 32-bit field",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/expression_fixups/symbolic_width_matrix64.asm",
        "isa-x86-expression-fixups-symbolic-width-matrix64.bin",
        "x64",
        "04656605650005650000004981c3650000004981d3650000004981db650000004981e3650000004981cb650000004981f3650000004981eb650000004981fb6500000049f7c3650000004d69db65000000686500000049c1e36548813d0100000066000000c30000000000000000",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/expression_fixups/symbolic_width_matrix32.asm",
        "isa-x86-expression-fixups-symbolic-width-matrix32.bin",
        "x64",
        "041666051600051600000069c0160000006816000000c3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/expression_fixups/symbolic_width_matrix16.asm",
        "isa-x86-expression-fixups-symbolic-width-matrix16.bin",
        "x64",
        "040c050c0069c00c00680c00c3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/expression_fixups/symbol_expression_matrix.asm",
        "isa-x86-expression-fixups-symbol-expression-matrix.bin",
        "x64",
        "b8270000004981c32b0000004981eb230000004981fb2a0000008b050b000000488d1dfcffffffc3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/expression_fixups/two_immediate_fixups.asm",
        "isa-x86-expression-fixups-two-immediate-fixups.bin",
        "x64",
        "c8040005c3c3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/expression_fixups/label_difference_immediate.asm",
        "isa-x86-expression-fixups-label-difference-immediate.bin",
        "x64",
        "90b806000000c3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/expression_fixups/symbolic_memory_displacements.asm",
        "isa-x86-expression-fixups-symbolic-memory-displacements.bin",
        "x64",
        "8b801e0000008b84881e000000418b851e00000062f17e486f801e000000c3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/expression_fixups/compile_time_sub_byte_immediate.asm",
        "isa-x86-expression-fixups-compile-time-sub-byte-immediate.bin",
        "x64",
        "6264cc0c39f2",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/expression_fixups/explicit_short_layout_repatch.asm",
        "isa-x86-expression-fixups-explicit-short-layout-repatch.bin",
        "x64",
        "eb06b80800000090c3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/expression_fixups/cross_region_expression_fixups.asm",
        "isa-x86-expression-fixups-cross-region-expression-fixups.bin",
        "x64",
        "b8002000004981c3042000008b05ee0f0000c3",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/expression_fixups/negative/signed_dual_fixup_overflow.asm",
        "x64",
        &.{},
        "does not fit the signed 32-bit field",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/expression_fixups/negative/fixed_imm8_overflow.asm",
        "x64",
        &.{},
        "does not fit the unsigned 8-bit field",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/expression_fixups/negative/fixed_imm16_overflow.asm",
        "x64",
        &.{},
        "does not fit the signed-or-unsigned 16-bit field under wrap policy",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/expression_fixups/negative/wrap32_overflow.asm",
        "x64",
        &.{},
        "does not fit the signed-or-unsigned 32-bit field under wrap policy",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/expression_fixups/negative/symbolic_memory_displacement_overflow.asm",
        "x64",
        &.{},
        "does not fit the signed 32-bit field",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/expression_fixups/negative/symbolic_sub_byte_immediate.asm",
        "x64",
        &.{},
        "symbolic sub-byte immediate is unsupported; use a compile-time constant",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/absolute_moffs_matrix.asm",
        "isa-x86-absolute-moffs-matrix.bin",
        "x64",
        "488b04257856341248890425785634128a0425785634128804257856341248a1f0debc9a7856341248a3f0debc9a785634128a04257856341288042578563412",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/prefix_matrix.asm",
        "isa-x86-prefix-matrix.bin",
        "x64",
        "f0830301f3a4f3a6f2ae64488b0365488b4304",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/x86/addressing16_matrix.asm",
        "isa-x86-addressing16-matrix.bin",
        "x64",
        "8b008b018b028b038b048b058b46008b078b407f8b8080008b40808b807fff",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/negative_cmp_r64_imm64.asm",
        "x64",
        &.{},
        "x86-64 cmp r64 accepts only imm8 or sign-extended imm32 immediates; load wider constants into a register first",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/negative_cmp_r64_unsigned_imm32.asm",
        "x64",
        &.{},
        "x86-64 cmp r64 accepts only imm8 or sign-extended imm32 immediates; load wider constants into a register first",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/negative_rsp_index.asm",
        "x64",
        &.{},
        "x86 SIB addressing cannot use rsp/esp/sp as an index register",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/negative_branch_short_out_of_range.asm",
        "x64",
        &.{},
        "does not fit the signed 8-bit displacement",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/negative_branch_jcc_short_forward_out_of_range.asm",
        "x64",
        &.{},
        "does not fit the signed 8-bit displacement",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/negative_branch_jmp_short_backward_out_of_range.asm",
        "x64",
        &.{},
        "does not fit the signed 8-bit displacement",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/negative_branch_jcc_short_backward_out_of_range.asm",
        "x64",
        &.{},
        "does not fit the signed 8-bit displacement",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/negative_ambiguous_memory_size.asm",
        "x64",
        &.{},
        "x86 memory operand size is ambiguous; add byte, word, dword, or qword",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/negative_invalid_memory_scale.asm",
        "x64",
        &.{},
        "x86 memory scale must be 1, 2, 4, or 8",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/negative_high8_rex.asm",
        "x64",
        &.{},
        "x86 high 8-bit registers cannot be encoded with a REX prefix or extended register",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/negative_address_size_mismatch.asm",
        "x64",
        &.{},
        "x86 addressing registers do not match the active address size",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/negative_lock_cmp_prefix.asm",
        "x64",
        &.{},
        "unsupported x86 prefix combination for this instruction",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/x86/negative_duplicate_base_index.asm",
        "x64",
        &.{},
        "unsupported x86 operand syntax",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/flat/data.asm",
        "flat-data.bin",
        "x64",
        "eb0000fe9090909055aa",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/flat/data_aliases.asm",
        "flat-data-aliases.bin",
        "x64",
        "41424344221166554433080706050403020106050403020107080000000000000000090a00000000000000000000000000000b0c0000000000000000000000000000000000000000000000000000000000000d0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ff0000ee00000000dd0000000000000000cc000000000000f100000000000000000000f200000000000000000000000000000000f30000000000000000000000000000000000000000000000000000000000000000f400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f5",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/floats.asm",
        "meta-floats.bin",
        "x64",
        "0000c03f0000000000000080000000000000144000000040010000000000000001000000",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/functions_scopes.asm",
        "meta-functions-scopes.bin",
        "x64",
        "02030201",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/if_procedure_dispatch.asm",
        "meta-if-procedure-dispatch.bin",
        "x64",
        "b811000000b822000000c3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/assignment.asm",
        "meta-assignment.bin",
        "x64",
        "02292a",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/same_line_else.asm",
        "meta-same-line-else.bin",
        "x64",
        "1122",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/multiline_function_args.asm",
        "meta-multiline-function-args.bin",
        "x64",
        "220304",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/multiline_function_params.asm",
        "meta-multiline-function-params.bin",
        "x64",
        "01020304050607",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/return_functions.asm",
        "meta-return-functions.bin",
        "x64",
        "00024f4b4142",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/return_functions_finalizer.asm",
        "meta-return-functions-finalizer.bin",
        "x64",
        "0800000041424300",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/final_byte_fold.asm",
        "meta-final-byte-fold.bin",
        "x64",
        "0a0141424344",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/string_escapes.asm",
        "meta-string-escapes.bin",
        "x64",
        "610a62ff610962ff610d62ff615c62ff612262ff612262ff615c7162ff010141ff001effc3a9ff5c753431ff610a62ff",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/macro_operand_instruction_forms.asm",
        "meta-macro-operand-instruction-forms.bin",
        "x64",
        "b82a000000bb2b000000",
    );
    // The encoder reports a displacement it had to cut down to its field, and
    // the frontend used to drop that warning on the floor: the instruction was
    // assembled quietly while addressing somewhere else. The bytes are what the
    // reference assembler emits for the same input.
    addDiagnosticAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/absolute_address_warning.asm",
        "meta-absolute-address-warning.bin",
        "x64",
        "488b042500000000",
        &.{},
        &.{":9:1: warning: displacement exceeds bounds"},
    );
    // A late_layout block starts with the default region active, so a block
    // written inside another region appends somewhere else. The warning is the
    // only thing that says so.
    addDiagnosticAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/late_layout_default_region_warning.asm",
        "meta-late-layout-default-region-warning.bin",
        "x64",
        "ee",
        &.{},
        &.{":9:1: warning: this late_layout block was written inside region 'text'"},
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/loops.asm",
        "meta-loops.bin",
        "x64",
        "00010203aa",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/control_flow.asm",
        "meta-control-flow.bin",
        "x64",
        "1122000203050701030410111201000304",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/trailing_comments.asm",
        "meta-trailing-comments.bin",
        "x64",
        "019012064142",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/region_place_generated_code.asm",
        "meta-region-place-generated-code.bin",
        "x64",
        "90000000000000000000000000000000e8fb7fffffe9f6ffffffcc",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/here_after_instructions.asm",
        "meta-here-after-instructions.bin",
        "x64",
        "909002000000b806000000c3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/virtual_load_store.asm",
        "meta-virtual-load-store.bin",
        "x64",
        "34523c453223108887868584838281",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/virtual_load_store_gaps.asm",
        "meta-virtual-load-store-gaps.bin",
        "x64",
        "bb22b3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/finalization_backfill.asm",
        "meta-finalization-backfill.bin",
        "x64",
        "0800000008000000414243444f4b2121",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/custom_format_backfill.asm",
        "meta-custom-format-backfill.bin",
        "x64",
        "5849463114000000100000009a0000004f4b2121",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/custom_format_tail_reserve.asm",
        "meta-custom-format-tail-reserve.bin",
        "x64",
        "4844523039000000040000001900000039000000aa000000ee",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/output_area_section_tail_reserve.asm",
        "meta-output-area-section-tail-reserve.bin",
        "x64",
        "4142",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/output_area_org_middle_reserve.asm",
        "meta-output-area-org-middle-reserve.bin",
        "x64",
        "4100000042",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/output_area_cursor_facts.asm",
        "meta-output-area-cursor-facts.bin",
        "x64",
        "aa000000bb",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/late_layout_virtual_append.asm",
        "meta-late-layout-virtual-append.bin",
        "x64",
        "104142",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/late_layout_file_offsets.asm",
        "meta-late-layout-file-offsets.bin",
        "x64",
        "aa000000bb",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/finalizer_function_capture.asm",
        "meta-finalizer-function-capture.bin",
        "x64",
        "0300000000410a225c010203",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/string_bytes_helpers.asm",
        "meta-string-bytes-helpers.bin",
        "x64",
        "4b45524e084b45522124ffff341211",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/crypto_helpers.asm",
        "meta-crypto-helpers.bin",
        "x64",
        "2639f4cba9993e364706816aba3e25717850c26c9cd0d89d",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/deflate_helpers.asm",
        "meta-deflate-helpers.bin",
        "x64",
        "37000b000b000b00020037000000",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/list_helpers.asm",
        "meta-list-helpers.bin",
        "x64",
        "01aa03044f4b3412",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/collection_mutation.asm",
        "meta-collection-mutation.bin",
        "x64",
        "040203020702",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/split_join_helpers.asm",
        "meta-split-join-helpers.bin",
        "x64",
        "036d6f7603616464037265740b6d6f767c6164647c726574",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/map_helpers.asm",
        "meta-map-helpers.bin",
        "x64",
        "0461726368046d6f6465414221",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/token_match_helpers.asm",
        "meta-token-match-helpers.bin",
        "x64",
        "03726178075b7262782b345d2a024f4b4d495353",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/dynamic_symbols.asm",
        "meta-dynamic-symbols.bin",
        "x64",
        "a100b202c304",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/isa_text.asm",
        "meta-isa-text.bin",
        "x64",
        "c5fc58c1c5f458cac5ec58d3c3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/macro_core.asm",
        "meta-macro-core.bin",
        "x64",
        "08080801020300010289d890",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/isa_text_label.asm",
        "meta-isa-text-label.bin",
        "x64",
        "e900000000c3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/include_import/main.asm",
        "meta-include-import.bin",
        "x64",
        "4234340506",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/data_file/main.asm",
        "meta-data-file.bin",
        "x64",
        "4f4b42494e0a42494e0a494e40636667",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/data_file/range.asm",
        "meta-data-file-range.bin",
        "x64",
        "494e42494e0a",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/data_file/json.asm",
        "meta-data-file-json.bin",
        "x64",
        "4a534f4e400102034f4b",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/data_file/list_dir.asm",
        "meta-data-file-list-dir.bin",
        "x64",
        "05",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/struct/pack_sizeof.asm",
        "struct-pack-sizeof.bin",
        "x64",
        "04414243444883ec10",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/struct/aggregate_builtin_arg.asm",
        "struct-aggregate-builtin-arg.bin",
        "x64",
        "030402",
    );
    addAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/struct/nested_union.asm",
        "struct-nested-union.bin",
        "x64",
        "cdab66558877ef0100ddccbbaa02010000000b0a0d0c020000000404",
        &.{"tests/struct/nested_union.inc"},
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/x86/branch.asm",
        "x86-branch.bin",
        "x64",
        "eb000f8501000000c3c3",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/x86/encoder_vectors/modes.asm",
        "x86-encoder-vectors-modes.bin",
        "x64",
        "908b4010894320053412908b448b1089442408057856341290488b448b104889442408480578563412",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/x86/encoder_vectors/addressing64.asm",
        "x86-encoder-vectors-addressing64.bin",
        "x64",
        "488b448b084b8b84ec800000004f8b84517856341248894424084f8d5cac40c5fe6f4c9840c4817c109cc880000000c4417de79cbee0000000",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/x86/encoder_vectors/simd_mpsad.asm",
        "x86-encoder-vectors-simd-mpsad.bin",
        "x64",
        "660f3801c1660f3a42c100660f3a42c104660f3a42c108660f3a42c10c660f3a42c101660f3a42c102660f3a42c103",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/x86/encoder_vectors/extended_shapes.asm",
        "x86-encoder-vectors-extended-shapes.bin",
        "x64",
        "8a04257856341289042578563412488b0425f0debc9a48890425f0debc9a83d0ff48835d80ff80782000d001d05dd50fdb080ffcca0f77660f6f5010660f3800d3c4e37904ca01c5ec58cbc4e26d984820c4e27d584830c4e37506c262",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/x86/encoder_vectors/native_source_subset.asm",
        "x86-encoder-vectors-native-source-subset.bin",
        "x64",
        "9064488b03c5e858cbc4413058c26251349c58c262f164d9585010c4e261920c90c4c2499024a8d511506264cc0c39f2",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/riscv/rv32-integer-control.asm",
        "riscv-rv32-integer-control.bin",
        "rv32",
        "9300100013a5f5ff13c6a6059312f30093537e403385c500b306f7403395c502b346f70233f88802032501ff2326b1006364b500e356d6fcef0080006780000013000000",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/riscv/rv64-integer-control.asm",
        "riscv-rv64-integer-control.bin",
        "rv64",
        "9300100013850580b7523412176345233385c500b306f7409312f30193531e413385c502b356f70233e88802033501ff233cb1006304b500e314d6fcef0080006780000013000000",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/riscv/rv64-system-float-atomic.asm",
        "riscv-rv64-system-float-atomic.bin",
        "rv64",
        "0f0030030f1000007300000073001000f312033073e341302f25b606af360714afb7081b07250101272ab1005385c500c316f782531505c0d39505e2",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/riscv/rv64-bit-vector-compressed.asm",
        "riscv-rv64-bit-vector-compressed.bin",
        "rv64",
        "33f5c540b366f74033c888409312036093131e601395256033a6e620b317182933d42461d772360c0780050227000502d7802102574255000504aa8482800100",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/riscv/rv64-compressed-control.asm",
        "riscv-rv64-compressed-control.bin",
        "rv64",
        "010011c0f5fc11a001008280",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/riscv/negative/rv32-rejects-rv64.asm",
        "rv32",
        &.{},
        "unsupported RISC-V instruction form",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/spv/minimal-compute.asm",
        "spv-minimal-compute.spv",
        "spv",
        "030223070006010000000000050000000000000011000200010000000e00030000000000010000000f00050005000000030000006d61696e0000000010000600030000001100000001000000010000000100000013000200010000002100030002000000010000003600050001000000030000000000000002000000f800020004000000fd00010038000100",
    );
    // The same module written with symbolic IDs instead of numbers. `%main` is
    // numbered from its first appearance, which is the OpEntryPoint line, and the
    // names step over the literal `%2`; the expected bytes are therefore the same
    // module with main=1, void=2, fnty=3, lbl=4 and bound 5.
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/isa/spv/symbolic-ids.asm",
        "spv-symbolic-ids.spv",
        "spv",
        "030223070006010000000000050000000000000011000200010000000e00030000000000010000000f00050005000000010000006d61696e0000000010000600010000001100000001000000010000000100000013000200020000002100030003000000020000003600050002000000010000000000000003000000f800020004000000fd00010038000100",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/spv/negative/mixed-data.asm",
        "spv",
        &.{},
        "SPIR-V module instructions cannot be mixed with other ISA, data, reserve, or alignment fragments",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/isa/riscv/negative/atomic-offset-address.asm",
        "rv64",
        &.{},
        "unsupported RISC-V instruction form",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/diagnostics.asm",
        "meta-diagnostics.bin",
        "x64",
        "7d",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/flat/emit_align_queries.asm",
        "flat-emit-align-queries.bin",
        "x64",
        "11554433220807060504030201aaaacc10110000",
    );
    addListingFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        text_contains_checker,
        "tests/listing/basic.asm",
        "listing-basic.bin",
        "listing-basic.lst",
        "x64",
        "b8010000004883c002c3aa0000cc55",
        &.{
            "XIRASM listing",
            "basic.asm",
            "Output size: 15 bytes",
            // The header names the columns, and the legend explains the two row
            // kinds that have no source line of their own.
            "Kind  D  Bytes",
            "gap rows are file bytes no fragment claims",
            "0000000000007c00 00000000",
            "b8 01 00 00 00",
            "mov rax, 1",
            "0000000000007c0a 0000000a",
            "emit.u8(0xaa);",
            "0000000000007c0b 0000000b",
            "00 00",
            "reserve(2);",
            "emit.u16(0x55cc);",
        },
    );
    addListingFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        text_contains_checker,
        "tests/listing/multi_section.asm",
        "listing-multi-section.bin",
        "listing-multi-section.lst",
        "x64",
        "aa00000031c0c300000000000000000011223344",
        &.{
            "Output size: 20 bytes",
            "0000000000401000 00000004",
            "code",
            "31 c0",
            "xor eax, eax",
            "0000000000401002 00000006",
            "ret",
            "0000000000402000 00000010",
            "11 22 33 44",
            "dd(0x44332211);",
            // The sections leave a hole in the file; it is listed as its own
            // bytes instead of silently disappearing between two rows.
            "gap",
        },
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/target_conditions.asm",
        "meta-target-conditions.bin",
        "x64",
        "6465863266523372",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/x86_modes.asm",
        "meta-x86-modes.bin",
        "x64",
        "163264",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/struct/natural_emit_struct.asm",
        "struct-natural-emit-struct.bin",
        "x64",
        "4100000044332211080444332211",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/function_argument_scope.asm",
        "meta-function-argument-scope.bin",
        "x64",
        "0201151f1d1f1d",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/deferred_value_function_image.asm",
        "meta-deferred-value-function-image.bin",
        "x64",
        "785634124433221188776655",
    );
    addAsmFixture(
        b,
        fixture_step,
        exe,
        fixture_checker,
        "tests/meta/deferred_operand_eval.asm",
        "meta-deferred-operand-eval.bin",
        "x64",
        "0800000008000000040000001122334411223344",
    );
    for ([_][]const u8{
        "tests/meta/negative/deferred_operand_unknown.asm",
        "tests/meta/negative/deferred_operand_side_effect.asm",
        "tests/meta/negative/parenthesized_postfix.asm",
        "tests/meta/negative/split_if_header.asm",
        "tests/meta/negative/orphan_else.asm",
        "tests/meta/negative/unmatched_block_end.asm",
    }) |source_path| {
        addFailingAsmFixture(b, fixture_step, exe, source_path, "x64");
    }
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/negative/finalizer_store_past_end.asm",
        "x64",
        &.{},
        "but the finished output image holds",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/negative/finalizer_reads_tail_reserve.asm",
        "x64",
        &.{},
        "does not hold",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/negative/virtual_instruction_reference.asm",
        "x64",
        &.{},
        "put the virtual region in the file with region.place",
    );
    // The needle pins file position as well as wording: an unclosed scratch
    // region is only detected after the last statement runs, and reporting it
    // without a line number is the failure this fixture exists to catch.
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/negative/unclosed_virtual_output.asm",
        "x64",
        &.{},
        ":7:1: error: a virtual output region was opened and never closed",
    );
    // Pins the location and the wording: an unresolved reference used to end as
    // a count with no file and no line.
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/negative/unresolved_macro_operand.asm",
        "x64",
        &.{},
        ":8:5: error: macro operand text operand.eval(42) cannot be encoded as an operand",
    );
    // A member that used to render as `lowering failed: DuplicateSymbol`.
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/negative/duplicate_symbol.asm",
        "x64",
        &.{},
        ":7:1: error: this name is already declared; a label or binding is defined once (DuplicateSymbol)",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/negative/late_layout_final_facts.asm",
        "x64",
        &.{},
        "available only in a finalizer",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/negative/function_error_notes.asm",
        "x64",
        &.{},
        "function invoked here",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/negative/value_function_arity.asm",
        "x64",
        &.{},
        "declares 1 parameter, but this call passes 0",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/negative/value_function_error_notes.asm",
        "x64",
        &.{},
        "function invoked here",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/negative/two_statements_on_one_line.asm",
        "x64",
        &.{},
        "a line holds one statement",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/negative/aggregate_literal_missing_field.asm",
        "x64",
        &.{},
        "leaves a field out",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/negative/argument_type_mismatch.asm",
        "x64",
        &.{},
        "has type string, but parameter v declares u64",
    );
    addFailingAsmFixture(
        b,
        fixture_step,
        exe,
        "tests/meta/err_negative.asm",
        "x64",
    );
    addFailingAsmFixture(
        b,
        fixture_step,
        exe,
        "tests/meta/finalization_forbid_emit.asm",
        "x64",
    );
    addFailingAsmFixture(
        b,
        fixture_step,
        exe,
        "tests/meta/finalization_forbid_output_section.asm",
        "x64",
    );
    addFailingAsmFixture(
        b,
        fixture_step,
        exe,
        "tests/meta/late_layout_after_seal.asm",
        "x64",
    );
    addFailingAsmFixture(
        b,
        fixture_step,
        exe,
        "tests/format/coff64_facade_late_tables_defer_forbid.asm",
        "x64",
    );
    addFailingAsmFixture(
        b,
        fixture_step,
        exe,
        "tests/meta/finalization_store_overflow.asm",
        "x64",
    );
    addFailingAsmFixture(
        b,
        fixture_step,
        exe,
        "tests/meta/data_file/range_oob.asm",
        "x64",
    );
    addFailingAsmFixture(
        b,
        fixture_step,
        exe,
        "tests/meta/return_fn_missing_return.asm",
        "x64",
    );
    addFailingAsmFixture(
        b,
        fixture_step,
        exe,
        "tests/meta/return_fn_type_mismatch.asm",
        "x64",
    );
    addFailingAsmFixture(
        b,
        fixture_step,
        exe,
        "tests/meta/return_fn_side_effect.asm",
        "x64",
    );
    addFailingAsmFixture(
        b,
        fixture_step,
        exe,
        "tests/meta/isa_text_invalid_arg.asm",
        "x64",
    );
    addFailingAsmFixture(
        b,
        fixture_step,
        exe,
        "tests/meta/isa_text_empty.asm",
        "x64",
    );
    addFailingAsmFixture(
        b,
        fixture_step,
        exe,
        "tests/meta/isa_text_finalizer.asm",
        "x64",
    );
    addFailingAsmFixture(
        b,
        fixture_step,
        exe,
        "tests/meta/isa_text_value_fn.asm",
        "x64",
    );
    addFailingAsmFixture(
        b,
        fixture_step,
        exe,
        "tests/meta/procedure_fn_as_expression.asm",
        "x64",
    );
    addFailingAsmFixture(
        b,
        fixture_step,
        exe,
        "tests/meta/return_in_procedure.asm",
        "x64",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/break_outside_loop.asm",
        "x64",
        &.{},
        "break used outside of a Meta loop",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/continue_outside_loop.asm",
        "x64",
        &.{},
        "continue used outside of a Meta loop",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/break_cross_function.asm",
        "x64",
        &.{},
        "break used outside of a Meta loop",
    );
    addFailingAsmFixtureWithInputs(
        b,
        fixture_step,
        exe,
        "tests/meta/break_outside_deferred_loop.asm",
        "x64",
        &.{},
        "break used outside of a Meta loop",
    );
    const perf_step = b.step("test-isa-perf", "Assemble 100K ISA source performance fixture");
    addAsmSizeFixture(
        b,
        perf_step,
        exe,
        file_size_checker,
        text_contains_checker,
        "tests/perf/x86_100k.asm",
        "perf-x86-100k.bin",
        "x64",
        "787501",
        &.{
            "assemble_timings",
            "elapsed_ms=",
            "bytes=787501",
            "instruction_fragments=",
            "target=x86-64",
            "phase=read_source",
            "phase=parse_lower",
            "phase=encode",
            "phase=fixup_resolve",
            "phase=layout",
            "phase=materialize",
            "phase=patch",
            "phase=defer_finalizers",
            "phase=write_output",
        },
    );

    // A top level step for running all tests. dependOn can be called multiple
    // times and since the two run steps do not depend on one another, this will
    // make the two of them run in parallel.
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
    test_step.dependOn(&run_exe_tests.step);
    test_step.dependOn(api_matrix_step);
    test_step.dependOn(api_reference_step);
    test_step.dependOn(release_boundary_step);
    test_step.dependOn(init_build_step);
    test_step.dependOn(fixture_step);

    // Tutorial examples: `tools/doc_examples.py` turns the annotated examples in
    // the manual into fixtures under `tests/tutorial/`, and this step assembles
    // every one of them so the guide cannot drift from the assembler.
    const tutorial_step = b.step(
        "test-tutorial",
        "Assemble the tutorial examples listed in tests/tutorial/manifest.tsv",
    );
    addTutorialFixtures(b, tutorial_step, exe, fixture_checker);
    test_step.dependOn(tutorial_step);

    // Just like flags, top level steps are also listed in the `--help` menu.
    //
    // The Zig build system is entirely implemented in userland, which means
    // that it cannot hook into private compiler APIs. All compilation work
    // orchestrated by the build system will result in other Zig compiler
    // subcommands being invoked with the right flags defined. You can observe
    // these invocations when one fails (or you pass a flag to increase
    // verbosity) to validate assumptions and diagnose problems.
    //
    // Lastly, the Zig build system is relatively simple and self-contained,
    // and reading its source code will allow you to master it.
}

fn addAsmFixture(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_hex: []const u8,
) void {
    addAsmFixtureWithInputs(
        b,
        parent,
        exe,
        checker,
        source_path,
        output_name,
        target_name,
        expected_hex,
        &.{},
    );
}

fn addAsmFixtureInstalled(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_hex: []const u8,
    extra_inputs: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.step.dependOn(b.getInstallStep());
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);

    const check_bytes = b.addRunArtifact(checker);
    check_bytes.addFileArg(output);
    check_bytes.addArg(expected_hex);
    check_bytes.step.dependOn(&run_asm.step);
    parent.dependOn(&check_bytes.step);
}

fn addInitBuildFixture(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    size_checker: *std.Build.Step.Compile,
    project_dir_name: []const u8,
    target_name: []const u8,
    expected_size: []const u8,
) void {
    const run_init = b.addRunArtifact(exe);
    run_init.addArg("init");
    const project_dir = run_init.addOutputDirectoryArg(project_dir_name);
    run_init.addArg("--target");
    run_init.addArg(target_name);
    run_init.addArg("--name");
    run_init.addArg("demo");

    const run_build = b.addRunArtifact(exe);
    run_build.setCwd(project_dir);
    run_build.addArg("build");
    run_build.addArg("-o");
    const output = run_build.addOutputFileArg("init-build-output.bin");
    run_build.step.dependOn(&run_init.step);

    const check_size = b.addRunArtifact(size_checker);
    check_size.addFileArg(output);
    check_size.addArg(expected_size);
    check_size.step.dependOn(&run_build.step);
    parent.dependOn(&check_size.step);
}

fn addAsmFixtureWithInputs(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_hex: []const u8,
    extra_inputs: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);

    const check_bytes = b.addRunArtifact(checker);
    check_bytes.addFileArg(output);
    check_bytes.addArg(expected_hex);
    check_bytes.step.dependOn(&run_asm.step);
    parent.dependOn(&check_bytes.step);
}

fn addDiagnosticAsmFixtureWithInputs(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_hex: []const u8,
    extra_inputs: []const []const u8,
    diagnostic_needles: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);
    for (diagnostic_needles) |needle| {
        run_asm.expectStdErrMatch(needle);
    }

    const check_bytes = b.addRunArtifact(checker);
    check_bytes.addFileArg(output);
    check_bytes.addArg(expected_hex);
    check_bytes.step.dependOn(&run_asm.step);
    parent.dependOn(&check_bytes.step);
}

fn addAsmSizeFixtureInstalled(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    size_checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_size: []const u8,
    extra_inputs: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.step.dependOn(b.getInstallStep());
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);

    const check_size = b.addRunArtifact(size_checker);
    check_size.addFileArg(output);
    check_size.addArg(expected_size);
    check_size.step.dependOn(&run_asm.step);
    parent.dependOn(&check_size.step);
}

fn addProjectIncludeFixture(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    checker: *std.Build.Step.Compile,
    output_name: []const u8,
    expected_hex: []const u8,
) void {
    const project_files = b.addWriteFiles();
    _ = project_files.add("src/main.asm",
        \\import("defs.inc");
        \\emit.u8(project_byte);
        \\ret
        \\
    );
    _ = project_files.add("include/defs.inc",
        \\const project_byte: u64 = 7;
        \\
    );

    const run_asm = b.addRunArtifact(exe);
    run_asm.setCwd(project_files.getDirectory());
    run_asm.addArg("src/main.asm");
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg("x64");
    run_asm.step.dependOn(&project_files.step);

    const check_bytes = b.addRunArtifact(checker);
    check_bytes.addFileArg(output);
    check_bytes.addArg(expected_hex);
    check_bytes.step.dependOn(&run_asm.step);
    parent.dependOn(&check_bytes.step);
}

fn addFailingAsmFixture(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    source_path: []const u8,
    target_name: []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    run_asm.addArg("--target");
    run_asm.addArg(target_name);
    run_asm.expectExitCode(1);
    run_asm.expectStdErrMatch("error:");
    parent.dependOn(&run_asm.step);
}

fn addFailingAsmFixtureWithInputs(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    source_path: []const u8,
    target_name: []const u8,
    extra_inputs: []const []const u8,
    error_needle: []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.step.dependOn(b.getInstallStep());
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("--target");
    run_asm.addArg(target_name);
    run_asm.expectExitCode(1);
    run_asm.expectStdErrMatch("error:");
    run_asm.expectStdErrMatch(error_needle);
    parent.dependOn(&run_asm.step);
}

/// The tutorial fixture list is generated from the manual by
/// `tools/doc_examples.py`, which writes both `tests/tutorial/manifest.tsv`
/// (for review and `doc_examples.py check`) and the imported
/// `tests/tutorial/manifest.zig` (for this loader).
///
/// The loader imports a generated module instead of reading the TSV at
/// configure time on purpose: the build runner caches the configured graph, and
/// a data file read that the graph does not declare as a dependency would not
/// invalidate that cache. An imported module is a real build-script dependency.
fn addTutorialFixtures(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    checker: *std.Build.Step.Compile,
) void {
    const fixtures = tutorial_manifest.fixtures;
    if (fixtures.len == 0) {
        std.debug.print("error: tests/tutorial/manifest.zig declares no fixtures\n", .{});
        std.process.exit(1);
    }

    for (fixtures) |fixture| {
        if (std.mem.startsWith(u8, fixture.expected, "error:")) {
            addFailingAsmFixtureWithInputs(
                b,
                parent,
                exe,
                fixture.source,
                fixture.target,
                &.{},
                fixture.expected["error:".len..],
            );
        } else if (std.mem.startsWith(u8, fixture.expected, "bytes:")) {
            addAsmFixtureWithInputs(
                b,
                parent,
                exe,
                checker,
                fixture.source,
                b.fmt("tutorial-{s}.bin", .{fixture.id}),
                fixture.target,
                fixture.expected["bytes:".len..],
                &.{},
            );
        } else {
            addTutorialOkFixture(b, parent, exe, fixture.source, fixture.target, fixture.id);
        }
    }
}

/// An example asserted only to assemble: the manual shows no expected bytes.
fn addTutorialOkFixture(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    source_path: []const u8,
    target_name: []const u8,
    fixture_id: []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    run_asm.addArg("-o");
    _ = run_asm.addOutputFileArg(b.fmt("tutorial-{s}.bin", .{fixture_id}));
    run_asm.addArg("--target");
    run_asm.addArg(target_name);
    run_asm.expectExitCode(0);
    parent.dependOn(&run_asm.step);
}

fn addAsmSizeFixture(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    size_checker: *std.Build.Step.Compile,
    text_checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_size: []const u8,
    timing_needles: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);
    run_asm.addArg("--progress");
    run_asm.addArg("--trace-phases");
    const stdout = run_asm.captureStdOut(.{ .basename = b.fmt("{s}.timings.txt", .{output_name}) });

    const check_size = b.addRunArtifact(size_checker);
    check_size.addFileArg(output);
    check_size.addArg(expected_size);
    check_size.step.dependOn(&run_asm.step);

    const check_timings = b.addRunArtifact(text_checker);
    check_timings.addFileArg(stdout);
    for (timing_needles) |needle| {
        check_timings.addArg(needle);
    }
    check_timings.step.dependOn(&run_asm.step);

    parent.dependOn(&check_size.step);
    parent.dependOn(&check_timings.step);
}

fn addAsmSizeFixtureWithInputs(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    size_checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_size: []const u8,
    extra_inputs: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);

    const check_size = b.addRunArtifact(size_checker);
    check_size.addFileArg(output);
    check_size.addArg(expected_size);
    check_size.step.dependOn(&run_asm.step);
    parent.dependOn(&check_size.step);
}

fn addPeChecksumFixtureWithInputs(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    size_checker: *std.Build.Step.Compile,
    pe_checksum_checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_size: []const u8,
    extra_inputs: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);

    const check_size = b.addRunArtifact(size_checker);
    check_size.addFileArg(output);
    check_size.addArg(expected_size);
    check_size.step.dependOn(&run_asm.step);

    const check_pe_checksum = b.addRunArtifact(pe_checksum_checker);
    check_pe_checksum.addFileArg(output);
    check_pe_checksum.step.dependOn(&run_asm.step);

    parent.dependOn(&check_size.step);
    parent.dependOn(&check_pe_checksum.step);
}

fn addPeResourceFixtureWithInputs(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    size_checker: *std.Build.Step.Compile,
    pe_resource_checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_size: []const u8,
    extra_inputs: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);

    const check_size = b.addRunArtifact(size_checker);
    check_size.addFileArg(output);
    check_size.addArg(expected_size);
    check_size.step.dependOn(&run_asm.step);

    const check_pe_resource = b.addRunArtifact(pe_resource_checker);
    check_pe_resource.addFileArg(output);
    check_pe_resource.step.dependOn(&run_asm.step);

    parent.dependOn(&check_size.step);
    parent.dependOn(&check_pe_resource.step);
}

fn addPeExportFixtureWithInputs(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    size_checker: *std.Build.Step.Compile,
    pe_export_checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_size: []const u8,
    extra_inputs: []const []const u8,
    pe_export_args: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);

    const check_size = b.addRunArtifact(size_checker);
    check_size.addFileArg(output);
    check_size.addArg(expected_size);
    check_size.step.dependOn(&run_asm.step);

    const check_pe_export = b.addRunArtifact(pe_export_checker);
    check_pe_export.addFileArg(output);
    for (pe_export_args) |arg| {
        check_pe_export.addArg(arg);
    }
    check_pe_export.step.dependOn(&run_asm.step);

    parent.dependOn(&check_size.step);
    parent.dependOn(&check_pe_export.step);
}

fn addPeRelocFixtureWithInputs(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    size_checker: *std.Build.Step.Compile,
    pe_reloc_checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_size: []const u8,
    extra_inputs: []const []const u8,
    pe_reloc_args: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);

    const check_size = b.addRunArtifact(size_checker);
    check_size.addFileArg(output);
    check_size.addArg(expected_size);
    check_size.step.dependOn(&run_asm.step);

    const check_pe_reloc = b.addRunArtifact(pe_reloc_checker);
    check_pe_reloc.addFileArg(output);
    for (pe_reloc_args) |arg| {
        check_pe_reloc.addArg(arg);
    }
    check_pe_reloc.step.dependOn(&run_asm.step);

    parent.dependOn(&check_size.step);
    parent.dependOn(&check_pe_reloc.step);
}

fn addElfFixtureWithInputs(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    size_checker: *std.Build.Step.Compile,
    elf_checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_size: []const u8,
    extra_inputs: []const []const u8,
    elf_args: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);

    const check_size = b.addRunArtifact(size_checker);
    check_size.addFileArg(output);
    check_size.addArg(expected_size);
    check_size.step.dependOn(&run_asm.step);

    const check_elf = b.addRunArtifact(elf_checker);
    check_elf.addFileArg(output);
    for (elf_args) |arg| {
        check_elf.addArg(arg);
    }
    check_elf.step.dependOn(&run_asm.step);

    parent.dependOn(&check_size.step);
    parent.dependOn(&check_elf.step);
}

fn addElfObjFixtureWithInputs(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    size_checker: *std.Build.Step.Compile,
    elf_obj_checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_size: []const u8,
    extra_inputs: []const []const u8,
    elf_obj_args: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);

    const check_size = b.addRunArtifact(size_checker);
    check_size.addFileArg(output);
    check_size.addArg(expected_size);
    check_size.step.dependOn(&run_asm.step);

    const check_elf_obj = b.addRunArtifact(elf_obj_checker);
    check_elf_obj.addFileArg(output);
    for (elf_obj_args) |arg| {
        check_elf_obj.addArg(arg);
    }
    check_elf_obj.step.dependOn(&run_asm.step);

    parent.dependOn(&check_size.step);
    parent.dependOn(&check_elf_obj.step);
}

fn addElfSoFixtureWithInputs(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    size_checker: *std.Build.Step.Compile,
    elf_so_checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_size: []const u8,
    extra_inputs: []const []const u8,
    elf_so_args: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);

    const check_size = b.addRunArtifact(size_checker);
    check_size.addFileArg(output);
    check_size.addArg(expected_size);
    check_size.step.dependOn(&run_asm.step);

    const check_elf_so = b.addRunArtifact(elf_so_checker);
    check_elf_so.addFileArg(output);
    for (elf_so_args) |arg| {
        check_elf_so.addArg(arg);
    }
    check_elf_so.step.dependOn(&run_asm.step);

    parent.dependOn(&check_size.step);
    parent.dependOn(&check_elf_so.step);
}

fn addElfSoImportFixtureWithInputs(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    size_checker: *std.Build.Step.Compile,
    elf_so_import_checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_size: []const u8,
    extra_inputs: []const []const u8,
    elf_so_import_args: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);

    const check_size = b.addRunArtifact(size_checker);
    check_size.addFileArg(output);
    check_size.addArg(expected_size);
    check_size.step.dependOn(&run_asm.step);

    const check_elf_so_import = b.addRunArtifact(elf_so_import_checker);
    check_elf_so_import.addFileArg(output);
    for (elf_so_import_args) |arg| {
        check_elf_so_import.addArg(arg);
    }
    check_elf_so_import.step.dependOn(&run_asm.step);

    parent.dependOn(&check_size.step);
    parent.dependOn(&check_elf_so_import.step);
}

fn addElfExeImportFixtureWithInputs(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    size_checker: *std.Build.Step.Compile,
    elf_exe_import_checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_size: []const u8,
    extra_inputs: []const []const u8,
    elf_exe_import_args: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);

    const check_size = b.addRunArtifact(size_checker);
    check_size.addFileArg(output);
    check_size.addArg(expected_size);
    check_size.step.dependOn(&run_asm.step);

    const check_elf_exe_import = b.addRunArtifact(elf_exe_import_checker);
    check_elf_exe_import.addFileArg(output);
    for (elf_exe_import_args) |arg| {
        check_elf_exe_import.addArg(arg);
    }
    check_elf_exe_import.step.dependOn(&run_asm.step);

    parent.dependOn(&check_size.step);
    parent.dependOn(&check_elf_exe_import.step);
}

fn addCoffFixtureWithInputs(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    size_checker: *std.Build.Step.Compile,
    coff_checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_size: []const u8,
    extra_inputs: []const []const u8,
    coff_args: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);

    const check_size = b.addRunArtifact(size_checker);
    check_size.addFileArg(output);
    check_size.addArg(expected_size);
    check_size.step.dependOn(&run_asm.step);

    const check_coff = b.addRunArtifact(coff_checker);
    check_coff.addFileArg(output);
    for (coff_args) |arg| {
        check_coff.addArg(arg);
    }
    check_coff.step.dependOn(&run_asm.step);

    parent.dependOn(&check_size.step);
    parent.dependOn(&check_coff.step);
}

fn addCoffWeakFixtureWithInputs(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    size_checker: *std.Build.Step.Compile,
    coff_checker: *std.Build.Step.Compile,
    weak_checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    target_name: []const u8,
    expected_size: []const u8,
    extra_inputs: []const []const u8,
    coff_args: []const []const u8,
    weak_args: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    for (extra_inputs) |input_path| {
        run_asm.addFileInput(b.path(input_path));
    }
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);

    const check_size = b.addRunArtifact(size_checker);
    check_size.addFileArg(output);
    check_size.addArg(expected_size);
    check_size.step.dependOn(&run_asm.step);

    const check_coff = b.addRunArtifact(coff_checker);
    check_coff.addFileArg(output);
    for (coff_args) |arg| {
        check_coff.addArg(arg);
    }
    check_coff.step.dependOn(&run_asm.step);

    const check_weak = b.addRunArtifact(weak_checker);
    check_weak.addFileArg(output);
    for (weak_args) |arg| {
        check_weak.addArg(arg);
    }
    check_weak.step.dependOn(&run_asm.step);

    parent.dependOn(&check_size.step);
    parent.dependOn(&check_coff.step);
    parent.dependOn(&check_weak.step);
}

fn addListingFixture(
    b: *std.Build,
    parent: *std.Build.Step,
    exe: *std.Build.Step.Compile,
    byte_checker: *std.Build.Step.Compile,
    text_checker: *std.Build.Step.Compile,
    source_path: []const u8,
    output_name: []const u8,
    listing_name: []const u8,
    target_name: []const u8,
    expected_hex: []const u8,
    listing_needles: []const []const u8,
) void {
    const run_asm = b.addRunArtifact(exe);
    run_asm.addFileArg(b.path(source_path));
    run_asm.addArg("-o");
    const output = run_asm.addOutputFileArg(output_name);
    run_asm.addArg("--listing");
    const listing = run_asm.addOutputFileArg(listing_name);
    run_asm.addArg("--target");
    run_asm.addArg(target_name);

    const check_bytes = b.addRunArtifact(byte_checker);
    check_bytes.addFileArg(output);
    check_bytes.addArg(expected_hex);
    check_bytes.step.dependOn(&run_asm.step);

    const check_listing = b.addRunArtifact(text_checker);
    check_listing.addFileArg(listing);
    for (listing_needles) |needle| {
        check_listing.addArg(needle);
    }
    check_listing.step.dependOn(&run_asm.step);

    parent.dependOn(&check_bytes.step);
    parent.dependOn(&check_listing.step);
}
