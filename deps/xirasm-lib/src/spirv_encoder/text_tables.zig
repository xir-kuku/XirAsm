// Generated file. Do not edit.
// SPIR-V 1.6 revision 7.
// spirv.core.grammar.json: sha256 b3a3be9ce86e016bb0c0328ec4f2d5876bd7af5f0386adfaa544eec1c89fe080
// extinst.glsl.std.450.grammar.json: sha256 cac419d11e1e8997d91d7a2e746ebac4c48ccdc88f173c97c9c759a1134d8aec
// extinst.opencl.std.100.grammar.json: sha256 8557e9a50f055a84f7988d1dd8646134528fcc9d109def195888803bc9cb51ac
// extinst.opencl.debuginfo.100.grammar.json: sha256 71acb00d98fb68b06dc033ea1c98f66b8d4b35ead0d5c34396ac590c87fdeb90
// extinst.nonsemantic.shader.debuginfo.100.grammar.json: sha256 552ac3ed2d7cbd5b2d54667fa378b96967ec368118732a03f6e8d6862499a48d
// extinst.nonsemantic.shader.debuginfo.grammar.json: sha256 9b05ba7f749b9360af00a995d431b43b04f42857e9517db478f291bf51215974
// extinst.debuginfo.grammar.json: sha256 927ee250d6c2c7a2e6f8b6c89583cf2e72002e5e2d64ee811476747b0936469c
// extinst.nonsemantic.debugprintf.grammar.json: sha256 c101f9b54a3f2e513aaeaee251a5ca7d542269cf40a2ab2296ff14b6cc332c36
// extinst.spv-amd-shader-trinary-minmax.grammar.json: sha256 6ef34572b108e457b25f86f74b3b718230026ab2ed88f3be895201af32027172
// extinst.spv-amd-shader-explicit-vertex-parameter.grammar.json: sha256 9343c4acfc86d39f47ad8f3dac61b8b6248d8583fc05c6f19b541b335171b512
// extinst.spv-amd-gcn-shader.grammar.json: sha256 65c2b4e0c81b164d11d9edf1b00fe2fdb5fd7761d3f94e607f796913ae66d4f5
// extinst.spv-amd-shader-ballot.grammar.json: sha256 279715d5778fb3750bf4a9332b086808773bf433851875a125ae13c4276fb7bf
// extinst.nonsemantic.clspvreflection.grammar.json: sha256 b981812fb2ca1f369d7a0bbe940f524f3e32b1c118aca208690e39d77065633a
// extinst.nonsemantic.graph.debuginfo.grammar.json: sha256 1be2ad9cb96b529fe9b91158fde58ddb8c8ae2f56155318f1b926fa477edeb89
// extinst.nonsemantic.vkspreflection.grammar.json: sha256 0800008054befa10fa60937ad2b0a5f185e4b7c804825de585f82f681e0c1359
// extinst.nonsemantic.debugbreak.grammar.json: sha256 486129d2a02666332009319ded75c557392e0cc068f29e7a8ab29c4196ecbad0
// extinst.arm.motion-engine.100.grammar.json: sha256 4f16a0967fd8d143eba7687fc89604611f4baa4939a4ce5a8140c27702a8257f
// extinst.arm.experimental-ml-operations.grammar.json: sha256 aebbd76d14825d6fd1286e798b722318d29e2fc7b28e2dbd0e07c18d758836f4
// extinst.tosa.001000.1.grammar.json: sha256 b82c5b382f49db2c6a2a14f898ffff9ee5c137313528b7235ef41900de3c7ef2
// OpSpecConstantOp list from binary.adoc: sha256 334f76a9d67f68bfb64db7b0b6b5a4767de73f8f148aef1e92358a56e170ff61

const types = @import("types.zig");

pub const Word = types.Word;

pub const OperandKind = enum(u16) {
    access_qualifier,
    addressing_model,
    built_in,
    capability,
    component_type,
    cooperative_matrix_layout,
    cooperative_matrix_operands,
    cooperative_matrix_reduce,
    cooperative_matrix_use,
    cooperative_vector_matrix_layout,
    decoration,
    dim,
    execution_mode,
    execution_model,
    fp_denorm_mode,
    fp_encoding,
    fp_fast_math_mode,
    fp_operation_mode,
    fp_rounding_mode,
    fragment_shading_rate,
    function_control,
    function_parameter_attribute,
    gather_modes,
    group_operation,
    host_access_qualifier,
    id_memory_semantics,
    id_ref,
    id_result,
    id_result_type,
    id_scope,
    image_channel_data_type,
    image_channel_order,
    image_format,
    image_operands,
    initialization_mode_qualifier,
    kernel_enqueue_flags,
    kernel_profiling_info,
    linkage_type,
    literal_context_dependent_number,
    literal_ext_inst_integer,
    literal_float,
    literal_integer,
    literal_spec_constant_op_integer,
    literal_string,
    load_cache_control,
    loop_control,
    matrix_multiply_accumulate_operands,
    memory_access,
    memory_model,
    memory_semantics,
    named_maximum_number_of_registers,
    overflow_modes,
    packed_vector_format,
    pair_id_ref_id_ref,
    pair_id_ref_literal_integer,
    pair_literal_integer_id_ref,
    quantization_modes,
    raw_access_chain_operands,
    ray_flags,
    ray_query_candidate_intersection_type,
    ray_query_committed_intersection_type,
    ray_query_intersection,
    sampler_addressing_mode,
    sampler_filter_mode,
    scope,
    selection_control,
    source_language,
    storage_class,
    store_cache_control,
    tensor_addressing_operands,
    tensor_clamp_mode,
    tensor_operands,
    debug_info_debug_base_type_attribute_encoding,
    debug_info_debug_composite_type,
    debug_info_debug_info_flags,
    debug_info_debug_operation,
    debug_info_debug_type_qualifier,
    nonsemantic_clspv_reflection_kernel_property_flags,
    nonsemantic_shader_debug_info_100_build_identifier_flags,
    nonsemantic_shader_debug_info_100_debug_base_type_attribute_encoding,
    nonsemantic_shader_debug_info_100_debug_composite_type,
    nonsemantic_shader_debug_info_100_debug_imported_entity,
    nonsemantic_shader_debug_info_100_debug_info_flags,
    nonsemantic_shader_debug_info_100_debug_operation,
    nonsemantic_shader_debug_info_100_debug_type_qualifier,
    nonsemantic_shader_debug_info_build_identifier_flags,
    nonsemantic_shader_debug_info_debug_base_type_attribute_encoding,
    nonsemantic_shader_debug_info_debug_composite_type,
    nonsemantic_shader_debug_info_debug_imported_entity,
    nonsemantic_shader_debug_info_debug_info_flags,
    nonsemantic_shader_debug_info_debug_operation,
    nonsemantic_shader_debug_info_debug_type_qualifier,
    opencl_debug_info_100_debug_base_type_attribute_encoding,
    opencl_debug_info_100_debug_composite_type,
    opencl_debug_info_100_debug_imported_entity,
    opencl_debug_info_100_debug_info_flags,
    opencl_debug_info_100_debug_operation,
    opencl_debug_info_100_debug_type_qualifier,
};

pub const OperandCategory = enum {
    bit_enum,
    composite,
    id,
    literal,
    unknown,
    value_enum,
};

pub const Quantifier = enum {
    one,
    optional,
    variable,
};

pub const OperandInfo = struct {
    kind: OperandKind,
    quantifier: Quantifier = .one,
};

pub const OpcodeInfo = struct {
    name: []const u8,
    opcode: u16,
    operands: []const OperandInfo,
};

pub const EnumerantInfo = struct {
    kind: OperandKind,
    name: []const u8,
    value: Word,
    parameters: []const OperandInfo = &.{},
};

pub const ExtInstInfo = struct {
    name: []const u8,
    value: Word,
    operands: []const OperandInfo,
};

pub const ExtInstSet = enum {
    glsl_std_450,
    opencl_std,
    opencl_debug_info_100,
    nonsemantic_shader_debug_info_100,
    nonsemantic_shader_debug_info,
    debug_info,
    nonsemantic_debug_printf,
    amd_trinary_minmax,
    amd_explicit_vertex_parameter,
    amd_gcn_shader,
    amd_shader_ballot,
    nonsemantic_clspv_reflection,
    nonsemantic_graph_debug_info,
    nonsemantic_vksp_reflection,
    nonsemantic_debug_break,
    arm_motion_engine_100,
    arm_experimental_ml_operations,
    tosa_001000_1,
};

pub const ExtInstSetInfo = struct {
    name: []const u8,
    set: ExtInstSet,
    prefix: bool = false,
};

pub const ext_inst_sets = [_]ExtInstSetInfo{
    .{ .name = "GLSL.std.450", .set = .glsl_std_450, .prefix = false },
    .{ .name = "OpenCL.std", .set = .opencl_std, .prefix = false },
    .{ .name = "OpenCL.DebugInfo.100", .set = .opencl_debug_info_100, .prefix = false },
    .{ .name = "NonSemantic.Shader.DebugInfo.100", .set = .nonsemantic_shader_debug_info_100, .prefix = false },
    .{ .name = "NonSemantic.Shader.DebugInfo.", .set = .nonsemantic_shader_debug_info, .prefix = true },
    .{ .name = "DebugInfo", .set = .debug_info, .prefix = false },
    .{ .name = "NonSemantic.DebugPrintf", .set = .nonsemantic_debug_printf, .prefix = false },
    .{ .name = "SPV_AMD_shader_trinary_minmax", .set = .amd_trinary_minmax, .prefix = false },
    .{ .name = "SPV_AMD_shader_explicit_vertex_parameter", .set = .amd_explicit_vertex_parameter, .prefix = false },
    .{ .name = "SPV_AMD_gcn_shader", .set = .amd_gcn_shader, .prefix = false },
    .{ .name = "SPV_AMD_shader_ballot", .set = .amd_shader_ballot, .prefix = false },
    .{ .name = "NonSemantic.ClspvReflection.", .set = .nonsemantic_clspv_reflection, .prefix = true },
    .{ .name = "NonSemantic.Graph.DebugInfo.", .set = .nonsemantic_graph_debug_info, .prefix = true },
    .{ .name = "NonSemantic.VkspReflection.", .set = .nonsemantic_vksp_reflection, .prefix = true },
    .{ .name = "NonSemantic.DebugBreak", .set = .nonsemantic_debug_break, .prefix = false },
    .{ .name = "Arm.MotionEngine.100", .set = .arm_motion_engine_100, .prefix = false },
    .{ .name = "Arm.ExperimentalMLOperations.", .set = .arm_experimental_ml_operations, .prefix = true },
    .{ .name = "TOSA.001000.1", .set = .tosa_001000_1, .prefix = false },
};

const operands_op_nop = [_]OperandInfo{};
const operands_op_undef = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_source_continued = [_]OperandInfo{
    .{ .kind = .literal_string, .quantifier = .one },
};
const operands_op_source = [_]OperandInfo{
    .{ .kind = .source_language, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .literal_string, .quantifier = .optional },
};
const operands_op_source_extension = [_]OperandInfo{
    .{ .kind = .literal_string, .quantifier = .one },
};
const operands_op_name = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_string, .quantifier = .one },
};
const operands_op_member_name = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_string, .quantifier = .one },
};
const operands_op_string = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_string, .quantifier = .one },
};
const operands_op_line = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_extension = [_]OperandInfo{
    .{ .kind = .literal_string, .quantifier = .one },
};
const operands_op_ext_inst_import = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_string, .quantifier = .one },
};
const operands_op_ext_inst = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_ext_inst_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_memory_model = [_]OperandInfo{
    .{ .kind = .addressing_model, .quantifier = .one },
    .{ .kind = .memory_model, .quantifier = .one },
};
const operands_op_entry_point = [_]OperandInfo{
    .{ .kind = .execution_model, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_string, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_execution_mode = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .execution_mode, .quantifier = .one },
};
const operands_op_capability = [_]OperandInfo{
    .{ .kind = .capability, .quantifier = .one },
};
const operands_op_type_void = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_bool = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_int = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_type_float = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .fp_encoding, .quantifier = .optional },
};
const operands_op_type_vector = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_type_matrix = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_type_image = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .dim, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .image_format, .quantifier = .one },
    .{ .kind = .access_qualifier, .quantifier = .optional },
};
const operands_op_type_sampler = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_sampled_image = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_array = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_runtime_array = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_struct = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_type_opaque = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_string, .quantifier = .one },
};
const operands_op_type_pointer = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .storage_class, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_function = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_type_event = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_device_event = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_reserve_id = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_queue = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_pipe = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .access_qualifier, .quantifier = .one },
};
const operands_op_type_forward_pointer = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .storage_class, .quantifier = .one },
};
const operands_op_constant_true = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_constant_false = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_constant = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_context_dependent_number, .quantifier = .one },
};
const operands_op_constant_composite = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_constant_sampler = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .sampler_addressing_mode, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .sampler_filter_mode, .quantifier = .one },
};
const operands_op_constant_null = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_spec_constant_true = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_spec_constant_false = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_spec_constant = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_context_dependent_number, .quantifier = .one },
};
const operands_op_spec_constant_composite = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_spec_constant_op = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_spec_constant_op_integer, .quantifier = .one },
};
const operands_op_function = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .function_control, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_function_parameter = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_function_end = [_]OperandInfo{};
const operands_op_function_call = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_variable = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .storage_class, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_image_texel_pointer = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_load = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .memory_access, .quantifier = .optional },
};
const operands_op_store = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .memory_access, .quantifier = .optional },
};
const operands_op_copy_memory = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .memory_access, .quantifier = .optional },
    .{ .kind = .memory_access, .quantifier = .optional },
};
const operands_op_copy_memory_sized = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .memory_access, .quantifier = .optional },
    .{ .kind = .memory_access, .quantifier = .optional },
};
const operands_op_access_chain = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_in_bounds_access_chain = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_ptr_access_chain = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_array_length = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_generic_ptr_mem_semantics = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_in_bounds_ptr_access_chain = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_decorate = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .decoration, .quantifier = .one },
};
const operands_op_member_decorate = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .decoration, .quantifier = .one },
};
const operands_op_decoration_group = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_group_decorate = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_group_member_decorate = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .pair_id_ref_literal_integer, .quantifier = .variable },
};
const operands_op_vector_extract_dynamic = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_vector_insert_dynamic = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_vector_shuffle = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .variable },
};
const operands_op_composite_construct = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_composite_extract = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .variable },
};
const operands_op_composite_insert = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .variable },
};
const operands_op_copy_object = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_transpose = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_sampled_image = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_sample_implicit_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_image_sample_explicit_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .one },
};
const operands_op_image_sample_dref_implicit_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_image_sample_dref_explicit_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .one },
};
const operands_op_image_sample_proj_implicit_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_image_sample_proj_explicit_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .one },
};
const operands_op_image_sample_proj_dref_implicit_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_image_sample_proj_dref_explicit_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .one },
};
const operands_op_image_fetch = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_image_gather = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_image_dref_gather = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_image_read = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_image_write = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_image = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_query_format = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_query_order = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_query_size_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_query_size = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_query_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_query_levels = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_query_samples = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_f_to_u = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_f_to_s = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_s_to_f = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_u_to_f = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_u_convert = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_s_convert = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_convert = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_quantize_to_f16 = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_ptr_to_u = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_sat_convert_s_to_u = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_sat_convert_u_to_s = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_u_to_ptr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ptr_cast_to_generic = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_generic_cast_to_ptr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_generic_cast_to_ptr_explicit = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .storage_class, .quantifier = .one },
};
const operands_op_bitcast = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_s_negate = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_negate = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_i_add = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_add = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_i_sub = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_sub = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_i_mul = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_mul = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_u_div = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_s_div = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_div = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_u_mod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_s_rem = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_s_mod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_rem = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_mod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_vector_times_scalar = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_matrix_times_scalar = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_vector_times_matrix = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_matrix_times_vector = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_matrix_times_matrix = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_outer_product = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_dot = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_i_add_carry = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_i_sub_borrow = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_u_mul_extended = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_s_mul_extended = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_any = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_all = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_is_nan = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_is_inf = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_is_finite = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_is_normal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_sign_bit_set = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_less_or_greater = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ordered = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_unordered = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_logical_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_logical_not_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_logical_or = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_logical_and = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_logical_not = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_select = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_i_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_i_not_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_u_greater_than = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_s_greater_than = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_u_greater_than_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_s_greater_than_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_u_less_than = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_s_less_than = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_u_less_than_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_s_less_than_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_ord_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_unord_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_ord_not_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_unord_not_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_ord_less_than = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_unord_less_than = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_ord_greater_than = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_unord_greater_than = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_ord_less_than_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_unord_less_than_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_ord_greater_than_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_unord_greater_than_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_shift_right_logical = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_shift_right_arithmetic = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_shift_left_logical = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_bitwise_or = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_bitwise_xor = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_bitwise_and = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_not = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_bit_field_insert = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_bit_field_s_extract = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_bit_field_u_extract = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_bit_reverse = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_bit_count = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_d_pdx = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_d_pdy = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_fwidth = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_d_pdx_fine = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_d_pdy_fine = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_fwidth_fine = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_d_pdx_coarse = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_d_pdy_coarse = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_fwidth_coarse = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_emit_vertex = [_]OperandInfo{};
const operands_op_end_primitive = [_]OperandInfo{};
const operands_op_emit_stream_vertex = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_end_stream_primitive = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_control_barrier = [_]OperandInfo{
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
};
const operands_op_memory_barrier = [_]OperandInfo{
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
};
const operands_op_atomic_load = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
};
const operands_op_atomic_store = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_atomic_exchange = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_atomic_compare_exchange = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_atomic_compare_exchange_weak = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_atomic_i_increment = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
};
const operands_op_atomic_i_decrement = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
};
const operands_op_atomic_i_add = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_atomic_i_sub = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_atomic_s_min = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_atomic_u_min = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_atomic_s_max = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_atomic_u_max = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_atomic_and = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_atomic_or = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_atomic_xor = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_phi = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .pair_id_ref_id_ref, .quantifier = .variable },
};
const operands_op_loop_merge = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .loop_control, .quantifier = .one },
};
const operands_op_selection_merge = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .selection_control, .quantifier = .one },
};
const operands_op_label = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_branch = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_branch_conditional = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .variable },
};
const operands_op_switch = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .pair_literal_integer_id_ref, .quantifier = .variable },
};
const operands_op_kill = [_]OperandInfo{};
const operands_op_return = [_]OperandInfo{};
const operands_op_return_value = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_unreachable = [_]OperandInfo{};
const operands_op_lifetime_start = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_lifetime_stop = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_group_async_copy = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_wait_events = [_]OperandInfo{
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_all = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_any = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_broadcast = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_i_add = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_f_add = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_f_min = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_u_min = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_s_min = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_f_max = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_u_max = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_s_max = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_read_pipe = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_write_pipe = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_reserved_read_pipe = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_reserved_write_pipe = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_reserve_read_pipe_packets = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_reserve_write_pipe_packets = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_commit_read_pipe = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_commit_write_pipe = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_is_valid_reserve_id = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_get_num_pipe_packets = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_get_max_pipe_packets = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_reserve_read_pipe_packets = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_reserve_write_pipe_packets = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_commit_read_pipe = [_]OperandInfo{
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_commit_write_pipe = [_]OperandInfo{
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_enqueue_marker = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_enqueue_kernel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_get_kernel_n_drange_sub_group_count = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_get_kernel_n_drange_max_sub_group_size = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_get_kernel_work_group_size = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_get_kernel_preferred_work_group_size_multiple = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_retain_event = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_release_event = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_create_user_event = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_is_valid_event = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_set_user_event_status = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_capture_event_profiling_info = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_get_default_queue = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_build_nd_range = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_sparse_sample_implicit_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_image_sparse_sample_explicit_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .one },
};
const operands_op_image_sparse_sample_dref_implicit_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_image_sparse_sample_dref_explicit_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .one },
};
const operands_op_image_sparse_sample_proj_implicit_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_image_sparse_sample_proj_explicit_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .one },
};
const operands_op_image_sparse_sample_proj_dref_implicit_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_image_sparse_sample_proj_dref_explicit_lod = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .one },
};
const operands_op_image_sparse_fetch = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_image_sparse_gather = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_image_sparse_dref_gather = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_image_sparse_texels_resident = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_no_line = [_]OperandInfo{};
const operands_op_atomic_flag_test_and_set = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
};
const operands_op_atomic_flag_clear = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
};
const operands_op_image_sparse_read = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_size_of = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_pipe_storage = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_constant_pipe_storage = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_create_pipe_from_pipe_storage = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_get_kernel_local_size_for_subgroup_count = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_get_kernel_max_num_subgroups = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_named_barrier = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_named_barrier_initialize = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_memory_named_barrier = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
};
const operands_op_module_processed = [_]OperandInfo{
    .{ .kind = .literal_string, .quantifier = .one },
};
const operands_op_execution_mode_id = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .execution_mode, .quantifier = .one },
};
const operands_op_decorate_id = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .decoration, .quantifier = .one },
};
const operands_op_group_non_uniform_elect = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
};
const operands_op_group_non_uniform_all = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_any = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_all_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_broadcast = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_broadcast_first = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_ballot = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_inverse_ballot = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_ballot_bit_extract = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_ballot_bit_count = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_ballot_find_lsb = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_ballot_find_msb = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_shuffle = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_shuffle_xor = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_shuffle_up = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_shuffle_down = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_i_add = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_group_non_uniform_f_add = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_group_non_uniform_i_mul = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_group_non_uniform_f_mul = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_group_non_uniform_s_min = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_group_non_uniform_u_min = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_group_non_uniform_f_min = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_group_non_uniform_s_max = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_group_non_uniform_u_max = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_group_non_uniform_f_max = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_group_non_uniform_bitwise_and = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_group_non_uniform_bitwise_or = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_group_non_uniform_bitwise_xor = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_group_non_uniform_logical_and = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_group_non_uniform_logical_or = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_group_non_uniform_logical_xor = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_group_non_uniform_quad_broadcast = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_quad_swap = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_copy_logical = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ptr_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ptr_not_equal = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ptr_diff = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_color_attachment_read_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_depth_attachment_read_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_stencil_attachment_read_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_type_tensor_arm = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_tensor_read_arm = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .tensor_operands, .quantifier = .optional },
};
const operands_op_tensor_write_arm = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .tensor_operands, .quantifier = .optional },
};
const operands_op_tensor_query_size_arm = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_graph_constant_arm = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_graph_entry_point_arm = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_string, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_graph_arm = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_graph_input_arm = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_graph_set_output_arm = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_graph_end_arm = [_]OperandInfo{};
const operands_op_type_graph_arm = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_bitcast_extract_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_terminate_invocation = [_]OperandInfo{};
const operands_op_type_untyped_pointer_khr = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .storage_class, .quantifier = .one },
};
const operands_op_untyped_variable_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .storage_class, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_untyped_access_chain_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_untyped_in_bounds_access_chain_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_subgroup_ballot_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_first_invocation_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_untyped_ptr_access_chain_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_untyped_in_bounds_ptr_access_chain_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_untyped_array_length_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_untyped_prefetch_khr = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_fma_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_all_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_any_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_all_equal_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_rotate_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_subgroup_read_invocation_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ext_inst_with_forward_refs_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_ext_inst_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_untyped_group_async_copy_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .memory_access, .quantifier = .optional },
    .{ .kind = .memory_access, .quantifier = .optional },
};
const operands_op_trace_ray_khr = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_execute_callable_khr = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_u_to_acceleration_structure_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ignore_intersection_khr = [_]OperandInfo{};
const operands_op_terminate_ray_khr = [_]OperandInfo{};
const operands_op_s_dot = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .packed_vector_format, .quantifier = .optional },
};
const operands_op_u_dot = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .packed_vector_format, .quantifier = .optional },
};
const operands_op_su_dot = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .packed_vector_format, .quantifier = .optional },
};
const operands_op_s_dot_acc_sat = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .packed_vector_format, .quantifier = .optional },
};
const operands_op_u_dot_acc_sat = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .packed_vector_format, .quantifier = .optional },
};
const operands_op_su_dot_acc_sat = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .packed_vector_format, .quantifier = .optional },
};
const operands_op_type_cooperative_matrix_khr = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_cooperative_matrix_load_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .memory_access, .quantifier = .optional },
};
const operands_op_cooperative_matrix_store_khr = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .memory_access, .quantifier = .optional },
};
const operands_op_cooperative_matrix_mul_add_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .cooperative_matrix_operands, .quantifier = .optional },
};
const operands_op_cooperative_matrix_length_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_constant_composite_replicate_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_spec_constant_composite_replicate_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_composite_construct_replicate_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_ray_query_khr = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_ray_query_initialize_khr = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_terminate_khr = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_generate_intersection_khr = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_confirm_intersection_khr = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_proceed_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_type_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_sample_weighted_qcom = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_box_filter_qcom = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_block_match_ssdqcom = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_block_match_sadqcom = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_bit_cast_array_qcom = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_block_match_window_ssdqcom = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_block_match_window_sadqcom = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_block_match_gather_ssdqcom = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_block_match_gather_sadqcom = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_b_float16_mul_add_qcom = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_composite_construct_coop_mat_qcom = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_composite_extract_coop_mat_qcom = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_extract_sub_array_qcom = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_image_gather_qcom = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_group_i_add_non_uniform_amd = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_f_add_non_uniform_amd = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_f_min_non_uniform_amd = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_u_min_non_uniform_amd = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_s_min_non_uniform_amd = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_f_max_non_uniform_amd = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_u_max_non_uniform_amd = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_s_max_non_uniform_amd = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_fragment_mask_fetch_amd = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_fragment_fetch_amd = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_read_clock_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
};
const operands_op_allocate_node_payloads_amdx = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_enqueue_node_payloads_amdx = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_node_payload_array_amdx = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_finish_writing_node_payload_amdx = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_node_payload_array_length_amdx = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_is_node_payload_valid_amdx = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_constant_string_amdx = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_string, .quantifier = .one },
};
const operands_op_spec_constant_string_amdx = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_string, .quantifier = .one },
};
const operands_op_group_non_uniform_quad_all_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_quad_any_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_buffer_ext = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .storage_class, .quantifier = .one },
};
const operands_op_buffer_pointer_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_abort_khr = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_untyped_image_texel_pointer_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_member_decorate_id_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .decoration, .quantifier = .one },
};
const operands_op_constant_size_of_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_constant_data_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .variable },
};
const operands_op_spec_constant_data_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .variable },
};
const operands_op_poison_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_freeze_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_record_hit_motion_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_record_hit_with_index_motion_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_record_miss_motion_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_world_to_object_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_object_to_world_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_object_ray_direction_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_object_ray_origin_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_trace_ray_motion_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_shader_record_buffer_handle_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_shader_binding_table_record_index_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_record_empty_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_trace_ray_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_record_hit_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_record_hit_with_index_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_record_miss_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_execute_shader_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_current_time_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_attributes_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_hit_kind_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_primitive_index_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_geometry_index_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_instance_id_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_instance_custom_index_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_world_ray_direction_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_world_ray_origin_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_ray_t_max_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_ray_t_min_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_is_empty_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_is_hit_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_is_miss_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_reorder_thread_with_hit_object_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_reorder_thread_with_hint_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_hit_object_nv = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_image_sample_footprint_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .image_operands, .quantifier = .optional },
};
const operands_op_type_vector_id_ext = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_cooperative_vector_matrix_mul_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .cooperative_matrix_operands, .quantifier = .optional },
};
const operands_op_cooperative_vector_outer_product_accumulate_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_cooperative_vector_reduce_sum_accumulate_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_cooperative_vector_matrix_mul_add_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .cooperative_matrix_operands, .quantifier = .optional },
};
const operands_op_cooperative_matrix_convert_use_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_emit_mesh_tasks_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_set_mesh_outputs_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_non_uniform_partition_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_write_packed_primitive_indices4x8_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_fetch_micro_triangle_vertex_position_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_fetch_micro_triangle_vertex_barycentric_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_cooperative_vector_load_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .memory_access, .quantifier = .optional },
};
const operands_op_cooperative_vector_store_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .memory_access, .quantifier = .optional },
};
const operands_op_hit_object_record_from_query_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_hit_object_record_miss_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_record_miss_motion_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_intersection_triangle_vertex_positions_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_ray_flags_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_set_shader_binding_table_record_index_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_reorder_execute_shader_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_hit_object_trace_reorder_execute_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_hit_object_trace_motion_reorder_execute_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_type_hit_object_ext = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_reorder_thread_with_hint_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_reorder_thread_with_hit_object_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_hit_object_trace_ray_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_trace_ray_motion_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_record_empty_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_execute_shader_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_current_time_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_attributes_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_hit_kind_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_primitive_index_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_geometry_index_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_instance_id_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_instance_custom_index_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_object_ray_origin_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_object_ray_direction_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_world_ray_direction_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_world_ray_origin_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_object_to_world_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_world_to_object_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_ray_t_max_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_report_intersection_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ignore_intersection_nv = [_]OperandInfo{};
const operands_op_terminate_ray_nv = [_]OperandInfo{};
const operands_op_trace_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_trace_motion_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_trace_ray_motion_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_triangle_vertex_positions_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_acceleration_structure_khr = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_execute_callable_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_cluster_id_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_cluster_id_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_ray_t_min_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_shader_binding_table_record_index_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_shader_record_buffer_handle_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_is_empty_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_is_hit_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_is_miss_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_cooperative_matrix_nv = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_cooperative_matrix_load_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .memory_access, .quantifier = .optional },
};
const operands_op_cooperative_matrix_store_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .memory_access, .quantifier = .optional },
};
const operands_op_cooperative_matrix_mul_add_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_cooperative_matrix_length_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_cooperative_matrix_get_coordinate_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_begin_invocation_interlock_ext = [_]OperandInfo{};
const operands_op_end_invocation_interlock_ext = [_]OperandInfo{};
const operands_op_cooperative_matrix_reduce_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .cooperative_matrix_reduce, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_cooperative_matrix_load_tensor_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .memory_access, .quantifier = .one },
    .{ .kind = .tensor_addressing_operands, .quantifier = .one },
};
const operands_op_cooperative_matrix_store_tensor_nv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .memory_access, .quantifier = .one },
    .{ .kind = .tensor_addressing_operands, .quantifier = .one },
};
const operands_op_cooperative_matrix_per_element_op_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_type_tensor_layout_nv = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_tensor_view_nv = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_create_tensor_layout_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_tensor_layout_set_dimension_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_tensor_layout_set_stride_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_tensor_layout_slice_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_tensor_layout_set_clamp_value_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_create_tensor_view_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_tensor_view_set_dimension_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_tensor_view_set_stride_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_demote_to_helper_invocation = [_]OperandInfo{};
const operands_op_is_helper_invocation_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_tensor_view_set_clip_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_tensor_layout_set_block_size_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_cooperative_matrix_transpose_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_u_to_image_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_u_to_sampler_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_image_to_unv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_sampler_to_unv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_u_to_sampled_image_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_sampled_image_to_unv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_sampler_image_addressing_mode_nv = [_]OperandInfo{
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_raw_access_chain_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .raw_access_chain_operands, .quantifier = .optional },
};
const operands_op_ray_query_get_intersection_sphere_position_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_sphere_radius_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_lss_positions_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_lss_radii_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_lss_hit_value_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_sphere_position_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_sphere_radius_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_lss_positions_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_get_lss_radii_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_is_sphere_hit_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_hit_object_is_lss_hit_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_is_sphere_hit_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_is_lss_hit_nv = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_shuffle_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_shuffle_down_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_shuffle_up_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_shuffle_xor_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_block_read_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_block_write_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_image_block_read_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_image_block_write_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_image_media_block_read_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_image_media_block_write_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_u_count_leading_zeros_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_u_count_trailing_zeros_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_abs_i_sub_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_abs_u_sub_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_i_add_sat_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_u_add_sat_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_i_average_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_u_average_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_i_average_rounded_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_u_average_rounded_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_i_sub_sat_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_u_sub_sat_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_i_mul32x16_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_u_mul32x16_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_constant_function_pointer_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_function_pointer_call_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_asm_target_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_string, .quantifier = .one },
};
const operands_op_asm_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_string, .quantifier = .one },
    .{ .kind = .literal_string, .quantifier = .one },
};
const operands_op_asm_call_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_atomic_f_min_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_atomic_f_max_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_assume_true_khr = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_expect_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_decorate_string = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .decoration, .quantifier = .one },
};
const operands_op_member_decorate_string = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .decoration, .quantifier = .one },
};
const operands_op_vme_image_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_vme_image_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_avc_ime_payload_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_avc_ref_payload_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_avc_sic_payload_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_avc_mce_payload_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_avc_mce_result_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_avc_ime_result_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_avc_ime_result_single_reference_streamout_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_avc_ime_result_dual_reference_streamout_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_avc_ime_single_reference_streamin_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_avc_ime_dual_reference_streamin_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_avc_ref_result_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_type_avc_sic_result_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_default_inter_base_multi_reference_penalty_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_set_inter_base_multi_reference_penalty_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_default_inter_shape_penalty_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_set_inter_shape_penalty_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_default_inter_direction_penalty_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_set_inter_direction_penalty_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_default_intra_luma_shape_penalty_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_default_inter_motion_vector_cost_table_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_default_high_penalty_cost_table_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_default_medium_penalty_cost_table_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_default_low_penalty_cost_table_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_set_motion_vector_cost_function_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_default_intra_luma_mode_penalty_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_default_non_dc_luma_intra_penalty_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_default_intra_chroma_mode_base_penalty_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_set_ac_only_haar_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_set_source_interlaced_field_polarity_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_set_single_reference_interlaced_field_polarity_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_set_dual_reference_interlaced_field_polarities_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_convert_to_ime_payload_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_convert_to_ime_result_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_convert_to_ref_payload_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_convert_to_ref_result_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_convert_to_sic_payload_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_convert_to_sic_result_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_motion_vectors_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_inter_distortions_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_best_inter_distortions_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_inter_major_shape_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_inter_minor_shape_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_inter_directions_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_inter_motion_vector_count_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_inter_reference_ids_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_mce_get_inter_reference_interlaced_field_polarities_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_initialize_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_set_single_reference_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_set_dual_reference_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_ref_window_size_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_adjust_ref_offset_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_convert_to_mce_payload_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_set_max_motion_vector_count_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_set_unidirectional_mix_disable_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_set_early_search_termination_threshold_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_set_weighted_sad_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_evaluate_with_single_reference_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_evaluate_with_dual_reference_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_evaluate_with_single_reference_streamin_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_evaluate_with_dual_reference_streamin_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_evaluate_with_single_reference_streamout_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_evaluate_with_dual_reference_streamout_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_evaluate_with_single_reference_streaminout_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_evaluate_with_dual_reference_streaminout_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_convert_to_mce_result_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_get_single_reference_streamin_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_get_dual_reference_streamin_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_strip_single_reference_streamout_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_strip_dual_reference_streamout_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_get_streamout_single_reference_major_shape_motion_vectors_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_get_streamout_single_reference_major_shape_distortions_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_get_streamout_single_reference_major_shape_reference_ids_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_get_streamout_dual_reference_major_shape_motion_vectors_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_get_streamout_dual_reference_major_shape_distortions_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_get_streamout_dual_reference_major_shape_reference_ids_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_get_border_reached_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_get_truncated_search_indication_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_get_unidirectional_early_search_termination_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_get_weighting_pattern_minimum_motion_vector_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ime_get_weighting_pattern_minimum_distortion_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_fme_initialize_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_bme_initialize_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ref_convert_to_mce_payload_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ref_set_bidirectional_mix_disable_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ref_set_bilinear_filter_enable_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ref_evaluate_with_single_reference_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ref_evaluate_with_dual_reference_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ref_evaluate_with_multi_reference_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ref_evaluate_with_multi_reference_interlaced_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_ref_convert_to_mce_result_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_initialize_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_configure_skc_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_configure_ipe_luma_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_configure_ipe_luma_chroma_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_get_motion_vector_mask_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_convert_to_mce_payload_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_set_intra_luma_shape_penalty_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_set_intra_luma_mode_cost_function_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_set_intra_chroma_mode_cost_function_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_set_bilinear_filter_enable_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_set_skc_forward_transform_enable_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_set_block_based_raw_skip_sad_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_evaluate_ipe_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_evaluate_with_single_reference_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_evaluate_with_dual_reference_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_evaluate_with_multi_reference_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_evaluate_with_multi_reference_interlaced_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_convert_to_mce_result_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_get_ipe_luma_shape_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_get_best_ipe_luma_distortion_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_get_best_ipe_chroma_distortion_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_get_packed_ipe_luma_modes_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_get_ipe_chroma_mode_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_get_packed_skc_luma_count_threshold_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_get_packed_skc_luma_sum_threshold_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_avc_sic_get_inter_raw_sads_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_variable_length_array_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_save_memory_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_restore_memory_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_arbitrary_float_sin_cos_pi_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_cast_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_cast_from_int_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_cast_to_int_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_add_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_sub_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_mul_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_div_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_gtaltera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_gealtera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_ltaltera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_lealtera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_eqaltera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_recip_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_r_sqrt_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_cbrt_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_hypot_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_sqrt_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_log_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_log2_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_log10_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_log1p_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_exp_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_exp2_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_exp10_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_expm1_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_sin_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_cos_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_sin_cos_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_sin_pi_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_cos_pi_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_a_sin_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_a_sin_pi_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_a_cos_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_a_cos_pi_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_a_tan_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_a_tan_pi_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_a_tan2_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_pow_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_pow_rintel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_arbitrary_float_pow_nintel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_loop_control_intel = [_]OperandInfo{
    .{ .kind = .literal_integer, .quantifier = .variable },
};
const operands_op_alias_domain_decl_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_alias_scope_decl_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const operands_op_alias_scope_list_decl_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_fixed_sqrt_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_fixed_recip_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_fixed_rsqrt_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_fixed_sin_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_fixed_cos_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_fixed_sin_cos_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_fixed_sin_pi_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_fixed_cos_pi_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_fixed_sin_cos_pi_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_fixed_log_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_fixed_exp_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_ptr_cast_to_cross_workgroup_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_cross_workgroup_cast_to_ptr_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_read_pipe_blocking_altera = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_write_pipe_blocking_altera = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_fpga_reg_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_ray_t_min_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_ray_flags_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_tkhr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_instance_custom_index_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_instance_id_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_instance_shader_binding_table_record_offset_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_geometry_index_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_primitive_index_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_barycentrics_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_front_face_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_candidate_aabb_opaque_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_object_ray_direction_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_object_ray_origin_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_world_ray_direction_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_world_ray_origin_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_object_to_world_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_ray_query_get_intersection_world_to_object_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_atomic_f_add_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_buffer_surface_intel = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .access_qualifier, .quantifier = .one },
};
const operands_op_type_struct_continued_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_constant_composite_continued_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_spec_constant_composite_continued_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_composite_construct_continued_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_convert_f_to_bf16_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_bf16_to_fintel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_control_barrier_arrive_ext = [_]OperandInfo{
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
};
const operands_op_control_barrier_wait_ext = [_]OperandInfo{
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .id_memory_semantics, .quantifier = .one },
};
const operands_op_arithmetic_fence_ext = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_task_sequence_create_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_task_sequence_async_altera = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_task_sequence_get_altera = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_task_sequence_release_altera = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_type_task_sequence_altera = [_]OperandInfo{
    .{ .kind = .id_result, .quantifier = .one },
};
const operands_op_subgroup_block_prefetch_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .memory_access, .quantifier = .optional },
};
const operands_op_subgroup2_d_block_load_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup2_d_block_load_transform_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup2_d_block_load_transpose_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup2_d_block_prefetch_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup2_d_block_store_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_subgroup_matrix_multiply_accumulate_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .matrix_multiply_accumulate_operands, .quantifier = .optional },
};
const operands_op_bitwise_function_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_untyped_variable_length_array_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_conditional_extension_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_string, .quantifier = .one },
};
const operands_op_conditional_entry_point_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .execution_model, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_string, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_conditional_capability_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .capability, .quantifier = .one },
};
const operands_op_spec_constant_target_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .variable },
};
const operands_op_spec_constant_architecture_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const operands_op_spec_constant_capabilities_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .capability, .quantifier = .variable },
};
const operands_op_conditional_copy_object_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const operands_op_predicated_load_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .memory_access, .quantifier = .optional },
};
const operands_op_predicated_store_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .memory_access, .quantifier = .optional },
};
const operands_op_group_i_mul_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_f_mul_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_bitwise_and_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_bitwise_or_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_bitwise_xor_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_logical_and_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_logical_or_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_group_logical_xor_khr = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_scope, .quantifier = .one },
    .{ .kind = .group_operation, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_round_f_to_tf32_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_masked_gather_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_masked_scatter_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_handle_to_image_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_handle_to_sampler_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_convert_handle_to_sampled_image_intel = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_dot2_mix_acc32_valve = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_dot2_mix_acc16_valve = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const operands_op_f_dot4_mix_acc32_valve = [_]OperandInfo{
    .{ .kind = .id_result_type, .quantifier = .one },
    .{ .kind = .id_result, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};

pub const opcodes = [_]OpcodeInfo{
    .{ .name = "OpNop", .opcode = 0, .operands = &operands_op_nop },
    .{ .name = "OpUndef", .opcode = 1, .operands = &operands_op_undef },
    .{ .name = "OpSourceContinued", .opcode = 2, .operands = &operands_op_source_continued },
    .{ .name = "OpSource", .opcode = 3, .operands = &operands_op_source },
    .{ .name = "OpSourceExtension", .opcode = 4, .operands = &operands_op_source_extension },
    .{ .name = "OpName", .opcode = 5, .operands = &operands_op_name },
    .{ .name = "OpMemberName", .opcode = 6, .operands = &operands_op_member_name },
    .{ .name = "OpString", .opcode = 7, .operands = &operands_op_string },
    .{ .name = "OpLine", .opcode = 8, .operands = &operands_op_line },
    .{ .name = "OpExtension", .opcode = 10, .operands = &operands_op_extension },
    .{ .name = "OpExtInstImport", .opcode = 11, .operands = &operands_op_ext_inst_import },
    .{ .name = "OpExtInst", .opcode = 12, .operands = &operands_op_ext_inst },
    .{ .name = "OpMemoryModel", .opcode = 14, .operands = &operands_op_memory_model },
    .{ .name = "OpEntryPoint", .opcode = 15, .operands = &operands_op_entry_point },
    .{ .name = "OpExecutionMode", .opcode = 16, .operands = &operands_op_execution_mode },
    .{ .name = "OpCapability", .opcode = 17, .operands = &operands_op_capability },
    .{ .name = "OpTypeVoid", .opcode = 19, .operands = &operands_op_type_void },
    .{ .name = "OpTypeBool", .opcode = 20, .operands = &operands_op_type_bool },
    .{ .name = "OpTypeInt", .opcode = 21, .operands = &operands_op_type_int },
    .{ .name = "OpTypeFloat", .opcode = 22, .operands = &operands_op_type_float },
    .{ .name = "OpTypeVector", .opcode = 23, .operands = &operands_op_type_vector },
    .{ .name = "OpTypeMatrix", .opcode = 24, .operands = &operands_op_type_matrix },
    .{ .name = "OpTypeImage", .opcode = 25, .operands = &operands_op_type_image },
    .{ .name = "OpTypeSampler", .opcode = 26, .operands = &operands_op_type_sampler },
    .{ .name = "OpTypeSampledImage", .opcode = 27, .operands = &operands_op_type_sampled_image },
    .{ .name = "OpTypeArray", .opcode = 28, .operands = &operands_op_type_array },
    .{ .name = "OpTypeRuntimeArray", .opcode = 29, .operands = &operands_op_type_runtime_array },
    .{ .name = "OpTypeStruct", .opcode = 30, .operands = &operands_op_type_struct },
    .{ .name = "OpTypeOpaque", .opcode = 31, .operands = &operands_op_type_opaque },
    .{ .name = "OpTypePointer", .opcode = 32, .operands = &operands_op_type_pointer },
    .{ .name = "OpTypeFunction", .opcode = 33, .operands = &operands_op_type_function },
    .{ .name = "OpTypeEvent", .opcode = 34, .operands = &operands_op_type_event },
    .{ .name = "OpTypeDeviceEvent", .opcode = 35, .operands = &operands_op_type_device_event },
    .{ .name = "OpTypeReserveId", .opcode = 36, .operands = &operands_op_type_reserve_id },
    .{ .name = "OpTypeQueue", .opcode = 37, .operands = &operands_op_type_queue },
    .{ .name = "OpTypePipe", .opcode = 38, .operands = &operands_op_type_pipe },
    .{ .name = "OpTypeForwardPointer", .opcode = 39, .operands = &operands_op_type_forward_pointer },
    .{ .name = "OpConstantTrue", .opcode = 41, .operands = &operands_op_constant_true },
    .{ .name = "OpConstantFalse", .opcode = 42, .operands = &operands_op_constant_false },
    .{ .name = "OpConstant", .opcode = 43, .operands = &operands_op_constant },
    .{ .name = "OpConstantComposite", .opcode = 44, .operands = &operands_op_constant_composite },
    .{ .name = "OpConstantSampler", .opcode = 45, .operands = &operands_op_constant_sampler },
    .{ .name = "OpConstantNull", .opcode = 46, .operands = &operands_op_constant_null },
    .{ .name = "OpSpecConstantTrue", .opcode = 48, .operands = &operands_op_spec_constant_true },
    .{ .name = "OpSpecConstantFalse", .opcode = 49, .operands = &operands_op_spec_constant_false },
    .{ .name = "OpSpecConstant", .opcode = 50, .operands = &operands_op_spec_constant },
    .{ .name = "OpSpecConstantComposite", .opcode = 51, .operands = &operands_op_spec_constant_composite },
    .{ .name = "OpSpecConstantOp", .opcode = 52, .operands = &operands_op_spec_constant_op },
    .{ .name = "OpFunction", .opcode = 54, .operands = &operands_op_function },
    .{ .name = "OpFunctionParameter", .opcode = 55, .operands = &operands_op_function_parameter },
    .{ .name = "OpFunctionEnd", .opcode = 56, .operands = &operands_op_function_end },
    .{ .name = "OpFunctionCall", .opcode = 57, .operands = &operands_op_function_call },
    .{ .name = "OpVariable", .opcode = 59, .operands = &operands_op_variable },
    .{ .name = "OpImageTexelPointer", .opcode = 60, .operands = &operands_op_image_texel_pointer },
    .{ .name = "OpLoad", .opcode = 61, .operands = &operands_op_load },
    .{ .name = "OpStore", .opcode = 62, .operands = &operands_op_store },
    .{ .name = "OpCopyMemory", .opcode = 63, .operands = &operands_op_copy_memory },
    .{ .name = "OpCopyMemorySized", .opcode = 64, .operands = &operands_op_copy_memory_sized },
    .{ .name = "OpAccessChain", .opcode = 65, .operands = &operands_op_access_chain },
    .{ .name = "OpInBoundsAccessChain", .opcode = 66, .operands = &operands_op_in_bounds_access_chain },
    .{ .name = "OpPtrAccessChain", .opcode = 67, .operands = &operands_op_ptr_access_chain },
    .{ .name = "OpArrayLength", .opcode = 68, .operands = &operands_op_array_length },
    .{ .name = "OpGenericPtrMemSemantics", .opcode = 69, .operands = &operands_op_generic_ptr_mem_semantics },
    .{ .name = "OpInBoundsPtrAccessChain", .opcode = 70, .operands = &operands_op_in_bounds_ptr_access_chain },
    .{ .name = "OpDecorate", .opcode = 71, .operands = &operands_op_decorate },
    .{ .name = "OpMemberDecorate", .opcode = 72, .operands = &operands_op_member_decorate },
    .{ .name = "OpDecorationGroup", .opcode = 73, .operands = &operands_op_decoration_group },
    .{ .name = "OpGroupDecorate", .opcode = 74, .operands = &operands_op_group_decorate },
    .{ .name = "OpGroupMemberDecorate", .opcode = 75, .operands = &operands_op_group_member_decorate },
    .{ .name = "OpVectorExtractDynamic", .opcode = 77, .operands = &operands_op_vector_extract_dynamic },
    .{ .name = "OpVectorInsertDynamic", .opcode = 78, .operands = &operands_op_vector_insert_dynamic },
    .{ .name = "OpVectorShuffle", .opcode = 79, .operands = &operands_op_vector_shuffle },
    .{ .name = "OpCompositeConstruct", .opcode = 80, .operands = &operands_op_composite_construct },
    .{ .name = "OpCompositeExtract", .opcode = 81, .operands = &operands_op_composite_extract },
    .{ .name = "OpCompositeInsert", .opcode = 82, .operands = &operands_op_composite_insert },
    .{ .name = "OpCopyObject", .opcode = 83, .operands = &operands_op_copy_object },
    .{ .name = "OpTranspose", .opcode = 84, .operands = &operands_op_transpose },
    .{ .name = "OpSampledImage", .opcode = 86, .operands = &operands_op_sampled_image },
    .{ .name = "OpImageSampleImplicitLod", .opcode = 87, .operands = &operands_op_image_sample_implicit_lod },
    .{ .name = "OpImageSampleExplicitLod", .opcode = 88, .operands = &operands_op_image_sample_explicit_lod },
    .{ .name = "OpImageSampleDrefImplicitLod", .opcode = 89, .operands = &operands_op_image_sample_dref_implicit_lod },
    .{ .name = "OpImageSampleDrefExplicitLod", .opcode = 90, .operands = &operands_op_image_sample_dref_explicit_lod },
    .{ .name = "OpImageSampleProjImplicitLod", .opcode = 91, .operands = &operands_op_image_sample_proj_implicit_lod },
    .{ .name = "OpImageSampleProjExplicitLod", .opcode = 92, .operands = &operands_op_image_sample_proj_explicit_lod },
    .{ .name = "OpImageSampleProjDrefImplicitLod", .opcode = 93, .operands = &operands_op_image_sample_proj_dref_implicit_lod },
    .{ .name = "OpImageSampleProjDrefExplicitLod", .opcode = 94, .operands = &operands_op_image_sample_proj_dref_explicit_lod },
    .{ .name = "OpImageFetch", .opcode = 95, .operands = &operands_op_image_fetch },
    .{ .name = "OpImageGather", .opcode = 96, .operands = &operands_op_image_gather },
    .{ .name = "OpImageDrefGather", .opcode = 97, .operands = &operands_op_image_dref_gather },
    .{ .name = "OpImageRead", .opcode = 98, .operands = &operands_op_image_read },
    .{ .name = "OpImageWrite", .opcode = 99, .operands = &operands_op_image_write },
    .{ .name = "OpImage", .opcode = 100, .operands = &operands_op_image },
    .{ .name = "OpImageQueryFormat", .opcode = 101, .operands = &operands_op_image_query_format },
    .{ .name = "OpImageQueryOrder", .opcode = 102, .operands = &operands_op_image_query_order },
    .{ .name = "OpImageQuerySizeLod", .opcode = 103, .operands = &operands_op_image_query_size_lod },
    .{ .name = "OpImageQuerySize", .opcode = 104, .operands = &operands_op_image_query_size },
    .{ .name = "OpImageQueryLod", .opcode = 105, .operands = &operands_op_image_query_lod },
    .{ .name = "OpImageQueryLevels", .opcode = 106, .operands = &operands_op_image_query_levels },
    .{ .name = "OpImageQuerySamples", .opcode = 107, .operands = &operands_op_image_query_samples },
    .{ .name = "OpConvertFToU", .opcode = 109, .operands = &operands_op_convert_f_to_u },
    .{ .name = "OpConvertFToS", .opcode = 110, .operands = &operands_op_convert_f_to_s },
    .{ .name = "OpConvertSToF", .opcode = 111, .operands = &operands_op_convert_s_to_f },
    .{ .name = "OpConvertUToF", .opcode = 112, .operands = &operands_op_convert_u_to_f },
    .{ .name = "OpUConvert", .opcode = 113, .operands = &operands_op_u_convert },
    .{ .name = "OpSConvert", .opcode = 114, .operands = &operands_op_s_convert },
    .{ .name = "OpFConvert", .opcode = 115, .operands = &operands_op_f_convert },
    .{ .name = "OpQuantizeToF16", .opcode = 116, .operands = &operands_op_quantize_to_f16 },
    .{ .name = "OpConvertPtrToU", .opcode = 117, .operands = &operands_op_convert_ptr_to_u },
    .{ .name = "OpSatConvertSToU", .opcode = 118, .operands = &operands_op_sat_convert_s_to_u },
    .{ .name = "OpSatConvertUToS", .opcode = 119, .operands = &operands_op_sat_convert_u_to_s },
    .{ .name = "OpConvertUToPtr", .opcode = 120, .operands = &operands_op_convert_u_to_ptr },
    .{ .name = "OpPtrCastToGeneric", .opcode = 121, .operands = &operands_op_ptr_cast_to_generic },
    .{ .name = "OpGenericCastToPtr", .opcode = 122, .operands = &operands_op_generic_cast_to_ptr },
    .{ .name = "OpGenericCastToPtrExplicit", .opcode = 123, .operands = &operands_op_generic_cast_to_ptr_explicit },
    .{ .name = "OpBitcast", .opcode = 124, .operands = &operands_op_bitcast },
    .{ .name = "OpSNegate", .opcode = 126, .operands = &operands_op_s_negate },
    .{ .name = "OpFNegate", .opcode = 127, .operands = &operands_op_f_negate },
    .{ .name = "OpIAdd", .opcode = 128, .operands = &operands_op_i_add },
    .{ .name = "OpFAdd", .opcode = 129, .operands = &operands_op_f_add },
    .{ .name = "OpISub", .opcode = 130, .operands = &operands_op_i_sub },
    .{ .name = "OpFSub", .opcode = 131, .operands = &operands_op_f_sub },
    .{ .name = "OpIMul", .opcode = 132, .operands = &operands_op_i_mul },
    .{ .name = "OpFMul", .opcode = 133, .operands = &operands_op_f_mul },
    .{ .name = "OpUDiv", .opcode = 134, .operands = &operands_op_u_div },
    .{ .name = "OpSDiv", .opcode = 135, .operands = &operands_op_s_div },
    .{ .name = "OpFDiv", .opcode = 136, .operands = &operands_op_f_div },
    .{ .name = "OpUMod", .opcode = 137, .operands = &operands_op_u_mod },
    .{ .name = "OpSRem", .opcode = 138, .operands = &operands_op_s_rem },
    .{ .name = "OpSMod", .opcode = 139, .operands = &operands_op_s_mod },
    .{ .name = "OpFRem", .opcode = 140, .operands = &operands_op_f_rem },
    .{ .name = "OpFMod", .opcode = 141, .operands = &operands_op_f_mod },
    .{ .name = "OpVectorTimesScalar", .opcode = 142, .operands = &operands_op_vector_times_scalar },
    .{ .name = "OpMatrixTimesScalar", .opcode = 143, .operands = &operands_op_matrix_times_scalar },
    .{ .name = "OpVectorTimesMatrix", .opcode = 144, .operands = &operands_op_vector_times_matrix },
    .{ .name = "OpMatrixTimesVector", .opcode = 145, .operands = &operands_op_matrix_times_vector },
    .{ .name = "OpMatrixTimesMatrix", .opcode = 146, .operands = &operands_op_matrix_times_matrix },
    .{ .name = "OpOuterProduct", .opcode = 147, .operands = &operands_op_outer_product },
    .{ .name = "OpDot", .opcode = 148, .operands = &operands_op_dot },
    .{ .name = "OpIAddCarry", .opcode = 149, .operands = &operands_op_i_add_carry },
    .{ .name = "OpISubBorrow", .opcode = 150, .operands = &operands_op_i_sub_borrow },
    .{ .name = "OpUMulExtended", .opcode = 151, .operands = &operands_op_u_mul_extended },
    .{ .name = "OpSMulExtended", .opcode = 152, .operands = &operands_op_s_mul_extended },
    .{ .name = "OpAny", .opcode = 154, .operands = &operands_op_any },
    .{ .name = "OpAll", .opcode = 155, .operands = &operands_op_all },
    .{ .name = "OpIsNan", .opcode = 156, .operands = &operands_op_is_nan },
    .{ .name = "OpIsInf", .opcode = 157, .operands = &operands_op_is_inf },
    .{ .name = "OpIsFinite", .opcode = 158, .operands = &operands_op_is_finite },
    .{ .name = "OpIsNormal", .opcode = 159, .operands = &operands_op_is_normal },
    .{ .name = "OpSignBitSet", .opcode = 160, .operands = &operands_op_sign_bit_set },
    .{ .name = "OpLessOrGreater", .opcode = 161, .operands = &operands_op_less_or_greater },
    .{ .name = "OpOrdered", .opcode = 162, .operands = &operands_op_ordered },
    .{ .name = "OpUnordered", .opcode = 163, .operands = &operands_op_unordered },
    .{ .name = "OpLogicalEqual", .opcode = 164, .operands = &operands_op_logical_equal },
    .{ .name = "OpLogicalNotEqual", .opcode = 165, .operands = &operands_op_logical_not_equal },
    .{ .name = "OpLogicalOr", .opcode = 166, .operands = &operands_op_logical_or },
    .{ .name = "OpLogicalAnd", .opcode = 167, .operands = &operands_op_logical_and },
    .{ .name = "OpLogicalNot", .opcode = 168, .operands = &operands_op_logical_not },
    .{ .name = "OpSelect", .opcode = 169, .operands = &operands_op_select },
    .{ .name = "OpIEqual", .opcode = 170, .operands = &operands_op_i_equal },
    .{ .name = "OpINotEqual", .opcode = 171, .operands = &operands_op_i_not_equal },
    .{ .name = "OpUGreaterThan", .opcode = 172, .operands = &operands_op_u_greater_than },
    .{ .name = "OpSGreaterThan", .opcode = 173, .operands = &operands_op_s_greater_than },
    .{ .name = "OpUGreaterThanEqual", .opcode = 174, .operands = &operands_op_u_greater_than_equal },
    .{ .name = "OpSGreaterThanEqual", .opcode = 175, .operands = &operands_op_s_greater_than_equal },
    .{ .name = "OpULessThan", .opcode = 176, .operands = &operands_op_u_less_than },
    .{ .name = "OpSLessThan", .opcode = 177, .operands = &operands_op_s_less_than },
    .{ .name = "OpULessThanEqual", .opcode = 178, .operands = &operands_op_u_less_than_equal },
    .{ .name = "OpSLessThanEqual", .opcode = 179, .operands = &operands_op_s_less_than_equal },
    .{ .name = "OpFOrdEqual", .opcode = 180, .operands = &operands_op_f_ord_equal },
    .{ .name = "OpFUnordEqual", .opcode = 181, .operands = &operands_op_f_unord_equal },
    .{ .name = "OpFOrdNotEqual", .opcode = 182, .operands = &operands_op_f_ord_not_equal },
    .{ .name = "OpFUnordNotEqual", .opcode = 183, .operands = &operands_op_f_unord_not_equal },
    .{ .name = "OpFOrdLessThan", .opcode = 184, .operands = &operands_op_f_ord_less_than },
    .{ .name = "OpFUnordLessThan", .opcode = 185, .operands = &operands_op_f_unord_less_than },
    .{ .name = "OpFOrdGreaterThan", .opcode = 186, .operands = &operands_op_f_ord_greater_than },
    .{ .name = "OpFUnordGreaterThan", .opcode = 187, .operands = &operands_op_f_unord_greater_than },
    .{ .name = "OpFOrdLessThanEqual", .opcode = 188, .operands = &operands_op_f_ord_less_than_equal },
    .{ .name = "OpFUnordLessThanEqual", .opcode = 189, .operands = &operands_op_f_unord_less_than_equal },
    .{ .name = "OpFOrdGreaterThanEqual", .opcode = 190, .operands = &operands_op_f_ord_greater_than_equal },
    .{ .name = "OpFUnordGreaterThanEqual", .opcode = 191, .operands = &operands_op_f_unord_greater_than_equal },
    .{ .name = "OpShiftRightLogical", .opcode = 194, .operands = &operands_op_shift_right_logical },
    .{ .name = "OpShiftRightArithmetic", .opcode = 195, .operands = &operands_op_shift_right_arithmetic },
    .{ .name = "OpShiftLeftLogical", .opcode = 196, .operands = &operands_op_shift_left_logical },
    .{ .name = "OpBitwiseOr", .opcode = 197, .operands = &operands_op_bitwise_or },
    .{ .name = "OpBitwiseXor", .opcode = 198, .operands = &operands_op_bitwise_xor },
    .{ .name = "OpBitwiseAnd", .opcode = 199, .operands = &operands_op_bitwise_and },
    .{ .name = "OpNot", .opcode = 200, .operands = &operands_op_not },
    .{ .name = "OpBitFieldInsert", .opcode = 201, .operands = &operands_op_bit_field_insert },
    .{ .name = "OpBitFieldSExtract", .opcode = 202, .operands = &operands_op_bit_field_s_extract },
    .{ .name = "OpBitFieldUExtract", .opcode = 203, .operands = &operands_op_bit_field_u_extract },
    .{ .name = "OpBitReverse", .opcode = 204, .operands = &operands_op_bit_reverse },
    .{ .name = "OpBitCount", .opcode = 205, .operands = &operands_op_bit_count },
    .{ .name = "OpDPdx", .opcode = 207, .operands = &operands_op_d_pdx },
    .{ .name = "OpDPdy", .opcode = 208, .operands = &operands_op_d_pdy },
    .{ .name = "OpFwidth", .opcode = 209, .operands = &operands_op_fwidth },
    .{ .name = "OpDPdxFine", .opcode = 210, .operands = &operands_op_d_pdx_fine },
    .{ .name = "OpDPdyFine", .opcode = 211, .operands = &operands_op_d_pdy_fine },
    .{ .name = "OpFwidthFine", .opcode = 212, .operands = &operands_op_fwidth_fine },
    .{ .name = "OpDPdxCoarse", .opcode = 213, .operands = &operands_op_d_pdx_coarse },
    .{ .name = "OpDPdyCoarse", .opcode = 214, .operands = &operands_op_d_pdy_coarse },
    .{ .name = "OpFwidthCoarse", .opcode = 215, .operands = &operands_op_fwidth_coarse },
    .{ .name = "OpEmitVertex", .opcode = 218, .operands = &operands_op_emit_vertex },
    .{ .name = "OpEndPrimitive", .opcode = 219, .operands = &operands_op_end_primitive },
    .{ .name = "OpEmitStreamVertex", .opcode = 220, .operands = &operands_op_emit_stream_vertex },
    .{ .name = "OpEndStreamPrimitive", .opcode = 221, .operands = &operands_op_end_stream_primitive },
    .{ .name = "OpControlBarrier", .opcode = 224, .operands = &operands_op_control_barrier },
    .{ .name = "OpMemoryBarrier", .opcode = 225, .operands = &operands_op_memory_barrier },
    .{ .name = "OpAtomicLoad", .opcode = 227, .operands = &operands_op_atomic_load },
    .{ .name = "OpAtomicStore", .opcode = 228, .operands = &operands_op_atomic_store },
    .{ .name = "OpAtomicExchange", .opcode = 229, .operands = &operands_op_atomic_exchange },
    .{ .name = "OpAtomicCompareExchange", .opcode = 230, .operands = &operands_op_atomic_compare_exchange },
    .{ .name = "OpAtomicCompareExchangeWeak", .opcode = 231, .operands = &operands_op_atomic_compare_exchange_weak },
    .{ .name = "OpAtomicIIncrement", .opcode = 232, .operands = &operands_op_atomic_i_increment },
    .{ .name = "OpAtomicIDecrement", .opcode = 233, .operands = &operands_op_atomic_i_decrement },
    .{ .name = "OpAtomicIAdd", .opcode = 234, .operands = &operands_op_atomic_i_add },
    .{ .name = "OpAtomicISub", .opcode = 235, .operands = &operands_op_atomic_i_sub },
    .{ .name = "OpAtomicSMin", .opcode = 236, .operands = &operands_op_atomic_s_min },
    .{ .name = "OpAtomicUMin", .opcode = 237, .operands = &operands_op_atomic_u_min },
    .{ .name = "OpAtomicSMax", .opcode = 238, .operands = &operands_op_atomic_s_max },
    .{ .name = "OpAtomicUMax", .opcode = 239, .operands = &operands_op_atomic_u_max },
    .{ .name = "OpAtomicAnd", .opcode = 240, .operands = &operands_op_atomic_and },
    .{ .name = "OpAtomicOr", .opcode = 241, .operands = &operands_op_atomic_or },
    .{ .name = "OpAtomicXor", .opcode = 242, .operands = &operands_op_atomic_xor },
    .{ .name = "OpPhi", .opcode = 245, .operands = &operands_op_phi },
    .{ .name = "OpLoopMerge", .opcode = 246, .operands = &operands_op_loop_merge },
    .{ .name = "OpSelectionMerge", .opcode = 247, .operands = &operands_op_selection_merge },
    .{ .name = "OpLabel", .opcode = 248, .operands = &operands_op_label },
    .{ .name = "OpBranch", .opcode = 249, .operands = &operands_op_branch },
    .{ .name = "OpBranchConditional", .opcode = 250, .operands = &operands_op_branch_conditional },
    .{ .name = "OpSwitch", .opcode = 251, .operands = &operands_op_switch },
    .{ .name = "OpKill", .opcode = 252, .operands = &operands_op_kill },
    .{ .name = "OpReturn", .opcode = 253, .operands = &operands_op_return },
    .{ .name = "OpReturnValue", .opcode = 254, .operands = &operands_op_return_value },
    .{ .name = "OpUnreachable", .opcode = 255, .operands = &operands_op_unreachable },
    .{ .name = "OpLifetimeStart", .opcode = 256, .operands = &operands_op_lifetime_start },
    .{ .name = "OpLifetimeStop", .opcode = 257, .operands = &operands_op_lifetime_stop },
    .{ .name = "OpGroupAsyncCopy", .opcode = 259, .operands = &operands_op_group_async_copy },
    .{ .name = "OpGroupWaitEvents", .opcode = 260, .operands = &operands_op_group_wait_events },
    .{ .name = "OpGroupAll", .opcode = 261, .operands = &operands_op_group_all },
    .{ .name = "OpGroupAny", .opcode = 262, .operands = &operands_op_group_any },
    .{ .name = "OpGroupBroadcast", .opcode = 263, .operands = &operands_op_group_broadcast },
    .{ .name = "OpGroupIAdd", .opcode = 264, .operands = &operands_op_group_i_add },
    .{ .name = "OpGroupFAdd", .opcode = 265, .operands = &operands_op_group_f_add },
    .{ .name = "OpGroupFMin", .opcode = 266, .operands = &operands_op_group_f_min },
    .{ .name = "OpGroupUMin", .opcode = 267, .operands = &operands_op_group_u_min },
    .{ .name = "OpGroupSMin", .opcode = 268, .operands = &operands_op_group_s_min },
    .{ .name = "OpGroupFMax", .opcode = 269, .operands = &operands_op_group_f_max },
    .{ .name = "OpGroupUMax", .opcode = 270, .operands = &operands_op_group_u_max },
    .{ .name = "OpGroupSMax", .opcode = 271, .operands = &operands_op_group_s_max },
    .{ .name = "OpReadPipe", .opcode = 274, .operands = &operands_op_read_pipe },
    .{ .name = "OpWritePipe", .opcode = 275, .operands = &operands_op_write_pipe },
    .{ .name = "OpReservedReadPipe", .opcode = 276, .operands = &operands_op_reserved_read_pipe },
    .{ .name = "OpReservedWritePipe", .opcode = 277, .operands = &operands_op_reserved_write_pipe },
    .{ .name = "OpReserveReadPipePackets", .opcode = 278, .operands = &operands_op_reserve_read_pipe_packets },
    .{ .name = "OpReserveWritePipePackets", .opcode = 279, .operands = &operands_op_reserve_write_pipe_packets },
    .{ .name = "OpCommitReadPipe", .opcode = 280, .operands = &operands_op_commit_read_pipe },
    .{ .name = "OpCommitWritePipe", .opcode = 281, .operands = &operands_op_commit_write_pipe },
    .{ .name = "OpIsValidReserveId", .opcode = 282, .operands = &operands_op_is_valid_reserve_id },
    .{ .name = "OpGetNumPipePackets", .opcode = 283, .operands = &operands_op_get_num_pipe_packets },
    .{ .name = "OpGetMaxPipePackets", .opcode = 284, .operands = &operands_op_get_max_pipe_packets },
    .{ .name = "OpGroupReserveReadPipePackets", .opcode = 285, .operands = &operands_op_group_reserve_read_pipe_packets },
    .{ .name = "OpGroupReserveWritePipePackets", .opcode = 286, .operands = &operands_op_group_reserve_write_pipe_packets },
    .{ .name = "OpGroupCommitReadPipe", .opcode = 287, .operands = &operands_op_group_commit_read_pipe },
    .{ .name = "OpGroupCommitWritePipe", .opcode = 288, .operands = &operands_op_group_commit_write_pipe },
    .{ .name = "OpEnqueueMarker", .opcode = 291, .operands = &operands_op_enqueue_marker },
    .{ .name = "OpEnqueueKernel", .opcode = 292, .operands = &operands_op_enqueue_kernel },
    .{ .name = "OpGetKernelNDrangeSubGroupCount", .opcode = 293, .operands = &operands_op_get_kernel_n_drange_sub_group_count },
    .{ .name = "OpGetKernelNDrangeMaxSubGroupSize", .opcode = 294, .operands = &operands_op_get_kernel_n_drange_max_sub_group_size },
    .{ .name = "OpGetKernelWorkGroupSize", .opcode = 295, .operands = &operands_op_get_kernel_work_group_size },
    .{ .name = "OpGetKernelPreferredWorkGroupSizeMultiple", .opcode = 296, .operands = &operands_op_get_kernel_preferred_work_group_size_multiple },
    .{ .name = "OpRetainEvent", .opcode = 297, .operands = &operands_op_retain_event },
    .{ .name = "OpReleaseEvent", .opcode = 298, .operands = &operands_op_release_event },
    .{ .name = "OpCreateUserEvent", .opcode = 299, .operands = &operands_op_create_user_event },
    .{ .name = "OpIsValidEvent", .opcode = 300, .operands = &operands_op_is_valid_event },
    .{ .name = "OpSetUserEventStatus", .opcode = 301, .operands = &operands_op_set_user_event_status },
    .{ .name = "OpCaptureEventProfilingInfo", .opcode = 302, .operands = &operands_op_capture_event_profiling_info },
    .{ .name = "OpGetDefaultQueue", .opcode = 303, .operands = &operands_op_get_default_queue },
    .{ .name = "OpBuildNDRange", .opcode = 304, .operands = &operands_op_build_nd_range },
    .{ .name = "OpImageSparseSampleImplicitLod", .opcode = 305, .operands = &operands_op_image_sparse_sample_implicit_lod },
    .{ .name = "OpImageSparseSampleExplicitLod", .opcode = 306, .operands = &operands_op_image_sparse_sample_explicit_lod },
    .{ .name = "OpImageSparseSampleDrefImplicitLod", .opcode = 307, .operands = &operands_op_image_sparse_sample_dref_implicit_lod },
    .{ .name = "OpImageSparseSampleDrefExplicitLod", .opcode = 308, .operands = &operands_op_image_sparse_sample_dref_explicit_lod },
    .{ .name = "OpImageSparseSampleProjImplicitLod", .opcode = 309, .operands = &operands_op_image_sparse_sample_proj_implicit_lod },
    .{ .name = "OpImageSparseSampleProjExplicitLod", .opcode = 310, .operands = &operands_op_image_sparse_sample_proj_explicit_lod },
    .{ .name = "OpImageSparseSampleProjDrefImplicitLod", .opcode = 311, .operands = &operands_op_image_sparse_sample_proj_dref_implicit_lod },
    .{ .name = "OpImageSparseSampleProjDrefExplicitLod", .opcode = 312, .operands = &operands_op_image_sparse_sample_proj_dref_explicit_lod },
    .{ .name = "OpImageSparseFetch", .opcode = 313, .operands = &operands_op_image_sparse_fetch },
    .{ .name = "OpImageSparseGather", .opcode = 314, .operands = &operands_op_image_sparse_gather },
    .{ .name = "OpImageSparseDrefGather", .opcode = 315, .operands = &operands_op_image_sparse_dref_gather },
    .{ .name = "OpImageSparseTexelsResident", .opcode = 316, .operands = &operands_op_image_sparse_texels_resident },
    .{ .name = "OpNoLine", .opcode = 317, .operands = &operands_op_no_line },
    .{ .name = "OpAtomicFlagTestAndSet", .opcode = 318, .operands = &operands_op_atomic_flag_test_and_set },
    .{ .name = "OpAtomicFlagClear", .opcode = 319, .operands = &operands_op_atomic_flag_clear },
    .{ .name = "OpImageSparseRead", .opcode = 320, .operands = &operands_op_image_sparse_read },
    .{ .name = "OpSizeOf", .opcode = 321, .operands = &operands_op_size_of },
    .{ .name = "OpTypePipeStorage", .opcode = 322, .operands = &operands_op_type_pipe_storage },
    .{ .name = "OpConstantPipeStorage", .opcode = 323, .operands = &operands_op_constant_pipe_storage },
    .{ .name = "OpCreatePipeFromPipeStorage", .opcode = 324, .operands = &operands_op_create_pipe_from_pipe_storage },
    .{ .name = "OpGetKernelLocalSizeForSubgroupCount", .opcode = 325, .operands = &operands_op_get_kernel_local_size_for_subgroup_count },
    .{ .name = "OpGetKernelMaxNumSubgroups", .opcode = 326, .operands = &operands_op_get_kernel_max_num_subgroups },
    .{ .name = "OpTypeNamedBarrier", .opcode = 327, .operands = &operands_op_type_named_barrier },
    .{ .name = "OpNamedBarrierInitialize", .opcode = 328, .operands = &operands_op_named_barrier_initialize },
    .{ .name = "OpMemoryNamedBarrier", .opcode = 329, .operands = &operands_op_memory_named_barrier },
    .{ .name = "OpModuleProcessed", .opcode = 330, .operands = &operands_op_module_processed },
    .{ .name = "OpExecutionModeId", .opcode = 331, .operands = &operands_op_execution_mode_id },
    .{ .name = "OpDecorateId", .opcode = 332, .operands = &operands_op_decorate_id },
    .{ .name = "OpGroupNonUniformElect", .opcode = 333, .operands = &operands_op_group_non_uniform_elect },
    .{ .name = "OpGroupNonUniformAll", .opcode = 334, .operands = &operands_op_group_non_uniform_all },
    .{ .name = "OpGroupNonUniformAny", .opcode = 335, .operands = &operands_op_group_non_uniform_any },
    .{ .name = "OpGroupNonUniformAllEqual", .opcode = 336, .operands = &operands_op_group_non_uniform_all_equal },
    .{ .name = "OpGroupNonUniformBroadcast", .opcode = 337, .operands = &operands_op_group_non_uniform_broadcast },
    .{ .name = "OpGroupNonUniformBroadcastFirst", .opcode = 338, .operands = &operands_op_group_non_uniform_broadcast_first },
    .{ .name = "OpGroupNonUniformBallot", .opcode = 339, .operands = &operands_op_group_non_uniform_ballot },
    .{ .name = "OpGroupNonUniformInverseBallot", .opcode = 340, .operands = &operands_op_group_non_uniform_inverse_ballot },
    .{ .name = "OpGroupNonUniformBallotBitExtract", .opcode = 341, .operands = &operands_op_group_non_uniform_ballot_bit_extract },
    .{ .name = "OpGroupNonUniformBallotBitCount", .opcode = 342, .operands = &operands_op_group_non_uniform_ballot_bit_count },
    .{ .name = "OpGroupNonUniformBallotFindLSB", .opcode = 343, .operands = &operands_op_group_non_uniform_ballot_find_lsb },
    .{ .name = "OpGroupNonUniformBallotFindMSB", .opcode = 344, .operands = &operands_op_group_non_uniform_ballot_find_msb },
    .{ .name = "OpGroupNonUniformShuffle", .opcode = 345, .operands = &operands_op_group_non_uniform_shuffle },
    .{ .name = "OpGroupNonUniformShuffleXor", .opcode = 346, .operands = &operands_op_group_non_uniform_shuffle_xor },
    .{ .name = "OpGroupNonUniformShuffleUp", .opcode = 347, .operands = &operands_op_group_non_uniform_shuffle_up },
    .{ .name = "OpGroupNonUniformShuffleDown", .opcode = 348, .operands = &operands_op_group_non_uniform_shuffle_down },
    .{ .name = "OpGroupNonUniformIAdd", .opcode = 349, .operands = &operands_op_group_non_uniform_i_add },
    .{ .name = "OpGroupNonUniformFAdd", .opcode = 350, .operands = &operands_op_group_non_uniform_f_add },
    .{ .name = "OpGroupNonUniformIMul", .opcode = 351, .operands = &operands_op_group_non_uniform_i_mul },
    .{ .name = "OpGroupNonUniformFMul", .opcode = 352, .operands = &operands_op_group_non_uniform_f_mul },
    .{ .name = "OpGroupNonUniformSMin", .opcode = 353, .operands = &operands_op_group_non_uniform_s_min },
    .{ .name = "OpGroupNonUniformUMin", .opcode = 354, .operands = &operands_op_group_non_uniform_u_min },
    .{ .name = "OpGroupNonUniformFMin", .opcode = 355, .operands = &operands_op_group_non_uniform_f_min },
    .{ .name = "OpGroupNonUniformSMax", .opcode = 356, .operands = &operands_op_group_non_uniform_s_max },
    .{ .name = "OpGroupNonUniformUMax", .opcode = 357, .operands = &operands_op_group_non_uniform_u_max },
    .{ .name = "OpGroupNonUniformFMax", .opcode = 358, .operands = &operands_op_group_non_uniform_f_max },
    .{ .name = "OpGroupNonUniformBitwiseAnd", .opcode = 359, .operands = &operands_op_group_non_uniform_bitwise_and },
    .{ .name = "OpGroupNonUniformBitwiseOr", .opcode = 360, .operands = &operands_op_group_non_uniform_bitwise_or },
    .{ .name = "OpGroupNonUniformBitwiseXor", .opcode = 361, .operands = &operands_op_group_non_uniform_bitwise_xor },
    .{ .name = "OpGroupNonUniformLogicalAnd", .opcode = 362, .operands = &operands_op_group_non_uniform_logical_and },
    .{ .name = "OpGroupNonUniformLogicalOr", .opcode = 363, .operands = &operands_op_group_non_uniform_logical_or },
    .{ .name = "OpGroupNonUniformLogicalXor", .opcode = 364, .operands = &operands_op_group_non_uniform_logical_xor },
    .{ .name = "OpGroupNonUniformQuadBroadcast", .opcode = 365, .operands = &operands_op_group_non_uniform_quad_broadcast },
    .{ .name = "OpGroupNonUniformQuadSwap", .opcode = 366, .operands = &operands_op_group_non_uniform_quad_swap },
    .{ .name = "OpCopyLogical", .opcode = 400, .operands = &operands_op_copy_logical },
    .{ .name = "OpPtrEqual", .opcode = 401, .operands = &operands_op_ptr_equal },
    .{ .name = "OpPtrNotEqual", .opcode = 402, .operands = &operands_op_ptr_not_equal },
    .{ .name = "OpPtrDiff", .opcode = 403, .operands = &operands_op_ptr_diff },
    .{ .name = "OpColorAttachmentReadEXT", .opcode = 4160, .operands = &operands_op_color_attachment_read_ext },
    .{ .name = "OpDepthAttachmentReadEXT", .opcode = 4161, .operands = &operands_op_depth_attachment_read_ext },
    .{ .name = "OpStencilAttachmentReadEXT", .opcode = 4162, .operands = &operands_op_stencil_attachment_read_ext },
    .{ .name = "OpTypeTensorARM", .opcode = 4163, .operands = &operands_op_type_tensor_arm },
    .{ .name = "OpTensorReadARM", .opcode = 4164, .operands = &operands_op_tensor_read_arm },
    .{ .name = "OpTensorWriteARM", .opcode = 4165, .operands = &operands_op_tensor_write_arm },
    .{ .name = "OpTensorQuerySizeARM", .opcode = 4166, .operands = &operands_op_tensor_query_size_arm },
    .{ .name = "OpGraphConstantARM", .opcode = 4181, .operands = &operands_op_graph_constant_arm },
    .{ .name = "OpGraphEntryPointARM", .opcode = 4182, .operands = &operands_op_graph_entry_point_arm },
    .{ .name = "OpGraphARM", .opcode = 4183, .operands = &operands_op_graph_arm },
    .{ .name = "OpGraphInputARM", .opcode = 4184, .operands = &operands_op_graph_input_arm },
    .{ .name = "OpGraphSetOutputARM", .opcode = 4185, .operands = &operands_op_graph_set_output_arm },
    .{ .name = "OpGraphEndARM", .opcode = 4186, .operands = &operands_op_graph_end_arm },
    .{ .name = "OpTypeGraphARM", .opcode = 4190, .operands = &operands_op_type_graph_arm },
    .{ .name = "OpBitcastExtractEXT", .opcode = 4195, .operands = &operands_op_bitcast_extract_ext },
    .{ .name = "OpTerminateInvocation", .opcode = 4416, .operands = &operands_op_terminate_invocation },
    .{ .name = "OpTypeUntypedPointerKHR", .opcode = 4417, .operands = &operands_op_type_untyped_pointer_khr },
    .{ .name = "OpUntypedVariableKHR", .opcode = 4418, .operands = &operands_op_untyped_variable_khr },
    .{ .name = "OpUntypedAccessChainKHR", .opcode = 4419, .operands = &operands_op_untyped_access_chain_khr },
    .{ .name = "OpUntypedInBoundsAccessChainKHR", .opcode = 4420, .operands = &operands_op_untyped_in_bounds_access_chain_khr },
    .{ .name = "OpSubgroupBallotKHR", .opcode = 4421, .operands = &operands_op_subgroup_ballot_khr },
    .{ .name = "OpSubgroupFirstInvocationKHR", .opcode = 4422, .operands = &operands_op_subgroup_first_invocation_khr },
    .{ .name = "OpUntypedPtrAccessChainKHR", .opcode = 4423, .operands = &operands_op_untyped_ptr_access_chain_khr },
    .{ .name = "OpUntypedInBoundsPtrAccessChainKHR", .opcode = 4424, .operands = &operands_op_untyped_in_bounds_ptr_access_chain_khr },
    .{ .name = "OpUntypedArrayLengthKHR", .opcode = 4425, .operands = &operands_op_untyped_array_length_khr },
    .{ .name = "OpUntypedPrefetchKHR", .opcode = 4426, .operands = &operands_op_untyped_prefetch_khr },
    .{ .name = "OpFmaKHR", .opcode = 4427, .operands = &operands_op_fma_khr },
    .{ .name = "OpSubgroupAllKHR", .opcode = 4428, .operands = &operands_op_subgroup_all_khr },
    .{ .name = "OpSubgroupAnyKHR", .opcode = 4429, .operands = &operands_op_subgroup_any_khr },
    .{ .name = "OpSubgroupAllEqualKHR", .opcode = 4430, .operands = &operands_op_subgroup_all_equal_khr },
    .{ .name = "OpGroupNonUniformRotateKHR", .opcode = 4431, .operands = &operands_op_group_non_uniform_rotate_khr },
    .{ .name = "OpSubgroupReadInvocationKHR", .opcode = 4432, .operands = &operands_op_subgroup_read_invocation_khr },
    .{ .name = "OpExtInstWithForwardRefsKHR", .opcode = 4433, .operands = &operands_op_ext_inst_with_forward_refs_khr },
    .{ .name = "OpUntypedGroupAsyncCopyKHR", .opcode = 4434, .operands = &operands_op_untyped_group_async_copy_khr },
    .{ .name = "OpTraceRayKHR", .opcode = 4445, .operands = &operands_op_trace_ray_khr },
    .{ .name = "OpExecuteCallableKHR", .opcode = 4446, .operands = &operands_op_execute_callable_khr },
    .{ .name = "OpConvertUToAccelerationStructureKHR", .opcode = 4447, .operands = &operands_op_convert_u_to_acceleration_structure_khr },
    .{ .name = "OpIgnoreIntersectionKHR", .opcode = 4448, .operands = &operands_op_ignore_intersection_khr },
    .{ .name = "OpTerminateRayKHR", .opcode = 4449, .operands = &operands_op_terminate_ray_khr },
    .{ .name = "OpSDot", .opcode = 4450, .operands = &operands_op_s_dot },
    .{ .name = "OpSDotKHR", .opcode = 4450, .operands = &operands_op_s_dot },
    .{ .name = "OpUDot", .opcode = 4451, .operands = &operands_op_u_dot },
    .{ .name = "OpUDotKHR", .opcode = 4451, .operands = &operands_op_u_dot },
    .{ .name = "OpSUDot", .opcode = 4452, .operands = &operands_op_su_dot },
    .{ .name = "OpSUDotKHR", .opcode = 4452, .operands = &operands_op_su_dot },
    .{ .name = "OpSDotAccSat", .opcode = 4453, .operands = &operands_op_s_dot_acc_sat },
    .{ .name = "OpSDotAccSatKHR", .opcode = 4453, .operands = &operands_op_s_dot_acc_sat },
    .{ .name = "OpUDotAccSat", .opcode = 4454, .operands = &operands_op_u_dot_acc_sat },
    .{ .name = "OpUDotAccSatKHR", .opcode = 4454, .operands = &operands_op_u_dot_acc_sat },
    .{ .name = "OpSUDotAccSat", .opcode = 4455, .operands = &operands_op_su_dot_acc_sat },
    .{ .name = "OpSUDotAccSatKHR", .opcode = 4455, .operands = &operands_op_su_dot_acc_sat },
    .{ .name = "OpTypeCooperativeMatrixKHR", .opcode = 4456, .operands = &operands_op_type_cooperative_matrix_khr },
    .{ .name = "OpCooperativeMatrixLoadKHR", .opcode = 4457, .operands = &operands_op_cooperative_matrix_load_khr },
    .{ .name = "OpCooperativeMatrixStoreKHR", .opcode = 4458, .operands = &operands_op_cooperative_matrix_store_khr },
    .{ .name = "OpCooperativeMatrixMulAddKHR", .opcode = 4459, .operands = &operands_op_cooperative_matrix_mul_add_khr },
    .{ .name = "OpCooperativeMatrixLengthKHR", .opcode = 4460, .operands = &operands_op_cooperative_matrix_length_khr },
    .{ .name = "OpConstantCompositeReplicateEXT", .opcode = 4461, .operands = &operands_op_constant_composite_replicate_ext },
    .{ .name = "OpSpecConstantCompositeReplicateEXT", .opcode = 4462, .operands = &operands_op_spec_constant_composite_replicate_ext },
    .{ .name = "OpCompositeConstructReplicateEXT", .opcode = 4463, .operands = &operands_op_composite_construct_replicate_ext },
    .{ .name = "OpTypeRayQueryKHR", .opcode = 4472, .operands = &operands_op_type_ray_query_khr },
    .{ .name = "OpRayQueryInitializeKHR", .opcode = 4473, .operands = &operands_op_ray_query_initialize_khr },
    .{ .name = "OpRayQueryTerminateKHR", .opcode = 4474, .operands = &operands_op_ray_query_terminate_khr },
    .{ .name = "OpRayQueryGenerateIntersectionKHR", .opcode = 4475, .operands = &operands_op_ray_query_generate_intersection_khr },
    .{ .name = "OpRayQueryConfirmIntersectionKHR", .opcode = 4476, .operands = &operands_op_ray_query_confirm_intersection_khr },
    .{ .name = "OpRayQueryProceedKHR", .opcode = 4477, .operands = &operands_op_ray_query_proceed_khr },
    .{ .name = "OpRayQueryGetIntersectionTypeKHR", .opcode = 4479, .operands = &operands_op_ray_query_get_intersection_type_khr },
    .{ .name = "OpImageSampleWeightedQCOM", .opcode = 4480, .operands = &operands_op_image_sample_weighted_qcom },
    .{ .name = "OpImageBoxFilterQCOM", .opcode = 4481, .operands = &operands_op_image_box_filter_qcom },
    .{ .name = "OpImageBlockMatchSSDQCOM", .opcode = 4482, .operands = &operands_op_image_block_match_ssdqcom },
    .{ .name = "OpImageBlockMatchSADQCOM", .opcode = 4483, .operands = &operands_op_image_block_match_sadqcom },
    .{ .name = "OpBitCastArrayQCOM", .opcode = 4497, .operands = &operands_op_bit_cast_array_qcom },
    .{ .name = "OpImageBlockMatchWindowSSDQCOM", .opcode = 4500, .operands = &operands_op_image_block_match_window_ssdqcom },
    .{ .name = "OpImageBlockMatchWindowSADQCOM", .opcode = 4501, .operands = &operands_op_image_block_match_window_sadqcom },
    .{ .name = "OpImageBlockMatchGatherSSDQCOM", .opcode = 4502, .operands = &operands_op_image_block_match_gather_ssdqcom },
    .{ .name = "OpImageBlockMatchGatherSADQCOM", .opcode = 4503, .operands = &operands_op_image_block_match_gather_sadqcom },
    .{ .name = "OpBFloat16MulAddQCOM", .opcode = 4505, .operands = &operands_op_b_float16_mul_add_qcom },
    .{ .name = "OpCompositeConstructCoopMatQCOM", .opcode = 4540, .operands = &operands_op_composite_construct_coop_mat_qcom },
    .{ .name = "OpCompositeExtractCoopMatQCOM", .opcode = 4541, .operands = &operands_op_composite_extract_coop_mat_qcom },
    .{ .name = "OpExtractSubArrayQCOM", .opcode = 4542, .operands = &operands_op_extract_sub_array_qcom },
    .{ .name = "OpImageGatherQCOM", .opcode = 4545, .operands = &operands_op_image_gather_qcom },
    .{ .name = "OpGroupIAddNonUniformAMD", .opcode = 5000, .operands = &operands_op_group_i_add_non_uniform_amd },
    .{ .name = "OpGroupFAddNonUniformAMD", .opcode = 5001, .operands = &operands_op_group_f_add_non_uniform_amd },
    .{ .name = "OpGroupFMinNonUniformAMD", .opcode = 5002, .operands = &operands_op_group_f_min_non_uniform_amd },
    .{ .name = "OpGroupUMinNonUniformAMD", .opcode = 5003, .operands = &operands_op_group_u_min_non_uniform_amd },
    .{ .name = "OpGroupSMinNonUniformAMD", .opcode = 5004, .operands = &operands_op_group_s_min_non_uniform_amd },
    .{ .name = "OpGroupFMaxNonUniformAMD", .opcode = 5005, .operands = &operands_op_group_f_max_non_uniform_amd },
    .{ .name = "OpGroupUMaxNonUniformAMD", .opcode = 5006, .operands = &operands_op_group_u_max_non_uniform_amd },
    .{ .name = "OpGroupSMaxNonUniformAMD", .opcode = 5007, .operands = &operands_op_group_s_max_non_uniform_amd },
    .{ .name = "OpFragmentMaskFetchAMD", .opcode = 5011, .operands = &operands_op_fragment_mask_fetch_amd },
    .{ .name = "OpFragmentFetchAMD", .opcode = 5012, .operands = &operands_op_fragment_fetch_amd },
    .{ .name = "OpReadClockKHR", .opcode = 5056, .operands = &operands_op_read_clock_khr },
    .{ .name = "OpAllocateNodePayloadsAMDX", .opcode = 5074, .operands = &operands_op_allocate_node_payloads_amdx },
    .{ .name = "OpEnqueueNodePayloadsAMDX", .opcode = 5075, .operands = &operands_op_enqueue_node_payloads_amdx },
    .{ .name = "OpTypeNodePayloadArrayAMDX", .opcode = 5076, .operands = &operands_op_type_node_payload_array_amdx },
    .{ .name = "OpFinishWritingNodePayloadAMDX", .opcode = 5078, .operands = &operands_op_finish_writing_node_payload_amdx },
    .{ .name = "OpNodePayloadArrayLengthAMDX", .opcode = 5090, .operands = &operands_op_node_payload_array_length_amdx },
    .{ .name = "OpIsNodePayloadValidAMDX", .opcode = 5101, .operands = &operands_op_is_node_payload_valid_amdx },
    .{ .name = "OpConstantStringAMDX", .opcode = 5103, .operands = &operands_op_constant_string_amdx },
    .{ .name = "OpSpecConstantStringAMDX", .opcode = 5104, .operands = &operands_op_spec_constant_string_amdx },
    .{ .name = "OpGroupNonUniformQuadAllKHR", .opcode = 5110, .operands = &operands_op_group_non_uniform_quad_all_khr },
    .{ .name = "OpGroupNonUniformQuadAnyKHR", .opcode = 5111, .operands = &operands_op_group_non_uniform_quad_any_khr },
    .{ .name = "OpTypeBufferEXT", .opcode = 5115, .operands = &operands_op_type_buffer_ext },
    .{ .name = "OpBufferPointerEXT", .opcode = 5119, .operands = &operands_op_buffer_pointer_ext },
    .{ .name = "OpAbortKHR", .opcode = 5121, .operands = &operands_op_abort_khr },
    .{ .name = "OpUntypedImageTexelPointerEXT", .opcode = 5126, .operands = &operands_op_untyped_image_texel_pointer_ext },
    .{ .name = "OpMemberDecorateIdEXT", .opcode = 5127, .operands = &operands_op_member_decorate_id_ext },
    .{ .name = "OpConstantSizeOfEXT", .opcode = 5129, .operands = &operands_op_constant_size_of_ext },
    .{ .name = "OpConstantDataKHR", .opcode = 5147, .operands = &operands_op_constant_data_khr },
    .{ .name = "OpSpecConstantDataKHR", .opcode = 5148, .operands = &operands_op_spec_constant_data_khr },
    .{ .name = "OpPoisonKHR", .opcode = 5158, .operands = &operands_op_poison_khr },
    .{ .name = "OpFreezeKHR", .opcode = 5159, .operands = &operands_op_freeze_khr },
    .{ .name = "OpHitObjectRecordHitMotionNV", .opcode = 5249, .operands = &operands_op_hit_object_record_hit_motion_nv },
    .{ .name = "OpHitObjectRecordHitWithIndexMotionNV", .opcode = 5250, .operands = &operands_op_hit_object_record_hit_with_index_motion_nv },
    .{ .name = "OpHitObjectRecordMissMotionNV", .opcode = 5251, .operands = &operands_op_hit_object_record_miss_motion_nv },
    .{ .name = "OpHitObjectGetWorldToObjectNV", .opcode = 5252, .operands = &operands_op_hit_object_get_world_to_object_nv },
    .{ .name = "OpHitObjectGetObjectToWorldNV", .opcode = 5253, .operands = &operands_op_hit_object_get_object_to_world_nv },
    .{ .name = "OpHitObjectGetObjectRayDirectionNV", .opcode = 5254, .operands = &operands_op_hit_object_get_object_ray_direction_nv },
    .{ .name = "OpHitObjectGetObjectRayOriginNV", .opcode = 5255, .operands = &operands_op_hit_object_get_object_ray_origin_nv },
    .{ .name = "OpHitObjectTraceRayMotionNV", .opcode = 5256, .operands = &operands_op_hit_object_trace_ray_motion_nv },
    .{ .name = "OpHitObjectGetShaderRecordBufferHandleNV", .opcode = 5257, .operands = &operands_op_hit_object_get_shader_record_buffer_handle_nv },
    .{ .name = "OpHitObjectGetShaderBindingTableRecordIndexNV", .opcode = 5258, .operands = &operands_op_hit_object_get_shader_binding_table_record_index_nv },
    .{ .name = "OpHitObjectRecordEmptyNV", .opcode = 5259, .operands = &operands_op_hit_object_record_empty_nv },
    .{ .name = "OpHitObjectTraceRayNV", .opcode = 5260, .operands = &operands_op_hit_object_trace_ray_nv },
    .{ .name = "OpHitObjectRecordHitNV", .opcode = 5261, .operands = &operands_op_hit_object_record_hit_nv },
    .{ .name = "OpHitObjectRecordHitWithIndexNV", .opcode = 5262, .operands = &operands_op_hit_object_record_hit_with_index_nv },
    .{ .name = "OpHitObjectRecordMissNV", .opcode = 5263, .operands = &operands_op_hit_object_record_miss_nv },
    .{ .name = "OpHitObjectExecuteShaderNV", .opcode = 5264, .operands = &operands_op_hit_object_execute_shader_nv },
    .{ .name = "OpHitObjectGetCurrentTimeNV", .opcode = 5265, .operands = &operands_op_hit_object_get_current_time_nv },
    .{ .name = "OpHitObjectGetAttributesNV", .opcode = 5266, .operands = &operands_op_hit_object_get_attributes_nv },
    .{ .name = "OpHitObjectGetHitKindNV", .opcode = 5267, .operands = &operands_op_hit_object_get_hit_kind_nv },
    .{ .name = "OpHitObjectGetPrimitiveIndexNV", .opcode = 5268, .operands = &operands_op_hit_object_get_primitive_index_nv },
    .{ .name = "OpHitObjectGetGeometryIndexNV", .opcode = 5269, .operands = &operands_op_hit_object_get_geometry_index_nv },
    .{ .name = "OpHitObjectGetInstanceIdNV", .opcode = 5270, .operands = &operands_op_hit_object_get_instance_id_nv },
    .{ .name = "OpHitObjectGetInstanceCustomIndexNV", .opcode = 5271, .operands = &operands_op_hit_object_get_instance_custom_index_nv },
    .{ .name = "OpHitObjectGetWorldRayDirectionNV", .opcode = 5272, .operands = &operands_op_hit_object_get_world_ray_direction_nv },
    .{ .name = "OpHitObjectGetWorldRayOriginNV", .opcode = 5273, .operands = &operands_op_hit_object_get_world_ray_origin_nv },
    .{ .name = "OpHitObjectGetRayTMaxNV", .opcode = 5274, .operands = &operands_op_hit_object_get_ray_t_max_nv },
    .{ .name = "OpHitObjectGetRayTMinNV", .opcode = 5275, .operands = &operands_op_hit_object_get_ray_t_min_nv },
    .{ .name = "OpHitObjectIsEmptyNV", .opcode = 5276, .operands = &operands_op_hit_object_is_empty_nv },
    .{ .name = "OpHitObjectIsHitNV", .opcode = 5277, .operands = &operands_op_hit_object_is_hit_nv },
    .{ .name = "OpHitObjectIsMissNV", .opcode = 5278, .operands = &operands_op_hit_object_is_miss_nv },
    .{ .name = "OpReorderThreadWithHitObjectNV", .opcode = 5279, .operands = &operands_op_reorder_thread_with_hit_object_nv },
    .{ .name = "OpReorderThreadWithHintNV", .opcode = 5280, .operands = &operands_op_reorder_thread_with_hint_nv },
    .{ .name = "OpTypeHitObjectNV", .opcode = 5281, .operands = &operands_op_type_hit_object_nv },
    .{ .name = "OpImageSampleFootprintNV", .opcode = 5283, .operands = &operands_op_image_sample_footprint_nv },
    .{ .name = "OpTypeVectorIdEXT", .opcode = 5288, .operands = &operands_op_type_vector_id_ext },
    .{ .name = "OpTypeCooperativeVectorNV", .opcode = 5288, .operands = &operands_op_type_vector_id_ext },
    .{ .name = "OpCooperativeVectorMatrixMulNV", .opcode = 5289, .operands = &operands_op_cooperative_vector_matrix_mul_nv },
    .{ .name = "OpCooperativeVectorOuterProductAccumulateNV", .opcode = 5290, .operands = &operands_op_cooperative_vector_outer_product_accumulate_nv },
    .{ .name = "OpCooperativeVectorReduceSumAccumulateNV", .opcode = 5291, .operands = &operands_op_cooperative_vector_reduce_sum_accumulate_nv },
    .{ .name = "OpCooperativeVectorMatrixMulAddNV", .opcode = 5292, .operands = &operands_op_cooperative_vector_matrix_mul_add_nv },
    .{ .name = "OpCooperativeMatrixConvertUseEXT", .opcode = 5293, .operands = &operands_op_cooperative_matrix_convert_use_ext },
    .{ .name = "OpCooperativeMatrixConvertNV", .opcode = 5293, .operands = &operands_op_cooperative_matrix_convert_use_ext },
    .{ .name = "OpEmitMeshTasksEXT", .opcode = 5294, .operands = &operands_op_emit_mesh_tasks_ext },
    .{ .name = "OpSetMeshOutputsEXT", .opcode = 5295, .operands = &operands_op_set_mesh_outputs_ext },
    .{ .name = "OpGroupNonUniformPartitionEXT", .opcode = 5296, .operands = &operands_op_group_non_uniform_partition_ext },
    .{ .name = "OpGroupNonUniformPartitionNV", .opcode = 5296, .operands = &operands_op_group_non_uniform_partition_ext },
    .{ .name = "OpWritePackedPrimitiveIndices4x8NV", .opcode = 5299, .operands = &operands_op_write_packed_primitive_indices4x8_nv },
    .{ .name = "OpFetchMicroTriangleVertexPositionNV", .opcode = 5300, .operands = &operands_op_fetch_micro_triangle_vertex_position_nv },
    .{ .name = "OpFetchMicroTriangleVertexBarycentricNV", .opcode = 5301, .operands = &operands_op_fetch_micro_triangle_vertex_barycentric_nv },
    .{ .name = "OpCooperativeVectorLoadNV", .opcode = 5302, .operands = &operands_op_cooperative_vector_load_nv },
    .{ .name = "OpCooperativeVectorStoreNV", .opcode = 5303, .operands = &operands_op_cooperative_vector_store_nv },
    .{ .name = "OpHitObjectRecordFromQueryEXT", .opcode = 5304, .operands = &operands_op_hit_object_record_from_query_ext },
    .{ .name = "OpHitObjectRecordMissEXT", .opcode = 5305, .operands = &operands_op_hit_object_record_miss_ext },
    .{ .name = "OpHitObjectRecordMissMotionEXT", .opcode = 5306, .operands = &operands_op_hit_object_record_miss_motion_ext },
    .{ .name = "OpHitObjectGetIntersectionTriangleVertexPositionsEXT", .opcode = 5307, .operands = &operands_op_hit_object_get_intersection_triangle_vertex_positions_ext },
    .{ .name = "OpHitObjectGetRayFlagsEXT", .opcode = 5308, .operands = &operands_op_hit_object_get_ray_flags_ext },
    .{ .name = "OpHitObjectSetShaderBindingTableRecordIndexEXT", .opcode = 5309, .operands = &operands_op_hit_object_set_shader_binding_table_record_index_ext },
    .{ .name = "OpHitObjectReorderExecuteShaderEXT", .opcode = 5310, .operands = &operands_op_hit_object_reorder_execute_shader_ext },
    .{ .name = "OpHitObjectTraceReorderExecuteEXT", .opcode = 5311, .operands = &operands_op_hit_object_trace_reorder_execute_ext },
    .{ .name = "OpHitObjectTraceMotionReorderExecuteEXT", .opcode = 5312, .operands = &operands_op_hit_object_trace_motion_reorder_execute_ext },
    .{ .name = "OpTypeHitObjectEXT", .opcode = 5313, .operands = &operands_op_type_hit_object_ext },
    .{ .name = "OpReorderThreadWithHintEXT", .opcode = 5314, .operands = &operands_op_reorder_thread_with_hint_ext },
    .{ .name = "OpReorderThreadWithHitObjectEXT", .opcode = 5315, .operands = &operands_op_reorder_thread_with_hit_object_ext },
    .{ .name = "OpHitObjectTraceRayEXT", .opcode = 5316, .operands = &operands_op_hit_object_trace_ray_ext },
    .{ .name = "OpHitObjectTraceRayMotionEXT", .opcode = 5317, .operands = &operands_op_hit_object_trace_ray_motion_ext },
    .{ .name = "OpHitObjectRecordEmptyEXT", .opcode = 5318, .operands = &operands_op_hit_object_record_empty_ext },
    .{ .name = "OpHitObjectExecuteShaderEXT", .opcode = 5319, .operands = &operands_op_hit_object_execute_shader_ext },
    .{ .name = "OpHitObjectGetCurrentTimeEXT", .opcode = 5320, .operands = &operands_op_hit_object_get_current_time_ext },
    .{ .name = "OpHitObjectGetAttributesEXT", .opcode = 5321, .operands = &operands_op_hit_object_get_attributes_ext },
    .{ .name = "OpHitObjectGetHitKindEXT", .opcode = 5322, .operands = &operands_op_hit_object_get_hit_kind_ext },
    .{ .name = "OpHitObjectGetPrimitiveIndexEXT", .opcode = 5323, .operands = &operands_op_hit_object_get_primitive_index_ext },
    .{ .name = "OpHitObjectGetGeometryIndexEXT", .opcode = 5324, .operands = &operands_op_hit_object_get_geometry_index_ext },
    .{ .name = "OpHitObjectGetInstanceIdEXT", .opcode = 5325, .operands = &operands_op_hit_object_get_instance_id_ext },
    .{ .name = "OpHitObjectGetInstanceCustomIndexEXT", .opcode = 5326, .operands = &operands_op_hit_object_get_instance_custom_index_ext },
    .{ .name = "OpHitObjectGetObjectRayOriginEXT", .opcode = 5327, .operands = &operands_op_hit_object_get_object_ray_origin_ext },
    .{ .name = "OpHitObjectGetObjectRayDirectionEXT", .opcode = 5328, .operands = &operands_op_hit_object_get_object_ray_direction_ext },
    .{ .name = "OpHitObjectGetWorldRayDirectionEXT", .opcode = 5329, .operands = &operands_op_hit_object_get_world_ray_direction_ext },
    .{ .name = "OpHitObjectGetWorldRayOriginEXT", .opcode = 5330, .operands = &operands_op_hit_object_get_world_ray_origin_ext },
    .{ .name = "OpHitObjectGetObjectToWorldEXT", .opcode = 5331, .operands = &operands_op_hit_object_get_object_to_world_ext },
    .{ .name = "OpHitObjectGetWorldToObjectEXT", .opcode = 5332, .operands = &operands_op_hit_object_get_world_to_object_ext },
    .{ .name = "OpHitObjectGetRayTMaxEXT", .opcode = 5333, .operands = &operands_op_hit_object_get_ray_t_max_ext },
    .{ .name = "OpReportIntersectionKHR", .opcode = 5334, .operands = &operands_op_report_intersection_khr },
    .{ .name = "OpReportIntersectionNV", .opcode = 5334, .operands = &operands_op_report_intersection_khr },
    .{ .name = "OpIgnoreIntersectionNV", .opcode = 5335, .operands = &operands_op_ignore_intersection_nv },
    .{ .name = "OpTerminateRayNV", .opcode = 5336, .operands = &operands_op_terminate_ray_nv },
    .{ .name = "OpTraceNV", .opcode = 5337, .operands = &operands_op_trace_nv },
    .{ .name = "OpTraceMotionNV", .opcode = 5338, .operands = &operands_op_trace_motion_nv },
    .{ .name = "OpTraceRayMotionNV", .opcode = 5339, .operands = &operands_op_trace_ray_motion_nv },
    .{ .name = "OpRayQueryGetIntersectionTriangleVertexPositionsKHR", .opcode = 5340, .operands = &operands_op_ray_query_get_intersection_triangle_vertex_positions_khr },
    .{ .name = "OpTypeAccelerationStructureKHR", .opcode = 5341, .operands = &operands_op_type_acceleration_structure_khr },
    .{ .name = "OpTypeAccelerationStructureNV", .opcode = 5341, .operands = &operands_op_type_acceleration_structure_khr },
    .{ .name = "OpExecuteCallableNV", .opcode = 5344, .operands = &operands_op_execute_callable_nv },
    .{ .name = "OpRayQueryGetIntersectionClusterIdNV", .opcode = 5345, .operands = &operands_op_ray_query_get_intersection_cluster_id_nv },
    .{ .name = "OpRayQueryGetClusterIdNV", .opcode = 5345, .operands = &operands_op_ray_query_get_intersection_cluster_id_nv },
    .{ .name = "OpHitObjectGetClusterIdNV", .opcode = 5346, .operands = &operands_op_hit_object_get_cluster_id_nv },
    .{ .name = "OpHitObjectGetRayTMinEXT", .opcode = 5347, .operands = &operands_op_hit_object_get_ray_t_min_ext },
    .{ .name = "OpHitObjectGetShaderBindingTableRecordIndexEXT", .opcode = 5348, .operands = &operands_op_hit_object_get_shader_binding_table_record_index_ext },
    .{ .name = "OpHitObjectGetShaderRecordBufferHandleEXT", .opcode = 5349, .operands = &operands_op_hit_object_get_shader_record_buffer_handle_ext },
    .{ .name = "OpHitObjectIsEmptyEXT", .opcode = 5350, .operands = &operands_op_hit_object_is_empty_ext },
    .{ .name = "OpHitObjectIsHitEXT", .opcode = 5351, .operands = &operands_op_hit_object_is_hit_ext },
    .{ .name = "OpHitObjectIsMissEXT", .opcode = 5352, .operands = &operands_op_hit_object_is_miss_ext },
    .{ .name = "OpTypeCooperativeMatrixNV", .opcode = 5358, .operands = &operands_op_type_cooperative_matrix_nv },
    .{ .name = "OpCooperativeMatrixLoadNV", .opcode = 5359, .operands = &operands_op_cooperative_matrix_load_nv },
    .{ .name = "OpCooperativeMatrixStoreNV", .opcode = 5360, .operands = &operands_op_cooperative_matrix_store_nv },
    .{ .name = "OpCooperativeMatrixMulAddNV", .opcode = 5361, .operands = &operands_op_cooperative_matrix_mul_add_nv },
    .{ .name = "OpCooperativeMatrixLengthNV", .opcode = 5362, .operands = &operands_op_cooperative_matrix_length_nv },
    .{ .name = "OpCooperativeMatrixGetCoordinateEXT", .opcode = 5363, .operands = &operands_op_cooperative_matrix_get_coordinate_ext },
    .{ .name = "OpBeginInvocationInterlockEXT", .opcode = 5364, .operands = &operands_op_begin_invocation_interlock_ext },
    .{ .name = "OpEndInvocationInterlockEXT", .opcode = 5365, .operands = &operands_op_end_invocation_interlock_ext },
    .{ .name = "OpCooperativeMatrixReduceEXT", .opcode = 5366, .operands = &operands_op_cooperative_matrix_reduce_ext },
    .{ .name = "OpCooperativeMatrixReduceNV", .opcode = 5366, .operands = &operands_op_cooperative_matrix_reduce_ext },
    .{ .name = "OpCooperativeMatrixLoadTensorNV", .opcode = 5367, .operands = &operands_op_cooperative_matrix_load_tensor_nv },
    .{ .name = "OpCooperativeMatrixStoreTensorNV", .opcode = 5368, .operands = &operands_op_cooperative_matrix_store_tensor_nv },
    .{ .name = "OpCooperativeMatrixPerElementOpEXT", .opcode = 5369, .operands = &operands_op_cooperative_matrix_per_element_op_ext },
    .{ .name = "OpCooperativeMatrixPerElementOpNV", .opcode = 5369, .operands = &operands_op_cooperative_matrix_per_element_op_ext },
    .{ .name = "OpTypeTensorLayoutNV", .opcode = 5370, .operands = &operands_op_type_tensor_layout_nv },
    .{ .name = "OpTypeTensorViewNV", .opcode = 5371, .operands = &operands_op_type_tensor_view_nv },
    .{ .name = "OpCreateTensorLayoutNV", .opcode = 5372, .operands = &operands_op_create_tensor_layout_nv },
    .{ .name = "OpTensorLayoutSetDimensionNV", .opcode = 5373, .operands = &operands_op_tensor_layout_set_dimension_nv },
    .{ .name = "OpTensorLayoutSetStrideNV", .opcode = 5374, .operands = &operands_op_tensor_layout_set_stride_nv },
    .{ .name = "OpTensorLayoutSliceNV", .opcode = 5375, .operands = &operands_op_tensor_layout_slice_nv },
    .{ .name = "OpTensorLayoutSetClampValueNV", .opcode = 5376, .operands = &operands_op_tensor_layout_set_clamp_value_nv },
    .{ .name = "OpCreateTensorViewNV", .opcode = 5377, .operands = &operands_op_create_tensor_view_nv },
    .{ .name = "OpTensorViewSetDimensionNV", .opcode = 5378, .operands = &operands_op_tensor_view_set_dimension_nv },
    .{ .name = "OpTensorViewSetStrideNV", .opcode = 5379, .operands = &operands_op_tensor_view_set_stride_nv },
    .{ .name = "OpDemoteToHelperInvocation", .opcode = 5380, .operands = &operands_op_demote_to_helper_invocation },
    .{ .name = "OpDemoteToHelperInvocationEXT", .opcode = 5380, .operands = &operands_op_demote_to_helper_invocation },
    .{ .name = "OpIsHelperInvocationEXT", .opcode = 5381, .operands = &operands_op_is_helper_invocation_ext },
    .{ .name = "OpTensorViewSetClipNV", .opcode = 5382, .operands = &operands_op_tensor_view_set_clip_nv },
    .{ .name = "OpTensorLayoutSetBlockSizeNV", .opcode = 5384, .operands = &operands_op_tensor_layout_set_block_size_nv },
    .{ .name = "OpCooperativeMatrixTransposeNV", .opcode = 5390, .operands = &operands_op_cooperative_matrix_transpose_nv },
    .{ .name = "OpConvertUToImageNV", .opcode = 5391, .operands = &operands_op_convert_u_to_image_nv },
    .{ .name = "OpConvertUToSamplerNV", .opcode = 5392, .operands = &operands_op_convert_u_to_sampler_nv },
    .{ .name = "OpConvertImageToUNV", .opcode = 5393, .operands = &operands_op_convert_image_to_unv },
    .{ .name = "OpConvertSamplerToUNV", .opcode = 5394, .operands = &operands_op_convert_sampler_to_unv },
    .{ .name = "OpConvertUToSampledImageNV", .opcode = 5395, .operands = &operands_op_convert_u_to_sampled_image_nv },
    .{ .name = "OpConvertSampledImageToUNV", .opcode = 5396, .operands = &operands_op_convert_sampled_image_to_unv },
    .{ .name = "OpSamplerImageAddressingModeNV", .opcode = 5397, .operands = &operands_op_sampler_image_addressing_mode_nv },
    .{ .name = "OpRawAccessChainNV", .opcode = 5398, .operands = &operands_op_raw_access_chain_nv },
    .{ .name = "OpRayQueryGetIntersectionSpherePositionNV", .opcode = 5427, .operands = &operands_op_ray_query_get_intersection_sphere_position_nv },
    .{ .name = "OpRayQueryGetIntersectionSphereRadiusNV", .opcode = 5428, .operands = &operands_op_ray_query_get_intersection_sphere_radius_nv },
    .{ .name = "OpRayQueryGetIntersectionLSSPositionsNV", .opcode = 5429, .operands = &operands_op_ray_query_get_intersection_lss_positions_nv },
    .{ .name = "OpRayQueryGetIntersectionLSSRadiiNV", .opcode = 5430, .operands = &operands_op_ray_query_get_intersection_lss_radii_nv },
    .{ .name = "OpRayQueryGetIntersectionLSSHitValueNV", .opcode = 5431, .operands = &operands_op_ray_query_get_intersection_lss_hit_value_nv },
    .{ .name = "OpHitObjectGetSpherePositionNV", .opcode = 5432, .operands = &operands_op_hit_object_get_sphere_position_nv },
    .{ .name = "OpHitObjectGetSphereRadiusNV", .opcode = 5433, .operands = &operands_op_hit_object_get_sphere_radius_nv },
    .{ .name = "OpHitObjectGetLSSPositionsNV", .opcode = 5434, .operands = &operands_op_hit_object_get_lss_positions_nv },
    .{ .name = "OpHitObjectGetLSSRadiiNV", .opcode = 5435, .operands = &operands_op_hit_object_get_lss_radii_nv },
    .{ .name = "OpHitObjectIsSphereHitNV", .opcode = 5436, .operands = &operands_op_hit_object_is_sphere_hit_nv },
    .{ .name = "OpHitObjectIsLSSHitNV", .opcode = 5437, .operands = &operands_op_hit_object_is_lss_hit_nv },
    .{ .name = "OpRayQueryIsSphereHitNV", .opcode = 5438, .operands = &operands_op_ray_query_is_sphere_hit_nv },
    .{ .name = "OpRayQueryIsLSSHitNV", .opcode = 5439, .operands = &operands_op_ray_query_is_lss_hit_nv },
    .{ .name = "OpSubgroupShuffleINTEL", .opcode = 5571, .operands = &operands_op_subgroup_shuffle_intel },
    .{ .name = "OpSubgroupShuffleDownINTEL", .opcode = 5572, .operands = &operands_op_subgroup_shuffle_down_intel },
    .{ .name = "OpSubgroupShuffleUpINTEL", .opcode = 5573, .operands = &operands_op_subgroup_shuffle_up_intel },
    .{ .name = "OpSubgroupShuffleXorINTEL", .opcode = 5574, .operands = &operands_op_subgroup_shuffle_xor_intel },
    .{ .name = "OpSubgroupBlockReadINTEL", .opcode = 5575, .operands = &operands_op_subgroup_block_read_intel },
    .{ .name = "OpSubgroupBlockWriteINTEL", .opcode = 5576, .operands = &operands_op_subgroup_block_write_intel },
    .{ .name = "OpSubgroupImageBlockReadINTEL", .opcode = 5577, .operands = &operands_op_subgroup_image_block_read_intel },
    .{ .name = "OpSubgroupImageBlockWriteINTEL", .opcode = 5578, .operands = &operands_op_subgroup_image_block_write_intel },
    .{ .name = "OpSubgroupImageMediaBlockReadINTEL", .opcode = 5580, .operands = &operands_op_subgroup_image_media_block_read_intel },
    .{ .name = "OpSubgroupImageMediaBlockWriteINTEL", .opcode = 5581, .operands = &operands_op_subgroup_image_media_block_write_intel },
    .{ .name = "OpUCountLeadingZerosINTEL", .opcode = 5585, .operands = &operands_op_u_count_leading_zeros_intel },
    .{ .name = "OpUCountTrailingZerosINTEL", .opcode = 5586, .operands = &operands_op_u_count_trailing_zeros_intel },
    .{ .name = "OpAbsISubINTEL", .opcode = 5587, .operands = &operands_op_abs_i_sub_intel },
    .{ .name = "OpAbsUSubINTEL", .opcode = 5588, .operands = &operands_op_abs_u_sub_intel },
    .{ .name = "OpIAddSatINTEL", .opcode = 5589, .operands = &operands_op_i_add_sat_intel },
    .{ .name = "OpUAddSatINTEL", .opcode = 5590, .operands = &operands_op_u_add_sat_intel },
    .{ .name = "OpIAverageINTEL", .opcode = 5591, .operands = &operands_op_i_average_intel },
    .{ .name = "OpUAverageINTEL", .opcode = 5592, .operands = &operands_op_u_average_intel },
    .{ .name = "OpIAverageRoundedINTEL", .opcode = 5593, .operands = &operands_op_i_average_rounded_intel },
    .{ .name = "OpUAverageRoundedINTEL", .opcode = 5594, .operands = &operands_op_u_average_rounded_intel },
    .{ .name = "OpISubSatINTEL", .opcode = 5595, .operands = &operands_op_i_sub_sat_intel },
    .{ .name = "OpUSubSatINTEL", .opcode = 5596, .operands = &operands_op_u_sub_sat_intel },
    .{ .name = "OpIMul32x16INTEL", .opcode = 5597, .operands = &operands_op_i_mul32x16_intel },
    .{ .name = "OpUMul32x16INTEL", .opcode = 5598, .operands = &operands_op_u_mul32x16_intel },
    .{ .name = "OpConstantFunctionPointerINTEL", .opcode = 5600, .operands = &operands_op_constant_function_pointer_intel },
    .{ .name = "OpFunctionPointerCallINTEL", .opcode = 5601, .operands = &operands_op_function_pointer_call_intel },
    .{ .name = "OpAsmTargetINTEL", .opcode = 5609, .operands = &operands_op_asm_target_intel },
    .{ .name = "OpAsmINTEL", .opcode = 5610, .operands = &operands_op_asm_intel },
    .{ .name = "OpAsmCallINTEL", .opcode = 5611, .operands = &operands_op_asm_call_intel },
    .{ .name = "OpAtomicFMinEXT", .opcode = 5614, .operands = &operands_op_atomic_f_min_ext },
    .{ .name = "OpAtomicFMaxEXT", .opcode = 5615, .operands = &operands_op_atomic_f_max_ext },
    .{ .name = "OpAssumeTrueKHR", .opcode = 5630, .operands = &operands_op_assume_true_khr },
    .{ .name = "OpExpectKHR", .opcode = 5631, .operands = &operands_op_expect_khr },
    .{ .name = "OpDecorateString", .opcode = 5632, .operands = &operands_op_decorate_string },
    .{ .name = "OpDecorateStringGOOGLE", .opcode = 5632, .operands = &operands_op_decorate_string },
    .{ .name = "OpMemberDecorateString", .opcode = 5633, .operands = &operands_op_member_decorate_string },
    .{ .name = "OpMemberDecorateStringGOOGLE", .opcode = 5633, .operands = &operands_op_member_decorate_string },
    .{ .name = "OpVmeImageINTEL", .opcode = 5699, .operands = &operands_op_vme_image_intel },
    .{ .name = "OpTypeVmeImageINTEL", .opcode = 5700, .operands = &operands_op_type_vme_image_intel },
    .{ .name = "OpTypeAvcImePayloadINTEL", .opcode = 5701, .operands = &operands_op_type_avc_ime_payload_intel },
    .{ .name = "OpTypeAvcRefPayloadINTEL", .opcode = 5702, .operands = &operands_op_type_avc_ref_payload_intel },
    .{ .name = "OpTypeAvcSicPayloadINTEL", .opcode = 5703, .operands = &operands_op_type_avc_sic_payload_intel },
    .{ .name = "OpTypeAvcMcePayloadINTEL", .opcode = 5704, .operands = &operands_op_type_avc_mce_payload_intel },
    .{ .name = "OpTypeAvcMceResultINTEL", .opcode = 5705, .operands = &operands_op_type_avc_mce_result_intel },
    .{ .name = "OpTypeAvcImeResultINTEL", .opcode = 5706, .operands = &operands_op_type_avc_ime_result_intel },
    .{ .name = "OpTypeAvcImeResultSingleReferenceStreamoutINTEL", .opcode = 5707, .operands = &operands_op_type_avc_ime_result_single_reference_streamout_intel },
    .{ .name = "OpTypeAvcImeResultDualReferenceStreamoutINTEL", .opcode = 5708, .operands = &operands_op_type_avc_ime_result_dual_reference_streamout_intel },
    .{ .name = "OpTypeAvcImeSingleReferenceStreaminINTEL", .opcode = 5709, .operands = &operands_op_type_avc_ime_single_reference_streamin_intel },
    .{ .name = "OpTypeAvcImeDualReferenceStreaminINTEL", .opcode = 5710, .operands = &operands_op_type_avc_ime_dual_reference_streamin_intel },
    .{ .name = "OpTypeAvcRefResultINTEL", .opcode = 5711, .operands = &operands_op_type_avc_ref_result_intel },
    .{ .name = "OpTypeAvcSicResultINTEL", .opcode = 5712, .operands = &operands_op_type_avc_sic_result_intel },
    .{ .name = "OpSubgroupAvcMceGetDefaultInterBaseMultiReferencePenaltyINTEL", .opcode = 5713, .operands = &operands_op_subgroup_avc_mce_get_default_inter_base_multi_reference_penalty_intel },
    .{ .name = "OpSubgroupAvcMceSetInterBaseMultiReferencePenaltyINTEL", .opcode = 5714, .operands = &operands_op_subgroup_avc_mce_set_inter_base_multi_reference_penalty_intel },
    .{ .name = "OpSubgroupAvcMceGetDefaultInterShapePenaltyINTEL", .opcode = 5715, .operands = &operands_op_subgroup_avc_mce_get_default_inter_shape_penalty_intel },
    .{ .name = "OpSubgroupAvcMceSetInterShapePenaltyINTEL", .opcode = 5716, .operands = &operands_op_subgroup_avc_mce_set_inter_shape_penalty_intel },
    .{ .name = "OpSubgroupAvcMceGetDefaultInterDirectionPenaltyINTEL", .opcode = 5717, .operands = &operands_op_subgroup_avc_mce_get_default_inter_direction_penalty_intel },
    .{ .name = "OpSubgroupAvcMceSetInterDirectionPenaltyINTEL", .opcode = 5718, .operands = &operands_op_subgroup_avc_mce_set_inter_direction_penalty_intel },
    .{ .name = "OpSubgroupAvcMceGetDefaultIntraLumaShapePenaltyINTEL", .opcode = 5719, .operands = &operands_op_subgroup_avc_mce_get_default_intra_luma_shape_penalty_intel },
    .{ .name = "OpSubgroupAvcMceGetDefaultInterMotionVectorCostTableINTEL", .opcode = 5720, .operands = &operands_op_subgroup_avc_mce_get_default_inter_motion_vector_cost_table_intel },
    .{ .name = "OpSubgroupAvcMceGetDefaultHighPenaltyCostTableINTEL", .opcode = 5721, .operands = &operands_op_subgroup_avc_mce_get_default_high_penalty_cost_table_intel },
    .{ .name = "OpSubgroupAvcMceGetDefaultMediumPenaltyCostTableINTEL", .opcode = 5722, .operands = &operands_op_subgroup_avc_mce_get_default_medium_penalty_cost_table_intel },
    .{ .name = "OpSubgroupAvcMceGetDefaultLowPenaltyCostTableINTEL", .opcode = 5723, .operands = &operands_op_subgroup_avc_mce_get_default_low_penalty_cost_table_intel },
    .{ .name = "OpSubgroupAvcMceSetMotionVectorCostFunctionINTEL", .opcode = 5724, .operands = &operands_op_subgroup_avc_mce_set_motion_vector_cost_function_intel },
    .{ .name = "OpSubgroupAvcMceGetDefaultIntraLumaModePenaltyINTEL", .opcode = 5725, .operands = &operands_op_subgroup_avc_mce_get_default_intra_luma_mode_penalty_intel },
    .{ .name = "OpSubgroupAvcMceGetDefaultNonDcLumaIntraPenaltyINTEL", .opcode = 5726, .operands = &operands_op_subgroup_avc_mce_get_default_non_dc_luma_intra_penalty_intel },
    .{ .name = "OpSubgroupAvcMceGetDefaultIntraChromaModeBasePenaltyINTEL", .opcode = 5727, .operands = &operands_op_subgroup_avc_mce_get_default_intra_chroma_mode_base_penalty_intel },
    .{ .name = "OpSubgroupAvcMceSetAcOnlyHaarINTEL", .opcode = 5728, .operands = &operands_op_subgroup_avc_mce_set_ac_only_haar_intel },
    .{ .name = "OpSubgroupAvcMceSetSourceInterlacedFieldPolarityINTEL", .opcode = 5729, .operands = &operands_op_subgroup_avc_mce_set_source_interlaced_field_polarity_intel },
    .{ .name = "OpSubgroupAvcMceSetSingleReferenceInterlacedFieldPolarityINTEL", .opcode = 5730, .operands = &operands_op_subgroup_avc_mce_set_single_reference_interlaced_field_polarity_intel },
    .{ .name = "OpSubgroupAvcMceSetDualReferenceInterlacedFieldPolaritiesINTEL", .opcode = 5731, .operands = &operands_op_subgroup_avc_mce_set_dual_reference_interlaced_field_polarities_intel },
    .{ .name = "OpSubgroupAvcMceConvertToImePayloadINTEL", .opcode = 5732, .operands = &operands_op_subgroup_avc_mce_convert_to_ime_payload_intel },
    .{ .name = "OpSubgroupAvcMceConvertToImeResultINTEL", .opcode = 5733, .operands = &operands_op_subgroup_avc_mce_convert_to_ime_result_intel },
    .{ .name = "OpSubgroupAvcMceConvertToRefPayloadINTEL", .opcode = 5734, .operands = &operands_op_subgroup_avc_mce_convert_to_ref_payload_intel },
    .{ .name = "OpSubgroupAvcMceConvertToRefResultINTEL", .opcode = 5735, .operands = &operands_op_subgroup_avc_mce_convert_to_ref_result_intel },
    .{ .name = "OpSubgroupAvcMceConvertToSicPayloadINTEL", .opcode = 5736, .operands = &operands_op_subgroup_avc_mce_convert_to_sic_payload_intel },
    .{ .name = "OpSubgroupAvcMceConvertToSicResultINTEL", .opcode = 5737, .operands = &operands_op_subgroup_avc_mce_convert_to_sic_result_intel },
    .{ .name = "OpSubgroupAvcMceGetMotionVectorsINTEL", .opcode = 5738, .operands = &operands_op_subgroup_avc_mce_get_motion_vectors_intel },
    .{ .name = "OpSubgroupAvcMceGetInterDistortionsINTEL", .opcode = 5739, .operands = &operands_op_subgroup_avc_mce_get_inter_distortions_intel },
    .{ .name = "OpSubgroupAvcMceGetBestInterDistortionsINTEL", .opcode = 5740, .operands = &operands_op_subgroup_avc_mce_get_best_inter_distortions_intel },
    .{ .name = "OpSubgroupAvcMceGetInterMajorShapeINTEL", .opcode = 5741, .operands = &operands_op_subgroup_avc_mce_get_inter_major_shape_intel },
    .{ .name = "OpSubgroupAvcMceGetInterMinorShapeINTEL", .opcode = 5742, .operands = &operands_op_subgroup_avc_mce_get_inter_minor_shape_intel },
    .{ .name = "OpSubgroupAvcMceGetInterDirectionsINTEL", .opcode = 5743, .operands = &operands_op_subgroup_avc_mce_get_inter_directions_intel },
    .{ .name = "OpSubgroupAvcMceGetInterMotionVectorCountINTEL", .opcode = 5744, .operands = &operands_op_subgroup_avc_mce_get_inter_motion_vector_count_intel },
    .{ .name = "OpSubgroupAvcMceGetInterReferenceIdsINTEL", .opcode = 5745, .operands = &operands_op_subgroup_avc_mce_get_inter_reference_ids_intel },
    .{ .name = "OpSubgroupAvcMceGetInterReferenceInterlacedFieldPolaritiesINTEL", .opcode = 5746, .operands = &operands_op_subgroup_avc_mce_get_inter_reference_interlaced_field_polarities_intel },
    .{ .name = "OpSubgroupAvcImeInitializeINTEL", .opcode = 5747, .operands = &operands_op_subgroup_avc_ime_initialize_intel },
    .{ .name = "OpSubgroupAvcImeSetSingleReferenceINTEL", .opcode = 5748, .operands = &operands_op_subgroup_avc_ime_set_single_reference_intel },
    .{ .name = "OpSubgroupAvcImeSetDualReferenceINTEL", .opcode = 5749, .operands = &operands_op_subgroup_avc_ime_set_dual_reference_intel },
    .{ .name = "OpSubgroupAvcImeRefWindowSizeINTEL", .opcode = 5750, .operands = &operands_op_subgroup_avc_ime_ref_window_size_intel },
    .{ .name = "OpSubgroupAvcImeAdjustRefOffsetINTEL", .opcode = 5751, .operands = &operands_op_subgroup_avc_ime_adjust_ref_offset_intel },
    .{ .name = "OpSubgroupAvcImeConvertToMcePayloadINTEL", .opcode = 5752, .operands = &operands_op_subgroup_avc_ime_convert_to_mce_payload_intel },
    .{ .name = "OpSubgroupAvcImeSetMaxMotionVectorCountINTEL", .opcode = 5753, .operands = &operands_op_subgroup_avc_ime_set_max_motion_vector_count_intel },
    .{ .name = "OpSubgroupAvcImeSetUnidirectionalMixDisableINTEL", .opcode = 5754, .operands = &operands_op_subgroup_avc_ime_set_unidirectional_mix_disable_intel },
    .{ .name = "OpSubgroupAvcImeSetEarlySearchTerminationThresholdINTEL", .opcode = 5755, .operands = &operands_op_subgroup_avc_ime_set_early_search_termination_threshold_intel },
    .{ .name = "OpSubgroupAvcImeSetWeightedSadINTEL", .opcode = 5756, .operands = &operands_op_subgroup_avc_ime_set_weighted_sad_intel },
    .{ .name = "OpSubgroupAvcImeEvaluateWithSingleReferenceINTEL", .opcode = 5757, .operands = &operands_op_subgroup_avc_ime_evaluate_with_single_reference_intel },
    .{ .name = "OpSubgroupAvcImeEvaluateWithDualReferenceINTEL", .opcode = 5758, .operands = &operands_op_subgroup_avc_ime_evaluate_with_dual_reference_intel },
    .{ .name = "OpSubgroupAvcImeEvaluateWithSingleReferenceStreaminINTEL", .opcode = 5759, .operands = &operands_op_subgroup_avc_ime_evaluate_with_single_reference_streamin_intel },
    .{ .name = "OpSubgroupAvcImeEvaluateWithDualReferenceStreaminINTEL", .opcode = 5760, .operands = &operands_op_subgroup_avc_ime_evaluate_with_dual_reference_streamin_intel },
    .{ .name = "OpSubgroupAvcImeEvaluateWithSingleReferenceStreamoutINTEL", .opcode = 5761, .operands = &operands_op_subgroup_avc_ime_evaluate_with_single_reference_streamout_intel },
    .{ .name = "OpSubgroupAvcImeEvaluateWithDualReferenceStreamoutINTEL", .opcode = 5762, .operands = &operands_op_subgroup_avc_ime_evaluate_with_dual_reference_streamout_intel },
    .{ .name = "OpSubgroupAvcImeEvaluateWithSingleReferenceStreaminoutINTEL", .opcode = 5763, .operands = &operands_op_subgroup_avc_ime_evaluate_with_single_reference_streaminout_intel },
    .{ .name = "OpSubgroupAvcImeEvaluateWithDualReferenceStreaminoutINTEL", .opcode = 5764, .operands = &operands_op_subgroup_avc_ime_evaluate_with_dual_reference_streaminout_intel },
    .{ .name = "OpSubgroupAvcImeConvertToMceResultINTEL", .opcode = 5765, .operands = &operands_op_subgroup_avc_ime_convert_to_mce_result_intel },
    .{ .name = "OpSubgroupAvcImeGetSingleReferenceStreaminINTEL", .opcode = 5766, .operands = &operands_op_subgroup_avc_ime_get_single_reference_streamin_intel },
    .{ .name = "OpSubgroupAvcImeGetDualReferenceStreaminINTEL", .opcode = 5767, .operands = &operands_op_subgroup_avc_ime_get_dual_reference_streamin_intel },
    .{ .name = "OpSubgroupAvcImeStripSingleReferenceStreamoutINTEL", .opcode = 5768, .operands = &operands_op_subgroup_avc_ime_strip_single_reference_streamout_intel },
    .{ .name = "OpSubgroupAvcImeStripDualReferenceStreamoutINTEL", .opcode = 5769, .operands = &operands_op_subgroup_avc_ime_strip_dual_reference_streamout_intel },
    .{ .name = "OpSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeMotionVectorsINTEL", .opcode = 5770, .operands = &operands_op_subgroup_avc_ime_get_streamout_single_reference_major_shape_motion_vectors_intel },
    .{ .name = "OpSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeDistortionsINTEL", .opcode = 5771, .operands = &operands_op_subgroup_avc_ime_get_streamout_single_reference_major_shape_distortions_intel },
    .{ .name = "OpSubgroupAvcImeGetStreamoutSingleReferenceMajorShapeReferenceIdsINTEL", .opcode = 5772, .operands = &operands_op_subgroup_avc_ime_get_streamout_single_reference_major_shape_reference_ids_intel },
    .{ .name = "OpSubgroupAvcImeGetStreamoutDualReferenceMajorShapeMotionVectorsINTEL", .opcode = 5773, .operands = &operands_op_subgroup_avc_ime_get_streamout_dual_reference_major_shape_motion_vectors_intel },
    .{ .name = "OpSubgroupAvcImeGetStreamoutDualReferenceMajorShapeDistortionsINTEL", .opcode = 5774, .operands = &operands_op_subgroup_avc_ime_get_streamout_dual_reference_major_shape_distortions_intel },
    .{ .name = "OpSubgroupAvcImeGetStreamoutDualReferenceMajorShapeReferenceIdsINTEL", .opcode = 5775, .operands = &operands_op_subgroup_avc_ime_get_streamout_dual_reference_major_shape_reference_ids_intel },
    .{ .name = "OpSubgroupAvcImeGetBorderReachedINTEL", .opcode = 5776, .operands = &operands_op_subgroup_avc_ime_get_border_reached_intel },
    .{ .name = "OpSubgroupAvcImeGetTruncatedSearchIndicationINTEL", .opcode = 5777, .operands = &operands_op_subgroup_avc_ime_get_truncated_search_indication_intel },
    .{ .name = "OpSubgroupAvcImeGetUnidirectionalEarlySearchTerminationINTEL", .opcode = 5778, .operands = &operands_op_subgroup_avc_ime_get_unidirectional_early_search_termination_intel },
    .{ .name = "OpSubgroupAvcImeGetWeightingPatternMinimumMotionVectorINTEL", .opcode = 5779, .operands = &operands_op_subgroup_avc_ime_get_weighting_pattern_minimum_motion_vector_intel },
    .{ .name = "OpSubgroupAvcImeGetWeightingPatternMinimumDistortionINTEL", .opcode = 5780, .operands = &operands_op_subgroup_avc_ime_get_weighting_pattern_minimum_distortion_intel },
    .{ .name = "OpSubgroupAvcFmeInitializeINTEL", .opcode = 5781, .operands = &operands_op_subgroup_avc_fme_initialize_intel },
    .{ .name = "OpSubgroupAvcBmeInitializeINTEL", .opcode = 5782, .operands = &operands_op_subgroup_avc_bme_initialize_intel },
    .{ .name = "OpSubgroupAvcRefConvertToMcePayloadINTEL", .opcode = 5783, .operands = &operands_op_subgroup_avc_ref_convert_to_mce_payload_intel },
    .{ .name = "OpSubgroupAvcRefSetBidirectionalMixDisableINTEL", .opcode = 5784, .operands = &operands_op_subgroup_avc_ref_set_bidirectional_mix_disable_intel },
    .{ .name = "OpSubgroupAvcRefSetBilinearFilterEnableINTEL", .opcode = 5785, .operands = &operands_op_subgroup_avc_ref_set_bilinear_filter_enable_intel },
    .{ .name = "OpSubgroupAvcRefEvaluateWithSingleReferenceINTEL", .opcode = 5786, .operands = &operands_op_subgroup_avc_ref_evaluate_with_single_reference_intel },
    .{ .name = "OpSubgroupAvcRefEvaluateWithDualReferenceINTEL", .opcode = 5787, .operands = &operands_op_subgroup_avc_ref_evaluate_with_dual_reference_intel },
    .{ .name = "OpSubgroupAvcRefEvaluateWithMultiReferenceINTEL", .opcode = 5788, .operands = &operands_op_subgroup_avc_ref_evaluate_with_multi_reference_intel },
    .{ .name = "OpSubgroupAvcRefEvaluateWithMultiReferenceInterlacedINTEL", .opcode = 5789, .operands = &operands_op_subgroup_avc_ref_evaluate_with_multi_reference_interlaced_intel },
    .{ .name = "OpSubgroupAvcRefConvertToMceResultINTEL", .opcode = 5790, .operands = &operands_op_subgroup_avc_ref_convert_to_mce_result_intel },
    .{ .name = "OpSubgroupAvcSicInitializeINTEL", .opcode = 5791, .operands = &operands_op_subgroup_avc_sic_initialize_intel },
    .{ .name = "OpSubgroupAvcSicConfigureSkcINTEL", .opcode = 5792, .operands = &operands_op_subgroup_avc_sic_configure_skc_intel },
    .{ .name = "OpSubgroupAvcSicConfigureIpeLumaINTEL", .opcode = 5793, .operands = &operands_op_subgroup_avc_sic_configure_ipe_luma_intel },
    .{ .name = "OpSubgroupAvcSicConfigureIpeLumaChromaINTEL", .opcode = 5794, .operands = &operands_op_subgroup_avc_sic_configure_ipe_luma_chroma_intel },
    .{ .name = "OpSubgroupAvcSicGetMotionVectorMaskINTEL", .opcode = 5795, .operands = &operands_op_subgroup_avc_sic_get_motion_vector_mask_intel },
    .{ .name = "OpSubgroupAvcSicConvertToMcePayloadINTEL", .opcode = 5796, .operands = &operands_op_subgroup_avc_sic_convert_to_mce_payload_intel },
    .{ .name = "OpSubgroupAvcSicSetIntraLumaShapePenaltyINTEL", .opcode = 5797, .operands = &operands_op_subgroup_avc_sic_set_intra_luma_shape_penalty_intel },
    .{ .name = "OpSubgroupAvcSicSetIntraLumaModeCostFunctionINTEL", .opcode = 5798, .operands = &operands_op_subgroup_avc_sic_set_intra_luma_mode_cost_function_intel },
    .{ .name = "OpSubgroupAvcSicSetIntraChromaModeCostFunctionINTEL", .opcode = 5799, .operands = &operands_op_subgroup_avc_sic_set_intra_chroma_mode_cost_function_intel },
    .{ .name = "OpSubgroupAvcSicSetBilinearFilterEnableINTEL", .opcode = 5800, .operands = &operands_op_subgroup_avc_sic_set_bilinear_filter_enable_intel },
    .{ .name = "OpSubgroupAvcSicSetSkcForwardTransformEnableINTEL", .opcode = 5801, .operands = &operands_op_subgroup_avc_sic_set_skc_forward_transform_enable_intel },
    .{ .name = "OpSubgroupAvcSicSetBlockBasedRawSkipSadINTEL", .opcode = 5802, .operands = &operands_op_subgroup_avc_sic_set_block_based_raw_skip_sad_intel },
    .{ .name = "OpSubgroupAvcSicEvaluateIpeINTEL", .opcode = 5803, .operands = &operands_op_subgroup_avc_sic_evaluate_ipe_intel },
    .{ .name = "OpSubgroupAvcSicEvaluateWithSingleReferenceINTEL", .opcode = 5804, .operands = &operands_op_subgroup_avc_sic_evaluate_with_single_reference_intel },
    .{ .name = "OpSubgroupAvcSicEvaluateWithDualReferenceINTEL", .opcode = 5805, .operands = &operands_op_subgroup_avc_sic_evaluate_with_dual_reference_intel },
    .{ .name = "OpSubgroupAvcSicEvaluateWithMultiReferenceINTEL", .opcode = 5806, .operands = &operands_op_subgroup_avc_sic_evaluate_with_multi_reference_intel },
    .{ .name = "OpSubgroupAvcSicEvaluateWithMultiReferenceInterlacedINTEL", .opcode = 5807, .operands = &operands_op_subgroup_avc_sic_evaluate_with_multi_reference_interlaced_intel },
    .{ .name = "OpSubgroupAvcSicConvertToMceResultINTEL", .opcode = 5808, .operands = &operands_op_subgroup_avc_sic_convert_to_mce_result_intel },
    .{ .name = "OpSubgroupAvcSicGetIpeLumaShapeINTEL", .opcode = 5809, .operands = &operands_op_subgroup_avc_sic_get_ipe_luma_shape_intel },
    .{ .name = "OpSubgroupAvcSicGetBestIpeLumaDistortionINTEL", .opcode = 5810, .operands = &operands_op_subgroup_avc_sic_get_best_ipe_luma_distortion_intel },
    .{ .name = "OpSubgroupAvcSicGetBestIpeChromaDistortionINTEL", .opcode = 5811, .operands = &operands_op_subgroup_avc_sic_get_best_ipe_chroma_distortion_intel },
    .{ .name = "OpSubgroupAvcSicGetPackedIpeLumaModesINTEL", .opcode = 5812, .operands = &operands_op_subgroup_avc_sic_get_packed_ipe_luma_modes_intel },
    .{ .name = "OpSubgroupAvcSicGetIpeChromaModeINTEL", .opcode = 5813, .operands = &operands_op_subgroup_avc_sic_get_ipe_chroma_mode_intel },
    .{ .name = "OpSubgroupAvcSicGetPackedSkcLumaCountThresholdINTEL", .opcode = 5814, .operands = &operands_op_subgroup_avc_sic_get_packed_skc_luma_count_threshold_intel },
    .{ .name = "OpSubgroupAvcSicGetPackedSkcLumaSumThresholdINTEL", .opcode = 5815, .operands = &operands_op_subgroup_avc_sic_get_packed_skc_luma_sum_threshold_intel },
    .{ .name = "OpSubgroupAvcSicGetInterRawSadsINTEL", .opcode = 5816, .operands = &operands_op_subgroup_avc_sic_get_inter_raw_sads_intel },
    .{ .name = "OpVariableLengthArrayINTEL", .opcode = 5818, .operands = &operands_op_variable_length_array_intel },
    .{ .name = "OpSaveMemoryINTEL", .opcode = 5819, .operands = &operands_op_save_memory_intel },
    .{ .name = "OpRestoreMemoryINTEL", .opcode = 5820, .operands = &operands_op_restore_memory_intel },
    .{ .name = "OpArbitraryFloatSinCosPiALTERA", .opcode = 5840, .operands = &operands_op_arbitrary_float_sin_cos_pi_altera },
    .{ .name = "OpArbitraryFloatSinCosPiINTEL", .opcode = 5840, .operands = &operands_op_arbitrary_float_sin_cos_pi_altera },
    .{ .name = "OpArbitraryFloatCastALTERA", .opcode = 5841, .operands = &operands_op_arbitrary_float_cast_altera },
    .{ .name = "OpArbitraryFloatCastINTEL", .opcode = 5841, .operands = &operands_op_arbitrary_float_cast_altera },
    .{ .name = "OpArbitraryFloatCastFromIntALTERA", .opcode = 5842, .operands = &operands_op_arbitrary_float_cast_from_int_altera },
    .{ .name = "OpArbitraryFloatCastFromIntINTEL", .opcode = 5842, .operands = &operands_op_arbitrary_float_cast_from_int_altera },
    .{ .name = "OpArbitraryFloatCastToIntALTERA", .opcode = 5843, .operands = &operands_op_arbitrary_float_cast_to_int_altera },
    .{ .name = "OpArbitraryFloatCastToIntINTEL", .opcode = 5843, .operands = &operands_op_arbitrary_float_cast_to_int_altera },
    .{ .name = "OpArbitraryFloatAddALTERA", .opcode = 5846, .operands = &operands_op_arbitrary_float_add_altera },
    .{ .name = "OpArbitraryFloatAddINTEL", .opcode = 5846, .operands = &operands_op_arbitrary_float_add_altera },
    .{ .name = "OpArbitraryFloatSubALTERA", .opcode = 5847, .operands = &operands_op_arbitrary_float_sub_altera },
    .{ .name = "OpArbitraryFloatSubINTEL", .opcode = 5847, .operands = &operands_op_arbitrary_float_sub_altera },
    .{ .name = "OpArbitraryFloatMulALTERA", .opcode = 5848, .operands = &operands_op_arbitrary_float_mul_altera },
    .{ .name = "OpArbitraryFloatMulINTEL", .opcode = 5848, .operands = &operands_op_arbitrary_float_mul_altera },
    .{ .name = "OpArbitraryFloatDivALTERA", .opcode = 5849, .operands = &operands_op_arbitrary_float_div_altera },
    .{ .name = "OpArbitraryFloatDivINTEL", .opcode = 5849, .operands = &operands_op_arbitrary_float_div_altera },
    .{ .name = "OpArbitraryFloatGTALTERA", .opcode = 5850, .operands = &operands_op_arbitrary_float_gtaltera },
    .{ .name = "OpArbitraryFloatGTINTEL", .opcode = 5850, .operands = &operands_op_arbitrary_float_gtaltera },
    .{ .name = "OpArbitraryFloatGEALTERA", .opcode = 5851, .operands = &operands_op_arbitrary_float_gealtera },
    .{ .name = "OpArbitraryFloatGEINTEL", .opcode = 5851, .operands = &operands_op_arbitrary_float_gealtera },
    .{ .name = "OpArbitraryFloatLTALTERA", .opcode = 5852, .operands = &operands_op_arbitrary_float_ltaltera },
    .{ .name = "OpArbitraryFloatLTINTEL", .opcode = 5852, .operands = &operands_op_arbitrary_float_ltaltera },
    .{ .name = "OpArbitraryFloatLEALTERA", .opcode = 5853, .operands = &operands_op_arbitrary_float_lealtera },
    .{ .name = "OpArbitraryFloatLEINTEL", .opcode = 5853, .operands = &operands_op_arbitrary_float_lealtera },
    .{ .name = "OpArbitraryFloatEQALTERA", .opcode = 5854, .operands = &operands_op_arbitrary_float_eqaltera },
    .{ .name = "OpArbitraryFloatEQINTEL", .opcode = 5854, .operands = &operands_op_arbitrary_float_eqaltera },
    .{ .name = "OpArbitraryFloatRecipALTERA", .opcode = 5855, .operands = &operands_op_arbitrary_float_recip_altera },
    .{ .name = "OpArbitraryFloatRecipINTEL", .opcode = 5855, .operands = &operands_op_arbitrary_float_recip_altera },
    .{ .name = "OpArbitraryFloatRSqrtALTERA", .opcode = 5856, .operands = &operands_op_arbitrary_float_r_sqrt_altera },
    .{ .name = "OpArbitraryFloatRSqrtINTEL", .opcode = 5856, .operands = &operands_op_arbitrary_float_r_sqrt_altera },
    .{ .name = "OpArbitraryFloatCbrtALTERA", .opcode = 5857, .operands = &operands_op_arbitrary_float_cbrt_altera },
    .{ .name = "OpArbitraryFloatCbrtINTEL", .opcode = 5857, .operands = &operands_op_arbitrary_float_cbrt_altera },
    .{ .name = "OpArbitraryFloatHypotALTERA", .opcode = 5858, .operands = &operands_op_arbitrary_float_hypot_altera },
    .{ .name = "OpArbitraryFloatHypotINTEL", .opcode = 5858, .operands = &operands_op_arbitrary_float_hypot_altera },
    .{ .name = "OpArbitraryFloatSqrtALTERA", .opcode = 5859, .operands = &operands_op_arbitrary_float_sqrt_altera },
    .{ .name = "OpArbitraryFloatSqrtINTEL", .opcode = 5859, .operands = &operands_op_arbitrary_float_sqrt_altera },
    .{ .name = "OpArbitraryFloatLogINTEL", .opcode = 5860, .operands = &operands_op_arbitrary_float_log_intel },
    .{ .name = "OpArbitraryFloatLog2INTEL", .opcode = 5861, .operands = &operands_op_arbitrary_float_log2_intel },
    .{ .name = "OpArbitraryFloatLog10INTEL", .opcode = 5862, .operands = &operands_op_arbitrary_float_log10_intel },
    .{ .name = "OpArbitraryFloatLog1pINTEL", .opcode = 5863, .operands = &operands_op_arbitrary_float_log1p_intel },
    .{ .name = "OpArbitraryFloatExpINTEL", .opcode = 5864, .operands = &operands_op_arbitrary_float_exp_intel },
    .{ .name = "OpArbitraryFloatExp2INTEL", .opcode = 5865, .operands = &operands_op_arbitrary_float_exp2_intel },
    .{ .name = "OpArbitraryFloatExp10INTEL", .opcode = 5866, .operands = &operands_op_arbitrary_float_exp10_intel },
    .{ .name = "OpArbitraryFloatExpm1INTEL", .opcode = 5867, .operands = &operands_op_arbitrary_float_expm1_intel },
    .{ .name = "OpArbitraryFloatSinINTEL", .opcode = 5868, .operands = &operands_op_arbitrary_float_sin_intel },
    .{ .name = "OpArbitraryFloatCosINTEL", .opcode = 5869, .operands = &operands_op_arbitrary_float_cos_intel },
    .{ .name = "OpArbitraryFloatSinCosINTEL", .opcode = 5870, .operands = &operands_op_arbitrary_float_sin_cos_intel },
    .{ .name = "OpArbitraryFloatSinPiINTEL", .opcode = 5871, .operands = &operands_op_arbitrary_float_sin_pi_intel },
    .{ .name = "OpArbitraryFloatCosPiINTEL", .opcode = 5872, .operands = &operands_op_arbitrary_float_cos_pi_intel },
    .{ .name = "OpArbitraryFloatASinINTEL", .opcode = 5873, .operands = &operands_op_arbitrary_float_a_sin_intel },
    .{ .name = "OpArbitraryFloatASinPiINTEL", .opcode = 5874, .operands = &operands_op_arbitrary_float_a_sin_pi_intel },
    .{ .name = "OpArbitraryFloatACosINTEL", .opcode = 5875, .operands = &operands_op_arbitrary_float_a_cos_intel },
    .{ .name = "OpArbitraryFloatACosPiINTEL", .opcode = 5876, .operands = &operands_op_arbitrary_float_a_cos_pi_intel },
    .{ .name = "OpArbitraryFloatATanINTEL", .opcode = 5877, .operands = &operands_op_arbitrary_float_a_tan_intel },
    .{ .name = "OpArbitraryFloatATanPiINTEL", .opcode = 5878, .operands = &operands_op_arbitrary_float_a_tan_pi_intel },
    .{ .name = "OpArbitraryFloatATan2INTEL", .opcode = 5879, .operands = &operands_op_arbitrary_float_a_tan2_intel },
    .{ .name = "OpArbitraryFloatPowINTEL", .opcode = 5880, .operands = &operands_op_arbitrary_float_pow_intel },
    .{ .name = "OpArbitraryFloatPowRINTEL", .opcode = 5881, .operands = &operands_op_arbitrary_float_pow_rintel },
    .{ .name = "OpArbitraryFloatPowNINTEL", .opcode = 5882, .operands = &operands_op_arbitrary_float_pow_nintel },
    .{ .name = "OpLoopControlINTEL", .opcode = 5887, .operands = &operands_op_loop_control_intel },
    .{ .name = "OpAliasDomainDeclINTEL", .opcode = 5911, .operands = &operands_op_alias_domain_decl_intel },
    .{ .name = "OpAliasScopeDeclINTEL", .opcode = 5912, .operands = &operands_op_alias_scope_decl_intel },
    .{ .name = "OpAliasScopeListDeclINTEL", .opcode = 5913, .operands = &operands_op_alias_scope_list_decl_intel },
    .{ .name = "OpFixedSqrtALTERA", .opcode = 5923, .operands = &operands_op_fixed_sqrt_altera },
    .{ .name = "OpFixedSqrtINTEL", .opcode = 5923, .operands = &operands_op_fixed_sqrt_altera },
    .{ .name = "OpFixedRecipALTERA", .opcode = 5924, .operands = &operands_op_fixed_recip_altera },
    .{ .name = "OpFixedRecipINTEL", .opcode = 5924, .operands = &operands_op_fixed_recip_altera },
    .{ .name = "OpFixedRsqrtALTERA", .opcode = 5925, .operands = &operands_op_fixed_rsqrt_altera },
    .{ .name = "OpFixedRsqrtINTEL", .opcode = 5925, .operands = &operands_op_fixed_rsqrt_altera },
    .{ .name = "OpFixedSinALTERA", .opcode = 5926, .operands = &operands_op_fixed_sin_altera },
    .{ .name = "OpFixedSinINTEL", .opcode = 5926, .operands = &operands_op_fixed_sin_altera },
    .{ .name = "OpFixedCosALTERA", .opcode = 5927, .operands = &operands_op_fixed_cos_altera },
    .{ .name = "OpFixedCosINTEL", .opcode = 5927, .operands = &operands_op_fixed_cos_altera },
    .{ .name = "OpFixedSinCosALTERA", .opcode = 5928, .operands = &operands_op_fixed_sin_cos_altera },
    .{ .name = "OpFixedSinCosINTEL", .opcode = 5928, .operands = &operands_op_fixed_sin_cos_altera },
    .{ .name = "OpFixedSinPiALTERA", .opcode = 5929, .operands = &operands_op_fixed_sin_pi_altera },
    .{ .name = "OpFixedSinPiINTEL", .opcode = 5929, .operands = &operands_op_fixed_sin_pi_altera },
    .{ .name = "OpFixedCosPiALTERA", .opcode = 5930, .operands = &operands_op_fixed_cos_pi_altera },
    .{ .name = "OpFixedCosPiINTEL", .opcode = 5930, .operands = &operands_op_fixed_cos_pi_altera },
    .{ .name = "OpFixedSinCosPiALTERA", .opcode = 5931, .operands = &operands_op_fixed_sin_cos_pi_altera },
    .{ .name = "OpFixedSinCosPiINTEL", .opcode = 5931, .operands = &operands_op_fixed_sin_cos_pi_altera },
    .{ .name = "OpFixedLogALTERA", .opcode = 5932, .operands = &operands_op_fixed_log_altera },
    .{ .name = "OpFixedLogINTEL", .opcode = 5932, .operands = &operands_op_fixed_log_altera },
    .{ .name = "OpFixedExpALTERA", .opcode = 5933, .operands = &operands_op_fixed_exp_altera },
    .{ .name = "OpFixedExpINTEL", .opcode = 5933, .operands = &operands_op_fixed_exp_altera },
    .{ .name = "OpPtrCastToCrossWorkgroupALTERA", .opcode = 5934, .operands = &operands_op_ptr_cast_to_cross_workgroup_altera },
    .{ .name = "OpPtrCastToCrossWorkgroupINTEL", .opcode = 5934, .operands = &operands_op_ptr_cast_to_cross_workgroup_altera },
    .{ .name = "OpCrossWorkgroupCastToPtrALTERA", .opcode = 5938, .operands = &operands_op_cross_workgroup_cast_to_ptr_altera },
    .{ .name = "OpCrossWorkgroupCastToPtrINTEL", .opcode = 5938, .operands = &operands_op_cross_workgroup_cast_to_ptr_altera },
    .{ .name = "OpReadPipeBlockingALTERA", .opcode = 5946, .operands = &operands_op_read_pipe_blocking_altera },
    .{ .name = "OpReadPipeBlockingINTEL", .opcode = 5946, .operands = &operands_op_read_pipe_blocking_altera },
    .{ .name = "OpWritePipeBlockingALTERA", .opcode = 5947, .operands = &operands_op_write_pipe_blocking_altera },
    .{ .name = "OpWritePipeBlockingINTEL", .opcode = 5947, .operands = &operands_op_write_pipe_blocking_altera },
    .{ .name = "OpFPGARegALTERA", .opcode = 5949, .operands = &operands_op_fpga_reg_altera },
    .{ .name = "OpFPGARegINTEL", .opcode = 5949, .operands = &operands_op_fpga_reg_altera },
    .{ .name = "OpRayQueryGetRayTMinKHR", .opcode = 6016, .operands = &operands_op_ray_query_get_ray_t_min_khr },
    .{ .name = "OpRayQueryGetRayFlagsKHR", .opcode = 6017, .operands = &operands_op_ray_query_get_ray_flags_khr },
    .{ .name = "OpRayQueryGetIntersectionTKHR", .opcode = 6018, .operands = &operands_op_ray_query_get_intersection_tkhr },
    .{ .name = "OpRayQueryGetIntersectionInstanceCustomIndexKHR", .opcode = 6019, .operands = &operands_op_ray_query_get_intersection_instance_custom_index_khr },
    .{ .name = "OpRayQueryGetIntersectionInstanceIdKHR", .opcode = 6020, .operands = &operands_op_ray_query_get_intersection_instance_id_khr },
    .{ .name = "OpRayQueryGetIntersectionInstanceShaderBindingTableRecordOffsetKHR", .opcode = 6021, .operands = &operands_op_ray_query_get_intersection_instance_shader_binding_table_record_offset_khr },
    .{ .name = "OpRayQueryGetIntersectionGeometryIndexKHR", .opcode = 6022, .operands = &operands_op_ray_query_get_intersection_geometry_index_khr },
    .{ .name = "OpRayQueryGetIntersectionPrimitiveIndexKHR", .opcode = 6023, .operands = &operands_op_ray_query_get_intersection_primitive_index_khr },
    .{ .name = "OpRayQueryGetIntersectionBarycentricsKHR", .opcode = 6024, .operands = &operands_op_ray_query_get_intersection_barycentrics_khr },
    .{ .name = "OpRayQueryGetIntersectionFrontFaceKHR", .opcode = 6025, .operands = &operands_op_ray_query_get_intersection_front_face_khr },
    .{ .name = "OpRayQueryGetIntersectionCandidateAABBOpaqueKHR", .opcode = 6026, .operands = &operands_op_ray_query_get_intersection_candidate_aabb_opaque_khr },
    .{ .name = "OpRayQueryGetIntersectionObjectRayDirectionKHR", .opcode = 6027, .operands = &operands_op_ray_query_get_intersection_object_ray_direction_khr },
    .{ .name = "OpRayQueryGetIntersectionObjectRayOriginKHR", .opcode = 6028, .operands = &operands_op_ray_query_get_intersection_object_ray_origin_khr },
    .{ .name = "OpRayQueryGetWorldRayDirectionKHR", .opcode = 6029, .operands = &operands_op_ray_query_get_world_ray_direction_khr },
    .{ .name = "OpRayQueryGetWorldRayOriginKHR", .opcode = 6030, .operands = &operands_op_ray_query_get_world_ray_origin_khr },
    .{ .name = "OpRayQueryGetIntersectionObjectToWorldKHR", .opcode = 6031, .operands = &operands_op_ray_query_get_intersection_object_to_world_khr },
    .{ .name = "OpRayQueryGetIntersectionWorldToObjectKHR", .opcode = 6032, .operands = &operands_op_ray_query_get_intersection_world_to_object_khr },
    .{ .name = "OpAtomicFAddEXT", .opcode = 6035, .operands = &operands_op_atomic_f_add_ext },
    .{ .name = "OpTypeBufferSurfaceINTEL", .opcode = 6086, .operands = &operands_op_type_buffer_surface_intel },
    .{ .name = "OpTypeStructContinuedINTEL", .opcode = 6090, .operands = &operands_op_type_struct_continued_intel },
    .{ .name = "OpConstantCompositeContinuedINTEL", .opcode = 6091, .operands = &operands_op_constant_composite_continued_intel },
    .{ .name = "OpSpecConstantCompositeContinuedINTEL", .opcode = 6092, .operands = &operands_op_spec_constant_composite_continued_intel },
    .{ .name = "OpCompositeConstructContinuedINTEL", .opcode = 6096, .operands = &operands_op_composite_construct_continued_intel },
    .{ .name = "OpConvertFToBF16INTEL", .opcode = 6116, .operands = &operands_op_convert_f_to_bf16_intel },
    .{ .name = "OpConvertBF16ToFINTEL", .opcode = 6117, .operands = &operands_op_convert_bf16_to_fintel },
    .{ .name = "OpControlBarrierArriveEXT", .opcode = 6142, .operands = &operands_op_control_barrier_arrive_ext },
    .{ .name = "OpControlBarrierArriveINTEL", .opcode = 6142, .operands = &operands_op_control_barrier_arrive_ext },
    .{ .name = "OpControlBarrierWaitEXT", .opcode = 6143, .operands = &operands_op_control_barrier_wait_ext },
    .{ .name = "OpControlBarrierWaitINTEL", .opcode = 6143, .operands = &operands_op_control_barrier_wait_ext },
    .{ .name = "OpArithmeticFenceEXT", .opcode = 6145, .operands = &operands_op_arithmetic_fence_ext },
    .{ .name = "OpTaskSequenceCreateALTERA", .opcode = 6163, .operands = &operands_op_task_sequence_create_altera },
    .{ .name = "OpTaskSequenceCreateINTEL", .opcode = 6163, .operands = &operands_op_task_sequence_create_altera },
    .{ .name = "OpTaskSequenceAsyncALTERA", .opcode = 6164, .operands = &operands_op_task_sequence_async_altera },
    .{ .name = "OpTaskSequenceAsyncINTEL", .opcode = 6164, .operands = &operands_op_task_sequence_async_altera },
    .{ .name = "OpTaskSequenceGetALTERA", .opcode = 6165, .operands = &operands_op_task_sequence_get_altera },
    .{ .name = "OpTaskSequenceGetINTEL", .opcode = 6165, .operands = &operands_op_task_sequence_get_altera },
    .{ .name = "OpTaskSequenceReleaseALTERA", .opcode = 6166, .operands = &operands_op_task_sequence_release_altera },
    .{ .name = "OpTaskSequenceReleaseINTEL", .opcode = 6166, .operands = &operands_op_task_sequence_release_altera },
    .{ .name = "OpTypeTaskSequenceALTERA", .opcode = 6199, .operands = &operands_op_type_task_sequence_altera },
    .{ .name = "OpTypeTaskSequenceINTEL", .opcode = 6199, .operands = &operands_op_type_task_sequence_altera },
    .{ .name = "OpSubgroupBlockPrefetchINTEL", .opcode = 6221, .operands = &operands_op_subgroup_block_prefetch_intel },
    .{ .name = "OpSubgroup2DBlockLoadINTEL", .opcode = 6231, .operands = &operands_op_subgroup2_d_block_load_intel },
    .{ .name = "OpSubgroup2DBlockLoadTransformINTEL", .opcode = 6232, .operands = &operands_op_subgroup2_d_block_load_transform_intel },
    .{ .name = "OpSubgroup2DBlockLoadTransposeINTEL", .opcode = 6233, .operands = &operands_op_subgroup2_d_block_load_transpose_intel },
    .{ .name = "OpSubgroup2DBlockPrefetchINTEL", .opcode = 6234, .operands = &operands_op_subgroup2_d_block_prefetch_intel },
    .{ .name = "OpSubgroup2DBlockStoreINTEL", .opcode = 6235, .operands = &operands_op_subgroup2_d_block_store_intel },
    .{ .name = "OpSubgroupMatrixMultiplyAccumulateINTEL", .opcode = 6237, .operands = &operands_op_subgroup_matrix_multiply_accumulate_intel },
    .{ .name = "OpBitwiseFunctionINTEL", .opcode = 6242, .operands = &operands_op_bitwise_function_intel },
    .{ .name = "OpUntypedVariableLengthArrayINTEL", .opcode = 6244, .operands = &operands_op_untyped_variable_length_array_intel },
    .{ .name = "OpConditionalExtensionINTEL", .opcode = 6248, .operands = &operands_op_conditional_extension_intel },
    .{ .name = "OpConditionalEntryPointINTEL", .opcode = 6249, .operands = &operands_op_conditional_entry_point_intel },
    .{ .name = "OpConditionalCapabilityINTEL", .opcode = 6250, .operands = &operands_op_conditional_capability_intel },
    .{ .name = "OpSpecConstantTargetINTEL", .opcode = 6251, .operands = &operands_op_spec_constant_target_intel },
    .{ .name = "OpSpecConstantArchitectureINTEL", .opcode = 6252, .operands = &operands_op_spec_constant_architecture_intel },
    .{ .name = "OpSpecConstantCapabilitiesINTEL", .opcode = 6253, .operands = &operands_op_spec_constant_capabilities_intel },
    .{ .name = "OpConditionalCopyObjectINTEL", .opcode = 6254, .operands = &operands_op_conditional_copy_object_intel },
    .{ .name = "OpPredicatedLoadINTEL", .opcode = 6258, .operands = &operands_op_predicated_load_intel },
    .{ .name = "OpPredicatedStoreINTEL", .opcode = 6259, .operands = &operands_op_predicated_store_intel },
    .{ .name = "OpGroupIMulKHR", .opcode = 6401, .operands = &operands_op_group_i_mul_khr },
    .{ .name = "OpGroupFMulKHR", .opcode = 6402, .operands = &operands_op_group_f_mul_khr },
    .{ .name = "OpGroupBitwiseAndKHR", .opcode = 6403, .operands = &operands_op_group_bitwise_and_khr },
    .{ .name = "OpGroupBitwiseOrKHR", .opcode = 6404, .operands = &operands_op_group_bitwise_or_khr },
    .{ .name = "OpGroupBitwiseXorKHR", .opcode = 6405, .operands = &operands_op_group_bitwise_xor_khr },
    .{ .name = "OpGroupLogicalAndKHR", .opcode = 6406, .operands = &operands_op_group_logical_and_khr },
    .{ .name = "OpGroupLogicalOrKHR", .opcode = 6407, .operands = &operands_op_group_logical_or_khr },
    .{ .name = "OpGroupLogicalXorKHR", .opcode = 6408, .operands = &operands_op_group_logical_xor_khr },
    .{ .name = "OpRoundFToTF32INTEL", .opcode = 6426, .operands = &operands_op_round_f_to_tf32_intel },
    .{ .name = "OpMaskedGatherINTEL", .opcode = 6428, .operands = &operands_op_masked_gather_intel },
    .{ .name = "OpMaskedScatterINTEL", .opcode = 6429, .operands = &operands_op_masked_scatter_intel },
    .{ .name = "OpConvertHandleToImageINTEL", .opcode = 6529, .operands = &operands_op_convert_handle_to_image_intel },
    .{ .name = "OpConvertHandleToSamplerINTEL", .opcode = 6530, .operands = &operands_op_convert_handle_to_sampler_intel },
    .{ .name = "OpConvertHandleToSampledImageINTEL", .opcode = 6531, .operands = &operands_op_convert_handle_to_sampled_image_intel },
    .{ .name = "OpFDot2MixAcc32VALVE", .opcode = 6916, .operands = &operands_op_f_dot2_mix_acc32_valve },
    .{ .name = "OpFDot2MixAcc16VALVE", .opcode = 6917, .operands = &operands_op_f_dot2_mix_acc16_valve },
    .{ .name = "OpFDot4MixAcc32VALVE", .opcode = 6918, .operands = &operands_op_f_dot4_mix_acc32_valve },
};

pub const enumerants = [_]EnumerantInfo{
    .{ .kind = .image_operands, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .image_operands, .name = "Bias", .value = 1, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .image_operands, .name = "Lod", .value = 2, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .image_operands, .name = "Grad", .value = 4, .parameters = &.{ .{ .kind = .id_ref, .quantifier = .one }, .{ .kind = .id_ref, .quantifier = .one } } },
    .{ .kind = .image_operands, .name = "ConstOffset", .value = 8, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .image_operands, .name = "Offset", .value = 16, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .image_operands, .name = "ConstOffsets", .value = 32, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .image_operands, .name = "Sample", .value = 64, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .image_operands, .name = "MinLod", .value = 128, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .image_operands, .name = "MakeTexelAvailable", .value = 256, .parameters = &.{.{ .kind = .id_scope, .quantifier = .one }} },
    .{ .kind = .image_operands, .name = "MakeTexelAvailableKHR", .value = 256, .parameters = &.{.{ .kind = .id_scope, .quantifier = .one }} },
    .{ .kind = .image_operands, .name = "MakeTexelVisible", .value = 512, .parameters = &.{.{ .kind = .id_scope, .quantifier = .one }} },
    .{ .kind = .image_operands, .name = "MakeTexelVisibleKHR", .value = 512, .parameters = &.{.{ .kind = .id_scope, .quantifier = .one }} },
    .{ .kind = .image_operands, .name = "NonPrivateTexel", .value = 1024, .parameters = &.{} },
    .{ .kind = .image_operands, .name = "NonPrivateTexelKHR", .value = 1024, .parameters = &.{} },
    .{ .kind = .image_operands, .name = "VolatileTexel", .value = 2048, .parameters = &.{} },
    .{ .kind = .image_operands, .name = "VolatileTexelKHR", .value = 2048, .parameters = &.{} },
    .{ .kind = .image_operands, .name = "SignExtend", .value = 4096, .parameters = &.{} },
    .{ .kind = .image_operands, .name = "ZeroExtend", .value = 8192, .parameters = &.{} },
    .{ .kind = .image_operands, .name = "Nontemporal", .value = 16384, .parameters = &.{} },
    .{ .kind = .image_operands, .name = "Offsets", .value = 65536, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .fp_fast_math_mode, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .fp_fast_math_mode, .name = "NotNaN", .value = 1, .parameters = &.{} },
    .{ .kind = .fp_fast_math_mode, .name = "NotInf", .value = 2, .parameters = &.{} },
    .{ .kind = .fp_fast_math_mode, .name = "NSZ", .value = 4, .parameters = &.{} },
    .{ .kind = .fp_fast_math_mode, .name = "AllowRecip", .value = 8, .parameters = &.{} },
    .{ .kind = .fp_fast_math_mode, .name = "Fast", .value = 16, .parameters = &.{} },
    .{ .kind = .fp_fast_math_mode, .name = "AllowContract", .value = 65536, .parameters = &.{} },
    .{ .kind = .fp_fast_math_mode, .name = "AllowContractFastINTEL", .value = 65536, .parameters = &.{} },
    .{ .kind = .fp_fast_math_mode, .name = "AllowReassoc", .value = 131072, .parameters = &.{} },
    .{ .kind = .fp_fast_math_mode, .name = "AllowReassocINTEL", .value = 131072, .parameters = &.{} },
    .{ .kind = .fp_fast_math_mode, .name = "AllowTransform", .value = 262144, .parameters = &.{} },
    .{ .kind = .selection_control, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .selection_control, .name = "Flatten", .value = 1, .parameters = &.{} },
    .{ .kind = .selection_control, .name = "DontFlatten", .value = 2, .parameters = &.{} },
    .{ .kind = .loop_control, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .loop_control, .name = "Unroll", .value = 1, .parameters = &.{} },
    .{ .kind = .loop_control, .name = "DontUnroll", .value = 2, .parameters = &.{} },
    .{ .kind = .loop_control, .name = "DependencyInfinite", .value = 4, .parameters = &.{} },
    .{ .kind = .loop_control, .name = "DependencyLength", .value = 8, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "MinIterations", .value = 16, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "MaxIterations", .value = 32, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "IterationMultiple", .value = 64, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "PeelCount", .value = 128, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "PartialCount", .value = 256, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "InitiationIntervalALTERA", .value = 65536, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "InitiationIntervalINTEL", .value = 65536, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "MaxConcurrencyALTERA", .value = 131072, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "MaxConcurrencyINTEL", .value = 131072, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "DependencyArrayALTERA", .value = 262144, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "DependencyArrayINTEL", .value = 262144, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "PipelineEnableALTERA", .value = 524288, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "PipelineEnableINTEL", .value = 524288, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "LoopCoalesceALTERA", .value = 1048576, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "LoopCoalesceINTEL", .value = 1048576, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "MaxInterleavingALTERA", .value = 2097152, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "MaxInterleavingINTEL", .value = 2097152, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "SpeculatedIterationsALTERA", .value = 4194304, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "SpeculatedIterationsINTEL", .value = 4194304, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "NoFusionALTERA", .value = 8388608, .parameters = &.{} },
    .{ .kind = .loop_control, .name = "NoFusionINTEL", .value = 8388608, .parameters = &.{} },
    .{ .kind = .loop_control, .name = "LoopCountALTERA", .value = 16777216, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "LoopCountINTEL", .value = 16777216, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "MaxReinvocationDelayALTERA", .value = 33554432, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "MaxReinvocationDelayINTEL", .value = 33554432, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .loop_control, .name = "MultipleWaitQueuesQCOM", .value = 268435456, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .function_control, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .function_control, .name = "Inline", .value = 1, .parameters = &.{} },
    .{ .kind = .function_control, .name = "DontInline", .value = 2, .parameters = &.{} },
    .{ .kind = .function_control, .name = "Pure", .value = 4, .parameters = &.{} },
    .{ .kind = .function_control, .name = "Const", .value = 8, .parameters = &.{} },
    .{ .kind = .function_control, .name = "OptNoneEXT", .value = 65536, .parameters = &.{} },
    .{ .kind = .function_control, .name = "OptNoneINTEL", .value = 65536, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "Relaxed", .value = 0, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "Acquire", .value = 2, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "Release", .value = 4, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "AcquireRelease", .value = 8, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "SequentiallyConsistent", .value = 16, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "UniformMemory", .value = 64, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "SubgroupMemory", .value = 128, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "WorkgroupMemory", .value = 256, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "CrossWorkgroupMemory", .value = 512, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "AtomicCounterMemory", .value = 1024, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "ImageMemory", .value = 2048, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "OutputMemory", .value = 4096, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "OutputMemoryKHR", .value = 4096, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "MakeAvailable", .value = 8192, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "MakeAvailableKHR", .value = 8192, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "MakeVisible", .value = 16384, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "MakeVisibleKHR", .value = 16384, .parameters = &.{} },
    .{ .kind = .memory_semantics, .name = "Volatile", .value = 32768, .parameters = &.{} },
    .{ .kind = .memory_access, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .memory_access, .name = "Volatile", .value = 1, .parameters = &.{} },
    .{ .kind = .memory_access, .name = "Aligned", .value = 2, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .memory_access, .name = "Nontemporal", .value = 4, .parameters = &.{} },
    .{ .kind = .memory_access, .name = "MakePointerAvailable", .value = 8, .parameters = &.{.{ .kind = .id_scope, .quantifier = .one }} },
    .{ .kind = .memory_access, .name = "MakePointerAvailableKHR", .value = 8, .parameters = &.{.{ .kind = .id_scope, .quantifier = .one }} },
    .{ .kind = .memory_access, .name = "MakePointerVisible", .value = 16, .parameters = &.{.{ .kind = .id_scope, .quantifier = .one }} },
    .{ .kind = .memory_access, .name = "MakePointerVisibleKHR", .value = 16, .parameters = &.{.{ .kind = .id_scope, .quantifier = .one }} },
    .{ .kind = .memory_access, .name = "NonPrivatePointer", .value = 32, .parameters = &.{} },
    .{ .kind = .memory_access, .name = "NonPrivatePointerKHR", .value = 32, .parameters = &.{} },
    .{ .kind = .memory_access, .name = "AliasScopeINTELMask", .value = 65536, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .memory_access, .name = "NoAliasINTELMask", .value = 131072, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .kernel_profiling_info, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .kernel_profiling_info, .name = "CmdExecTime", .value = 1, .parameters = &.{} },
    .{ .kind = .ray_flags, .name = "NoneKHR", .value = 0, .parameters = &.{} },
    .{ .kind = .ray_flags, .name = "OpaqueKHR", .value = 1, .parameters = &.{} },
    .{ .kind = .ray_flags, .name = "NoOpaqueKHR", .value = 2, .parameters = &.{} },
    .{ .kind = .ray_flags, .name = "TerminateOnFirstHitKHR", .value = 4, .parameters = &.{} },
    .{ .kind = .ray_flags, .name = "SkipClosestHitShaderKHR", .value = 8, .parameters = &.{} },
    .{ .kind = .ray_flags, .name = "CullBackFacingTrianglesKHR", .value = 16, .parameters = &.{} },
    .{ .kind = .ray_flags, .name = "CullFrontFacingTrianglesKHR", .value = 32, .parameters = &.{} },
    .{ .kind = .ray_flags, .name = "CullOpaqueKHR", .value = 64, .parameters = &.{} },
    .{ .kind = .ray_flags, .name = "CullNoOpaqueKHR", .value = 128, .parameters = &.{} },
    .{ .kind = .ray_flags, .name = "SkipTrianglesKHR", .value = 256, .parameters = &.{} },
    .{ .kind = .ray_flags, .name = "SkipBuiltinPrimitivesNV", .value = 256, .parameters = &.{} },
    .{ .kind = .ray_flags, .name = "SkipAABBsKHR", .value = 512, .parameters = &.{} },
    .{ .kind = .ray_flags, .name = "ForceOpacityMicromap2StateKHR", .value = 1024, .parameters = &.{} },
    .{ .kind = .ray_flags, .name = "ForceOpacityMicromap2StateEXT", .value = 1024, .parameters = &.{} },
    .{ .kind = .fragment_shading_rate, .name = "Vertical2Pixels", .value = 1, .parameters = &.{} },
    .{ .kind = .fragment_shading_rate, .name = "Vertical4Pixels", .value = 2, .parameters = &.{} },
    .{ .kind = .fragment_shading_rate, .name = "Horizontal2Pixels", .value = 4, .parameters = &.{} },
    .{ .kind = .fragment_shading_rate, .name = "Horizontal4Pixels", .value = 8, .parameters = &.{} },
    .{ .kind = .raw_access_chain_operands, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .raw_access_chain_operands, .name = "RobustnessPerComponentNV", .value = 1, .parameters = &.{} },
    .{ .kind = .raw_access_chain_operands, .name = "RobustnessPerElementNV", .value = 2, .parameters = &.{} },
    .{ .kind = .source_language, .name = "Unknown", .value = 0, .parameters = &.{} },
    .{ .kind = .source_language, .name = "ESSL", .value = 1, .parameters = &.{} },
    .{ .kind = .source_language, .name = "GLSL", .value = 2, .parameters = &.{} },
    .{ .kind = .source_language, .name = "OpenCL_C", .value = 3, .parameters = &.{} },
    .{ .kind = .source_language, .name = "OpenCL_CPP", .value = 4, .parameters = &.{} },
    .{ .kind = .source_language, .name = "HLSL", .value = 5, .parameters = &.{} },
    .{ .kind = .source_language, .name = "CPP_for_OpenCL", .value = 6, .parameters = &.{} },
    .{ .kind = .source_language, .name = "SYCL", .value = 7, .parameters = &.{} },
    .{ .kind = .source_language, .name = "HERO_C", .value = 8, .parameters = &.{} },
    .{ .kind = .source_language, .name = "NZSL", .value = 9, .parameters = &.{} },
    .{ .kind = .source_language, .name = "WGSL", .value = 10, .parameters = &.{} },
    .{ .kind = .source_language, .name = "Slang", .value = 11, .parameters = &.{} },
    .{ .kind = .source_language, .name = "Zig", .value = 12, .parameters = &.{} },
    .{ .kind = .source_language, .name = "Rust", .value = 13, .parameters = &.{} },
    .{ .kind = .source_language, .name = "Pred", .value = 14, .parameters = &.{} },
    .{ .kind = .source_language, .name = "ApilaJai", .value = 15, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "Vertex", .value = 0, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "TessellationControl", .value = 1, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "TessellationEvaluation", .value = 2, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "Geometry", .value = 3, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "Fragment", .value = 4, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "GLCompute", .value = 5, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "Kernel", .value = 6, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "TaskNV", .value = 5267, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "MeshNV", .value = 5268, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "RayGenerationKHR", .value = 5313, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "RayGenerationNV", .value = 5313, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "IntersectionKHR", .value = 5314, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "IntersectionNV", .value = 5314, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "AnyHitKHR", .value = 5315, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "AnyHitNV", .value = 5315, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "ClosestHitKHR", .value = 5316, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "ClosestHitNV", .value = 5316, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "MissKHR", .value = 5317, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "MissNV", .value = 5317, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "CallableKHR", .value = 5318, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "CallableNV", .value = 5318, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "TaskEXT", .value = 5364, .parameters = &.{} },
    .{ .kind = .execution_model, .name = "MeshEXT", .value = 5365, .parameters = &.{} },
    .{ .kind = .addressing_model, .name = "Logical", .value = 0, .parameters = &.{} },
    .{ .kind = .addressing_model, .name = "Physical32", .value = 1, .parameters = &.{} },
    .{ .kind = .addressing_model, .name = "Physical64", .value = 2, .parameters = &.{} },
    .{ .kind = .addressing_model, .name = "PhysicalStorageBuffer64", .value = 5348, .parameters = &.{} },
    .{ .kind = .addressing_model, .name = "PhysicalStorageBuffer64EXT", .value = 5348, .parameters = &.{} },
    .{ .kind = .memory_model, .name = "Simple", .value = 0, .parameters = &.{} },
    .{ .kind = .memory_model, .name = "GLSL450", .value = 1, .parameters = &.{} },
    .{ .kind = .memory_model, .name = "OpenCL", .value = 2, .parameters = &.{} },
    .{ .kind = .memory_model, .name = "Vulkan", .value = 3, .parameters = &.{} },
    .{ .kind = .memory_model, .name = "VulkanKHR", .value = 3, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "Invocations", .value = 0, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "SpacingEqual", .value = 1, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "SpacingFractionalEven", .value = 2, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "SpacingFractionalOdd", .value = 3, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "VertexOrderCw", .value = 4, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "VertexOrderCcw", .value = 5, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "PixelCenterInteger", .value = 6, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "OriginUpperLeft", .value = 7, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "OriginLowerLeft", .value = 8, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "EarlyFragmentTests", .value = 9, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "PointMode", .value = 10, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "Xfb", .value = 11, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "DepthReplacing", .value = 12, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "DepthGreater", .value = 14, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "DepthLess", .value = 15, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "DepthUnchanged", .value = 16, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "LocalSize", .value = 17, .parameters = &.{ .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one } } },
    .{ .kind = .execution_mode, .name = "LocalSizeHint", .value = 18, .parameters = &.{ .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one } } },
    .{ .kind = .execution_mode, .name = "InputPoints", .value = 19, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "InputLines", .value = 20, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "InputLinesAdjacency", .value = 21, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "Triangles", .value = 22, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "InputTrianglesAdjacency", .value = 23, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "Quads", .value = 24, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "Isolines", .value = 25, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "OutputVertices", .value = 26, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "OutputPoints", .value = 27, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "OutputLineStrip", .value = 28, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "OutputTriangleStrip", .value = 29, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "VecTypeHint", .value = 30, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "ContractionOff", .value = 31, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "Initializer", .value = 33, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "Finalizer", .value = 34, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "SubgroupSize", .value = 35, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "SubgroupsPerWorkgroup", .value = 36, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "SubgroupsPerWorkgroupId", .value = 37, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "LocalSizeId", .value = 38, .parameters = &.{ .{ .kind = .id_ref, .quantifier = .one }, .{ .kind = .id_ref, .quantifier = .one }, .{ .kind = .id_ref, .quantifier = .one } } },
    .{ .kind = .execution_mode, .name = "LocalSizeHintId", .value = 39, .parameters = &.{ .{ .kind = .id_ref, .quantifier = .one }, .{ .kind = .id_ref, .quantifier = .one }, .{ .kind = .id_ref, .quantifier = .one } } },
    .{ .kind = .execution_mode, .name = "NonCoherentColorAttachmentReadEXT", .value = 4169, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "NonCoherentDepthAttachmentReadEXT", .value = 4170, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "NonCoherentStencilAttachmentReadEXT", .value = 4171, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "SubgroupUniformControlFlowKHR", .value = 4421, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "PostDepthCoverage", .value = 4446, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "DenormPreserve", .value = 4459, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "DenormFlushToZero", .value = 4460, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "SignedZeroInfNanPreserve", .value = 4461, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "RoundingModeRTE", .value = 4462, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "RoundingModeRTZ", .value = 4463, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "NonCoherentTileAttachmentReadQCOM", .value = 4489, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "TileShadingRateQCOM", .value = 4490, .parameters = &.{ .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one } } },
    .{ .kind = .execution_mode, .name = "SubgroupSizeHalfQCOM", .value = 4507, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "SubgroupSizeFullQCOM", .value = 4508, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "EarlyAndLateFragmentTestsAMD", .value = 5017, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "StencilRefReplacingEXT", .value = 5027, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "CoalescingAMDX", .value = 5069, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "IsApiEntryAMDX", .value = 5070, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "MaxNodeRecursionAMDX", .value = 5071, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "StaticNumWorkgroupsAMDX", .value = 5072, .parameters = &.{ .{ .kind = .id_ref, .quantifier = .one }, .{ .kind = .id_ref, .quantifier = .one }, .{ .kind = .id_ref, .quantifier = .one } } },
    .{ .kind = .execution_mode, .name = "ShaderIndexAMDX", .value = 5073, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "MaxNumWorkgroupsAMDX", .value = 5077, .parameters = &.{ .{ .kind = .id_ref, .quantifier = .one }, .{ .kind = .id_ref, .quantifier = .one }, .{ .kind = .id_ref, .quantifier = .one } } },
    .{ .kind = .execution_mode, .name = "StencilRefUnchangedFrontAMD", .value = 5079, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "StencilRefGreaterFrontAMD", .value = 5080, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "StencilRefLessFrontAMD", .value = 5081, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "StencilRefUnchangedBackAMD", .value = 5082, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "StencilRefGreaterBackAMD", .value = 5083, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "StencilRefLessBackAMD", .value = 5084, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "QuadDerivativesKHR", .value = 5088, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "RequireFullQuadsKHR", .value = 5089, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "SharesInputWithAMDX", .value = 5102, .parameters = &.{ .{ .kind = .id_ref, .quantifier = .one }, .{ .kind = .id_ref, .quantifier = .one } } },
    .{ .kind = .execution_mode, .name = "ArithmeticPoisonKHR", .value = 5157, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "OutputLinesEXT", .value = 5269, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "OutputLinesNV", .value = 5269, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "OutputPrimitivesEXT", .value = 5270, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "OutputPrimitivesNV", .value = 5270, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "DerivativeGroupQuadsKHR", .value = 5289, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "DerivativeGroupQuadsNV", .value = 5289, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "DerivativeGroupLinearKHR", .value = 5290, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "DerivativeGroupLinearNV", .value = 5290, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "OutputTrianglesEXT", .value = 5298, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "OutputTrianglesNV", .value = 5298, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "PixelInterlockOrderedEXT", .value = 5366, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "PixelInterlockUnorderedEXT", .value = 5367, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "SampleInterlockOrderedEXT", .value = 5368, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "SampleInterlockUnorderedEXT", .value = 5369, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "ShadingRateInterlockOrderedEXT", .value = 5370, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "ShadingRateInterlockUnorderedEXT", .value = 5371, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "Shader64BitIndexingEXT", .value = 5427, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "SharedLocalMemorySizeINTEL", .value = 5618, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "RoundingModeRTPINTEL", .value = 5620, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "RoundingModeRTNINTEL", .value = 5621, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "FloatingPointModeALTINTEL", .value = 5622, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "FloatingPointModeIEEEINTEL", .value = 5623, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "MaxWorkgroupSizeINTEL", .value = 5893, .parameters = &.{ .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one } } },
    .{ .kind = .execution_mode, .name = "MaxWorkDimINTEL", .value = 5894, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "NoGlobalOffsetINTEL", .value = 5895, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "NumSIMDWorkitemsINTEL", .value = 5896, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "SchedulerTargetFmaxMhzINTEL", .value = 5903, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "MaximallyReconvergesKHR", .value = 6023, .parameters = &.{} },
    .{ .kind = .execution_mode, .name = "FPFastMathDefault", .value = 6028, .parameters = &.{ .{ .kind = .id_ref, .quantifier = .one }, .{ .kind = .id_ref, .quantifier = .one } } },
    .{ .kind = .execution_mode, .name = "OpacityMicromapIdKHR", .value = 6031, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "StreamingInterfaceINTEL", .value = 6154, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "RegisterMapInterfaceINTEL", .value = 6160, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "NamedBarrierCountINTEL", .value = 6417, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "MaximumRegistersINTEL", .value = 6461, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "MaximumRegistersIdINTEL", .value = 6462, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .execution_mode, .name = "NamedMaximumRegistersINTEL", .value = 6463, .parameters = &.{.{ .kind = .named_maximum_number_of_registers, .quantifier = .one }} },
    .{ .kind = .storage_class, .name = "UniformConstant", .value = 0, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "Input", .value = 1, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "Uniform", .value = 2, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "Output", .value = 3, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "Workgroup", .value = 4, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "CrossWorkgroup", .value = 5, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "Private", .value = 6, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "Function", .value = 7, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "Generic", .value = 8, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "PushConstant", .value = 9, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "AtomicCounter", .value = 10, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "Image", .value = 11, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "StorageBuffer", .value = 12, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "TileImageEXT", .value = 4172, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "TileAttachmentQCOM", .value = 4491, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "NodePayloadAMDX", .value = 5068, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "CallableDataKHR", .value = 5328, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "CallableDataNV", .value = 5328, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "IncomingCallableDataKHR", .value = 5329, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "IncomingCallableDataNV", .value = 5329, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "RayPayloadKHR", .value = 5338, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "RayPayloadNV", .value = 5338, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "HitAttributeKHR", .value = 5339, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "HitAttributeNV", .value = 5339, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "IncomingRayPayloadKHR", .value = 5342, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "IncomingRayPayloadNV", .value = 5342, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "ShaderRecordBufferKHR", .value = 5343, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "ShaderRecordBufferNV", .value = 5343, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "PhysicalStorageBuffer", .value = 5349, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "PhysicalStorageBufferEXT", .value = 5349, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "HitObjectAttributeNV", .value = 5385, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "TaskPayloadWorkgroupEXT", .value = 5402, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "HitObjectAttributeEXT", .value = 5411, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "CodeSectionINTEL", .value = 5605, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "DeviceOnlyALTERA", .value = 5936, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "DeviceOnlyINTEL", .value = 5936, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "HostOnlyALTERA", .value = 5937, .parameters = &.{} },
    .{ .kind = .storage_class, .name = "HostOnlyINTEL", .value = 5937, .parameters = &.{} },
    .{ .kind = .dim, .name = "1D", .value = 0, .parameters = &.{} },
    .{ .kind = .dim, .name = "2D", .value = 1, .parameters = &.{} },
    .{ .kind = .dim, .name = "3D", .value = 2, .parameters = &.{} },
    .{ .kind = .dim, .name = "Cube", .value = 3, .parameters = &.{} },
    .{ .kind = .dim, .name = "Rect", .value = 4, .parameters = &.{} },
    .{ .kind = .dim, .name = "Buffer", .value = 5, .parameters = &.{} },
    .{ .kind = .dim, .name = "SubpassData", .value = 6, .parameters = &.{} },
    .{ .kind = .dim, .name = "TileImageDataEXT", .value = 4173, .parameters = &.{} },
    .{ .kind = .sampler_addressing_mode, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .sampler_addressing_mode, .name = "ClampToEdge", .value = 1, .parameters = &.{} },
    .{ .kind = .sampler_addressing_mode, .name = "Clamp", .value = 2, .parameters = &.{} },
    .{ .kind = .sampler_addressing_mode, .name = "Repeat", .value = 3, .parameters = &.{} },
    .{ .kind = .sampler_addressing_mode, .name = "RepeatMirrored", .value = 4, .parameters = &.{} },
    .{ .kind = .sampler_filter_mode, .name = "Nearest", .value = 0, .parameters = &.{} },
    .{ .kind = .sampler_filter_mode, .name = "Linear", .value = 1, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Unknown", .value = 0, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rgba32f", .value = 1, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rgba16f", .value = 2, .parameters = &.{} },
    .{ .kind = .image_format, .name = "R32f", .value = 3, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rgba8", .value = 4, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rgba8Snorm", .value = 5, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rg32f", .value = 6, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rg16f", .value = 7, .parameters = &.{} },
    .{ .kind = .image_format, .name = "R11fG11fB10f", .value = 8, .parameters = &.{} },
    .{ .kind = .image_format, .name = "R16f", .value = 9, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rgba16", .value = 10, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rgb10A2", .value = 11, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rg16", .value = 12, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rg8", .value = 13, .parameters = &.{} },
    .{ .kind = .image_format, .name = "R16", .value = 14, .parameters = &.{} },
    .{ .kind = .image_format, .name = "R8", .value = 15, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rgba16Snorm", .value = 16, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rg16Snorm", .value = 17, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rg8Snorm", .value = 18, .parameters = &.{} },
    .{ .kind = .image_format, .name = "R16Snorm", .value = 19, .parameters = &.{} },
    .{ .kind = .image_format, .name = "R8Snorm", .value = 20, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rgba32i", .value = 21, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rgba16i", .value = 22, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rgba8i", .value = 23, .parameters = &.{} },
    .{ .kind = .image_format, .name = "R32i", .value = 24, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rg32i", .value = 25, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rg16i", .value = 26, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rg8i", .value = 27, .parameters = &.{} },
    .{ .kind = .image_format, .name = "R16i", .value = 28, .parameters = &.{} },
    .{ .kind = .image_format, .name = "R8i", .value = 29, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rgba32ui", .value = 30, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rgba16ui", .value = 31, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rgba8ui", .value = 32, .parameters = &.{} },
    .{ .kind = .image_format, .name = "R32ui", .value = 33, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rgb10a2ui", .value = 34, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rg32ui", .value = 35, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rg16ui", .value = 36, .parameters = &.{} },
    .{ .kind = .image_format, .name = "Rg8ui", .value = 37, .parameters = &.{} },
    .{ .kind = .image_format, .name = "R16ui", .value = 38, .parameters = &.{} },
    .{ .kind = .image_format, .name = "R8ui", .value = 39, .parameters = &.{} },
    .{ .kind = .image_format, .name = "R64ui", .value = 40, .parameters = &.{} },
    .{ .kind = .image_format, .name = "R64i", .value = 41, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "R", .value = 0, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "A", .value = 1, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "RG", .value = 2, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "RA", .value = 3, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "RGB", .value = 4, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "RGBA", .value = 5, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "BGRA", .value = 6, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "ARGB", .value = 7, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "Intensity", .value = 8, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "Luminance", .value = 9, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "Rx", .value = 10, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "RGx", .value = 11, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "RGBx", .value = 12, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "Depth", .value = 13, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "DepthStencil", .value = 14, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "sRGB", .value = 15, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "sRGBx", .value = 16, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "sRGBA", .value = 17, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "sBGRA", .value = 18, .parameters = &.{} },
    .{ .kind = .image_channel_order, .name = "ABGR", .value = 19, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "SnormInt8", .value = 0, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "SnormInt16", .value = 1, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnormInt8", .value = 2, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnormInt16", .value = 3, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnormShort565", .value = 4, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnormShort555", .value = 5, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnormInt101010", .value = 6, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "SignedInt8", .value = 7, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "SignedInt16", .value = 8, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "SignedInt32", .value = 9, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnsignedInt8", .value = 10, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnsignedInt16", .value = 11, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnsignedInt32", .value = 12, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "HalfFloat", .value = 13, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "Float", .value = 14, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnormInt24", .value = 15, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnormInt101010_2", .value = 16, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnormInt10X6EXT", .value = 17, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnsignedIntRaw10EXT", .value = 19, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnsignedIntRaw12EXT", .value = 20, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnormInt2_101010EXT", .value = 21, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnsignedInt10X6EXT", .value = 22, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnsignedInt12X4EXT", .value = 23, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnsignedInt14X2EXT", .value = 24, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnormInt12X4EXT", .value = 25, .parameters = &.{} },
    .{ .kind = .image_channel_data_type, .name = "UnormInt14X2EXT", .value = 26, .parameters = &.{} },
    .{ .kind = .fp_rounding_mode, .name = "RTE", .value = 0, .parameters = &.{} },
    .{ .kind = .fp_rounding_mode, .name = "RTZ", .value = 1, .parameters = &.{} },
    .{ .kind = .fp_rounding_mode, .name = "RTP", .value = 2, .parameters = &.{} },
    .{ .kind = .fp_rounding_mode, .name = "RTN", .value = 3, .parameters = &.{} },
    .{ .kind = .fp_denorm_mode, .name = "Preserve", .value = 0, .parameters = &.{} },
    .{ .kind = .fp_denorm_mode, .name = "FlushToZero", .value = 1, .parameters = &.{} },
    .{ .kind = .quantization_modes, .name = "TRN", .value = 0, .parameters = &.{} },
    .{ .kind = .quantization_modes, .name = "TRN_ZERO", .value = 1, .parameters = &.{} },
    .{ .kind = .quantization_modes, .name = "RND", .value = 2, .parameters = &.{} },
    .{ .kind = .quantization_modes, .name = "RND_ZERO", .value = 3, .parameters = &.{} },
    .{ .kind = .quantization_modes, .name = "RND_INF", .value = 4, .parameters = &.{} },
    .{ .kind = .quantization_modes, .name = "RND_MIN_INF", .value = 5, .parameters = &.{} },
    .{ .kind = .quantization_modes, .name = "RND_CONV", .value = 6, .parameters = &.{} },
    .{ .kind = .quantization_modes, .name = "RND_CONV_ODD", .value = 7, .parameters = &.{} },
    .{ .kind = .fp_operation_mode, .name = "IEEE", .value = 0, .parameters = &.{} },
    .{ .kind = .fp_operation_mode, .name = "ALT", .value = 1, .parameters = &.{} },
    .{ .kind = .overflow_modes, .name = "WRAP", .value = 0, .parameters = &.{} },
    .{ .kind = .overflow_modes, .name = "SAT", .value = 1, .parameters = &.{} },
    .{ .kind = .overflow_modes, .name = "SAT_ZERO", .value = 2, .parameters = &.{} },
    .{ .kind = .overflow_modes, .name = "SAT_SYM", .value = 3, .parameters = &.{} },
    .{ .kind = .linkage_type, .name = "Export", .value = 0, .parameters = &.{} },
    .{ .kind = .linkage_type, .name = "Import", .value = 1, .parameters = &.{} },
    .{ .kind = .linkage_type, .name = "LinkOnceODR", .value = 2, .parameters = &.{} },
    .{ .kind = .linkage_type, .name = "WeakAMD", .value = 3, .parameters = &.{} },
    .{ .kind = .access_qualifier, .name = "ReadOnly", .value = 0, .parameters = &.{} },
    .{ .kind = .access_qualifier, .name = "WriteOnly", .value = 1, .parameters = &.{} },
    .{ .kind = .access_qualifier, .name = "ReadWrite", .value = 2, .parameters = &.{} },
    .{ .kind = .host_access_qualifier, .name = "NoneINTEL", .value = 0, .parameters = &.{} },
    .{ .kind = .host_access_qualifier, .name = "ReadINTEL", .value = 1, .parameters = &.{} },
    .{ .kind = .host_access_qualifier, .name = "WriteINTEL", .value = 2, .parameters = &.{} },
    .{ .kind = .host_access_qualifier, .name = "ReadWriteINTEL", .value = 3, .parameters = &.{} },
    .{ .kind = .function_parameter_attribute, .name = "Zext", .value = 0, .parameters = &.{} },
    .{ .kind = .function_parameter_attribute, .name = "Sext", .value = 1, .parameters = &.{} },
    .{ .kind = .function_parameter_attribute, .name = "ByVal", .value = 2, .parameters = &.{} },
    .{ .kind = .function_parameter_attribute, .name = "Sret", .value = 3, .parameters = &.{} },
    .{ .kind = .function_parameter_attribute, .name = "NoAlias", .value = 4, .parameters = &.{} },
    .{ .kind = .function_parameter_attribute, .name = "NoCapture", .value = 5, .parameters = &.{} },
    .{ .kind = .function_parameter_attribute, .name = "NoWrite", .value = 6, .parameters = &.{} },
    .{ .kind = .function_parameter_attribute, .name = "NoReadWrite", .value = 7, .parameters = &.{} },
    .{ .kind = .function_parameter_attribute, .name = "RuntimeAlignedALTERA", .value = 5940, .parameters = &.{} },
    .{ .kind = .function_parameter_attribute, .name = "RuntimeAlignedINTEL", .value = 5940, .parameters = &.{} },
    .{ .kind = .decoration, .name = "RelaxedPrecision", .value = 0, .parameters = &.{} },
    .{ .kind = .decoration, .name = "SpecId", .value = 1, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "Block", .value = 2, .parameters = &.{} },
    .{ .kind = .decoration, .name = "BufferBlock", .value = 3, .parameters = &.{} },
    .{ .kind = .decoration, .name = "RowMajor", .value = 4, .parameters = &.{} },
    .{ .kind = .decoration, .name = "ColMajor", .value = 5, .parameters = &.{} },
    .{ .kind = .decoration, .name = "ArrayStride", .value = 6, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MatrixStride", .value = 7, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "GLSLShared", .value = 8, .parameters = &.{} },
    .{ .kind = .decoration, .name = "GLSLPacked", .value = 9, .parameters = &.{} },
    .{ .kind = .decoration, .name = "CPacked", .value = 10, .parameters = &.{} },
    .{ .kind = .decoration, .name = "BuiltIn", .value = 11, .parameters = &.{.{ .kind = .built_in, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "NoPerspective", .value = 13, .parameters = &.{} },
    .{ .kind = .decoration, .name = "Flat", .value = 14, .parameters = &.{} },
    .{ .kind = .decoration, .name = "Patch", .value = 15, .parameters = &.{} },
    .{ .kind = .decoration, .name = "Centroid", .value = 16, .parameters = &.{} },
    .{ .kind = .decoration, .name = "Sample", .value = 17, .parameters = &.{} },
    .{ .kind = .decoration, .name = "Invariant", .value = 18, .parameters = &.{} },
    .{ .kind = .decoration, .name = "Restrict", .value = 19, .parameters = &.{} },
    .{ .kind = .decoration, .name = "Aliased", .value = 20, .parameters = &.{} },
    .{ .kind = .decoration, .name = "Volatile", .value = 21, .parameters = &.{} },
    .{ .kind = .decoration, .name = "Constant", .value = 22, .parameters = &.{} },
    .{ .kind = .decoration, .name = "Coherent", .value = 23, .parameters = &.{} },
    .{ .kind = .decoration, .name = "NonWritable", .value = 24, .parameters = &.{} },
    .{ .kind = .decoration, .name = "NonReadable", .value = 25, .parameters = &.{} },
    .{ .kind = .decoration, .name = "Uniform", .value = 26, .parameters = &.{} },
    .{ .kind = .decoration, .name = "UniformId", .value = 27, .parameters = &.{.{ .kind = .id_scope, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "SaturatedConversion", .value = 28, .parameters = &.{} },
    .{ .kind = .decoration, .name = "Stream", .value = 29, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "Location", .value = 30, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "Component", .value = 31, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "Index", .value = 32, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "Binding", .value = 33, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "DescriptorSet", .value = 34, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "Offset", .value = 35, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "XfbBuffer", .value = 36, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "XfbStride", .value = 37, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "FuncParamAttr", .value = 38, .parameters = &.{.{ .kind = .function_parameter_attribute, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "FPRoundingMode", .value = 39, .parameters = &.{.{ .kind = .fp_rounding_mode, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "FPFastMathMode", .value = 40, .parameters = &.{.{ .kind = .fp_fast_math_mode, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "LinkageAttributes", .value = 41, .parameters = &.{ .{ .kind = .literal_string, .quantifier = .one }, .{ .kind = .linkage_type, .quantifier = .one } } },
    .{ .kind = .decoration, .name = "NoContraction", .value = 42, .parameters = &.{} },
    .{ .kind = .decoration, .name = "InputAttachmentIndex", .value = 43, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "Alignment", .value = 44, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MaxByteOffset", .value = 45, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "AlignmentId", .value = 46, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MaxByteOffsetId", .value = 47, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "SaturatedToLargestFloat8NormalConversionEXT", .value = 4216, .parameters = &.{} },
    .{ .kind = .decoration, .name = "NoSignedWrap", .value = 4469, .parameters = &.{} },
    .{ .kind = .decoration, .name = "NoUnsignedWrap", .value = 4470, .parameters = &.{} },
    .{ .kind = .decoration, .name = "WeightTextureQCOM", .value = 4487, .parameters = &.{} },
    .{ .kind = .decoration, .name = "BlockMatchTextureQCOM", .value = 4488, .parameters = &.{} },
    .{ .kind = .decoration, .name = "BlockMatchSamplerQCOM", .value = 4499, .parameters = &.{} },
    .{ .kind = .decoration, .name = "ExplicitInterpAMD", .value = 4999, .parameters = &.{} },
    .{ .kind = .decoration, .name = "NodeSharesPayloadLimitsWithAMDX", .value = 5019, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "NodeMaxPayloadsAMDX", .value = 5020, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "TrackFinishWritingAMDX", .value = 5078, .parameters = &.{} },
    .{ .kind = .decoration, .name = "PayloadNodeNameAMDX", .value = 5091, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "PayloadNodeBaseIndexAMDX", .value = 5098, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "PayloadNodeSparseArrayAMDX", .value = 5099, .parameters = &.{} },
    .{ .kind = .decoration, .name = "PayloadNodeArraySizeAMDX", .value = 5100, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "PayloadDispatchIndirectAMDX", .value = 5105, .parameters = &.{} },
    .{ .kind = .decoration, .name = "ArrayStrideIdEXT", .value = 5124, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "OffsetIdEXT", .value = 5125, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "UTFEncodedKHR", .value = 5145, .parameters = &.{} },
    .{ .kind = .decoration, .name = "OverrideCoverageNV", .value = 5248, .parameters = &.{} },
    .{ .kind = .decoration, .name = "PassthroughNV", .value = 5250, .parameters = &.{} },
    .{ .kind = .decoration, .name = "ViewportRelativeNV", .value = 5252, .parameters = &.{} },
    .{ .kind = .decoration, .name = "SecondaryViewportRelativeNV", .value = 5256, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "PerPrimitiveEXT", .value = 5271, .parameters = &.{} },
    .{ .kind = .decoration, .name = "PerPrimitiveNV", .value = 5271, .parameters = &.{} },
    .{ .kind = .decoration, .name = "PerViewNV", .value = 5272, .parameters = &.{} },
    .{ .kind = .decoration, .name = "PerTaskNV", .value = 5273, .parameters = &.{} },
    .{ .kind = .decoration, .name = "PerVertexKHR", .value = 5285, .parameters = &.{} },
    .{ .kind = .decoration, .name = "PerVertexNV", .value = 5285, .parameters = &.{} },
    .{ .kind = .decoration, .name = "NonUniform", .value = 5300, .parameters = &.{} },
    .{ .kind = .decoration, .name = "NonUniformEXT", .value = 5300, .parameters = &.{} },
    .{ .kind = .decoration, .name = "RestrictPointer", .value = 5355, .parameters = &.{} },
    .{ .kind = .decoration, .name = "RestrictPointerEXT", .value = 5355, .parameters = &.{} },
    .{ .kind = .decoration, .name = "AliasedPointer", .value = 5356, .parameters = &.{} },
    .{ .kind = .decoration, .name = "AliasedPointerEXT", .value = 5356, .parameters = &.{} },
    .{ .kind = .decoration, .name = "MemberOffsetNV", .value = 5358, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "HitObjectShaderRecordBufferNV", .value = 5386, .parameters = &.{} },
    .{ .kind = .decoration, .name = "HitObjectShaderRecordBufferEXT", .value = 5389, .parameters = &.{} },
    .{ .kind = .decoration, .name = "BankNV", .value = 5397, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "BindlessSamplerNV", .value = 5398, .parameters = &.{} },
    .{ .kind = .decoration, .name = "BindlessImageNV", .value = 5399, .parameters = &.{} },
    .{ .kind = .decoration, .name = "BoundSamplerNV", .value = 5400, .parameters = &.{} },
    .{ .kind = .decoration, .name = "BoundImageNV", .value = 5401, .parameters = &.{} },
    .{ .kind = .decoration, .name = "CooperativeMatrixTransposeEXT", .value = 5440, .parameters = &.{} },
    .{ .kind = .decoration, .name = "SIMTCallINTEL", .value = 5599, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "ReferencedIndirectlyINTEL", .value = 5602, .parameters = &.{} },
    .{ .kind = .decoration, .name = "ClobberINTEL", .value = 5607, .parameters = &.{.{ .kind = .literal_string, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "SideEffectsINTEL", .value = 5608, .parameters = &.{} },
    .{ .kind = .decoration, .name = "VectorComputeVariableINTEL", .value = 5624, .parameters = &.{} },
    .{ .kind = .decoration, .name = "FuncParamIOKindINTEL", .value = 5625, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "VectorComputeFunctionINTEL", .value = 5626, .parameters = &.{} },
    .{ .kind = .decoration, .name = "StackCallINTEL", .value = 5627, .parameters = &.{} },
    .{ .kind = .decoration, .name = "GlobalVariableOffsetINTEL", .value = 5628, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "CounterBuffer", .value = 5634, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "HlslCounterBufferGOOGLE", .value = 5634, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "UserSemantic", .value = 5635, .parameters = &.{.{ .kind = .literal_string, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "HlslSemanticGOOGLE", .value = 5635, .parameters = &.{.{ .kind = .literal_string, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "UserTypeGOOGLE", .value = 5636, .parameters = &.{.{ .kind = .literal_string, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "FunctionRoundingModeINTEL", .value = 5822, .parameters = &.{ .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .fp_rounding_mode, .quantifier = .one } } },
    .{ .kind = .decoration, .name = "FunctionDenormModeINTEL", .value = 5823, .parameters = &.{ .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .fp_denorm_mode, .quantifier = .one } } },
    .{ .kind = .decoration, .name = "RegisterALTERA", .value = 5825, .parameters = &.{} },
    .{ .kind = .decoration, .name = "RegisterINTEL", .value = 5825, .parameters = &.{} },
    .{ .kind = .decoration, .name = "MemoryALTERA", .value = 5826, .parameters = &.{.{ .kind = .literal_string, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MemoryINTEL", .value = 5826, .parameters = &.{.{ .kind = .literal_string, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "NumbanksALTERA", .value = 5827, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "NumbanksINTEL", .value = 5827, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "BankwidthALTERA", .value = 5828, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "BankwidthINTEL", .value = 5828, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MaxPrivateCopiesALTERA", .value = 5829, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MaxPrivateCopiesINTEL", .value = 5829, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "SinglepumpALTERA", .value = 5830, .parameters = &.{} },
    .{ .kind = .decoration, .name = "SinglepumpINTEL", .value = 5830, .parameters = &.{} },
    .{ .kind = .decoration, .name = "DoublepumpALTERA", .value = 5831, .parameters = &.{} },
    .{ .kind = .decoration, .name = "DoublepumpINTEL", .value = 5831, .parameters = &.{} },
    .{ .kind = .decoration, .name = "MaxReplicatesALTERA", .value = 5832, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MaxReplicatesINTEL", .value = 5832, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "SimpleDualPortALTERA", .value = 5833, .parameters = &.{} },
    .{ .kind = .decoration, .name = "SimpleDualPortINTEL", .value = 5833, .parameters = &.{} },
    .{ .kind = .decoration, .name = "MergeALTERA", .value = 5834, .parameters = &.{ .{ .kind = .literal_string, .quantifier = .one }, .{ .kind = .literal_string, .quantifier = .one } } },
    .{ .kind = .decoration, .name = "MergeINTEL", .value = 5834, .parameters = &.{ .{ .kind = .literal_string, .quantifier = .one }, .{ .kind = .literal_string, .quantifier = .one } } },
    .{ .kind = .decoration, .name = "BankBitsALTERA", .value = 5835, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .variable }} },
    .{ .kind = .decoration, .name = "BankBitsINTEL", .value = 5835, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .variable }} },
    .{ .kind = .decoration, .name = "ForcePow2DepthALTERA", .value = 5836, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "ForcePow2DepthINTEL", .value = 5836, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "StridesizeALTERA", .value = 5883, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "StridesizeINTEL", .value = 5883, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "WordsizeALTERA", .value = 5884, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "WordsizeINTEL", .value = 5884, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "TrueDualPortALTERA", .value = 5885, .parameters = &.{} },
    .{ .kind = .decoration, .name = "TrueDualPortINTEL", .value = 5885, .parameters = &.{} },
    .{ .kind = .decoration, .name = "BurstCoalesceALTERA", .value = 5899, .parameters = &.{} },
    .{ .kind = .decoration, .name = "BurstCoalesceINTEL", .value = 5899, .parameters = &.{} },
    .{ .kind = .decoration, .name = "CacheSizeALTERA", .value = 5900, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "CacheSizeINTEL", .value = 5900, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "DontStaticallyCoalesceALTERA", .value = 5901, .parameters = &.{} },
    .{ .kind = .decoration, .name = "DontStaticallyCoalesceINTEL", .value = 5901, .parameters = &.{} },
    .{ .kind = .decoration, .name = "PrefetchALTERA", .value = 5902, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "PrefetchINTEL", .value = 5902, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "StallEnableALTERA", .value = 5905, .parameters = &.{} },
    .{ .kind = .decoration, .name = "StallEnableINTEL", .value = 5905, .parameters = &.{} },
    .{ .kind = .decoration, .name = "FuseLoopsInFunctionALTERA", .value = 5907, .parameters = &.{} },
    .{ .kind = .decoration, .name = "FuseLoopsInFunctionINTEL", .value = 5907, .parameters = &.{} },
    .{ .kind = .decoration, .name = "MathOpDSPModeALTERA", .value = 5909, .parameters = &.{ .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one } } },
    .{ .kind = .decoration, .name = "MathOpDSPModeINTEL", .value = 5909, .parameters = &.{ .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one } } },
    .{ .kind = .decoration, .name = "AliasScopeINTEL", .value = 5914, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "NoAliasINTEL", .value = 5915, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "InitiationIntervalALTERA", .value = 5917, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "InitiationIntervalINTEL", .value = 5917, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MaxConcurrencyALTERA", .value = 5918, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MaxConcurrencyINTEL", .value = 5918, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "PipelineEnableALTERA", .value = 5919, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "PipelineEnableINTEL", .value = 5919, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "BufferLocationALTERA", .value = 5921, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "BufferLocationINTEL", .value = 5921, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "IOPipeStorageALTERA", .value = 5944, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "IOPipeStorageINTEL", .value = 5944, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "FunctionFloatingPointModeINTEL", .value = 6080, .parameters = &.{ .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .fp_operation_mode, .quantifier = .one } } },
    .{ .kind = .decoration, .name = "SingleElementVectorINTEL", .value = 6085, .parameters = &.{} },
    .{ .kind = .decoration, .name = "VectorComputeCallableFunctionINTEL", .value = 6087, .parameters = &.{} },
    .{ .kind = .decoration, .name = "MediaBlockIOINTEL", .value = 6140, .parameters = &.{} },
    .{ .kind = .decoration, .name = "StallFreeALTERA", .value = 6151, .parameters = &.{} },
    .{ .kind = .decoration, .name = "StallFreeINTEL", .value = 6151, .parameters = &.{} },
    .{ .kind = .decoration, .name = "FPMaxErrorDecorationINTEL", .value = 6170, .parameters = &.{.{ .kind = .literal_float, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "LatencyControlLabelALTERA", .value = 6172, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "LatencyControlLabelINTEL", .value = 6172, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "LatencyControlConstraintALTERA", .value = 6173, .parameters = &.{ .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one } } },
    .{ .kind = .decoration, .name = "LatencyControlConstraintINTEL", .value = 6173, .parameters = &.{ .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one } } },
    .{ .kind = .decoration, .name = "ConduitKernelArgumentALTERA", .value = 6175, .parameters = &.{} },
    .{ .kind = .decoration, .name = "ConduitKernelArgumentINTEL", .value = 6175, .parameters = &.{} },
    .{ .kind = .decoration, .name = "RegisterMapKernelArgumentALTERA", .value = 6176, .parameters = &.{} },
    .{ .kind = .decoration, .name = "RegisterMapKernelArgumentINTEL", .value = 6176, .parameters = &.{} },
    .{ .kind = .decoration, .name = "MMHostInterfaceAddressWidthALTERA", .value = 6177, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MMHostInterfaceAddressWidthINTEL", .value = 6177, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MMHostInterfaceDataWidthALTERA", .value = 6178, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MMHostInterfaceDataWidthINTEL", .value = 6178, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MMHostInterfaceLatencyALTERA", .value = 6179, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MMHostInterfaceLatencyINTEL", .value = 6179, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MMHostInterfaceReadWriteModeALTERA", .value = 6180, .parameters = &.{.{ .kind = .access_qualifier, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MMHostInterfaceReadWriteModeINTEL", .value = 6180, .parameters = &.{.{ .kind = .access_qualifier, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MMHostInterfaceMaxBurstALTERA", .value = 6181, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MMHostInterfaceMaxBurstINTEL", .value = 6181, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MMHostInterfaceWaitRequestALTERA", .value = 6182, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "MMHostInterfaceWaitRequestINTEL", .value = 6182, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "StableKernelArgumentALTERA", .value = 6183, .parameters = &.{} },
    .{ .kind = .decoration, .name = "StableKernelArgumentINTEL", .value = 6183, .parameters = &.{} },
    .{ .kind = .decoration, .name = "HostAccessINTEL", .value = 6188, .parameters = &.{ .{ .kind = .host_access_qualifier, .quantifier = .one }, .{ .kind = .literal_string, .quantifier = .one } } },
    .{ .kind = .decoration, .name = "InitModeALTERA", .value = 6190, .parameters = &.{.{ .kind = .initialization_mode_qualifier, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "InitModeINTEL", .value = 6190, .parameters = &.{.{ .kind = .initialization_mode_qualifier, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "ImplementInRegisterMapALTERA", .value = 6191, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "ImplementInRegisterMapINTEL", .value = 6191, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "ConditionalINTEL", .value = 6247, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .decoration, .name = "CacheControlLoadINTEL", .value = 6442, .parameters = &.{ .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .load_cache_control, .quantifier = .one } } },
    .{ .kind = .decoration, .name = "CacheControlStoreINTEL", .value = 6443, .parameters = &.{ .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .store_cache_control, .quantifier = .one } } },
    .{ .kind = .decoration, .name = "IntrinsicSAMSUNG", .value = 7040, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .built_in, .name = "Position", .value = 0, .parameters = &.{} },
    .{ .kind = .built_in, .name = "PointSize", .value = 1, .parameters = &.{} },
    .{ .kind = .built_in, .name = "ClipDistance", .value = 3, .parameters = &.{} },
    .{ .kind = .built_in, .name = "CullDistance", .value = 4, .parameters = &.{} },
    .{ .kind = .built_in, .name = "VertexId", .value = 5, .parameters = &.{} },
    .{ .kind = .built_in, .name = "InstanceId", .value = 6, .parameters = &.{} },
    .{ .kind = .built_in, .name = "PrimitiveId", .value = 7, .parameters = &.{} },
    .{ .kind = .built_in, .name = "InvocationId", .value = 8, .parameters = &.{} },
    .{ .kind = .built_in, .name = "Layer", .value = 9, .parameters = &.{} },
    .{ .kind = .built_in, .name = "ViewportIndex", .value = 10, .parameters = &.{} },
    .{ .kind = .built_in, .name = "TessLevelOuter", .value = 11, .parameters = &.{} },
    .{ .kind = .built_in, .name = "TessLevelInner", .value = 12, .parameters = &.{} },
    .{ .kind = .built_in, .name = "TessCoord", .value = 13, .parameters = &.{} },
    .{ .kind = .built_in, .name = "PatchVertices", .value = 14, .parameters = &.{} },
    .{ .kind = .built_in, .name = "FragCoord", .value = 15, .parameters = &.{} },
    .{ .kind = .built_in, .name = "PointCoord", .value = 16, .parameters = &.{} },
    .{ .kind = .built_in, .name = "FrontFacing", .value = 17, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SampleId", .value = 18, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SamplePosition", .value = 19, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SampleMask", .value = 20, .parameters = &.{} },
    .{ .kind = .built_in, .name = "FragDepth", .value = 22, .parameters = &.{} },
    .{ .kind = .built_in, .name = "HelperInvocation", .value = 23, .parameters = &.{} },
    .{ .kind = .built_in, .name = "NumWorkgroups", .value = 24, .parameters = &.{} },
    .{ .kind = .built_in, .name = "WorkgroupSize", .value = 25, .parameters = &.{} },
    .{ .kind = .built_in, .name = "WorkgroupId", .value = 26, .parameters = &.{} },
    .{ .kind = .built_in, .name = "LocalInvocationId", .value = 27, .parameters = &.{} },
    .{ .kind = .built_in, .name = "GlobalInvocationId", .value = 28, .parameters = &.{} },
    .{ .kind = .built_in, .name = "LocalInvocationIndex", .value = 29, .parameters = &.{} },
    .{ .kind = .built_in, .name = "WorkDim", .value = 30, .parameters = &.{} },
    .{ .kind = .built_in, .name = "GlobalSize", .value = 31, .parameters = &.{} },
    .{ .kind = .built_in, .name = "EnqueuedWorkgroupSize", .value = 32, .parameters = &.{} },
    .{ .kind = .built_in, .name = "GlobalOffset", .value = 33, .parameters = &.{} },
    .{ .kind = .built_in, .name = "GlobalLinearId", .value = 34, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SubgroupSize", .value = 36, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SubgroupMaxSize", .value = 37, .parameters = &.{} },
    .{ .kind = .built_in, .name = "NumSubgroups", .value = 38, .parameters = &.{} },
    .{ .kind = .built_in, .name = "NumEnqueuedSubgroups", .value = 39, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SubgroupId", .value = 40, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SubgroupLocalInvocationId", .value = 41, .parameters = &.{} },
    .{ .kind = .built_in, .name = "VertexIndex", .value = 42, .parameters = &.{} },
    .{ .kind = .built_in, .name = "InstanceIndex", .value = 43, .parameters = &.{} },
    .{ .kind = .built_in, .name = "CoreIDARM", .value = 4160, .parameters = &.{} },
    .{ .kind = .built_in, .name = "CoreCountARM", .value = 4161, .parameters = &.{} },
    .{ .kind = .built_in, .name = "CoreMaxIDARM", .value = 4162, .parameters = &.{} },
    .{ .kind = .built_in, .name = "WarpIDARM", .value = 4163, .parameters = &.{} },
    .{ .kind = .built_in, .name = "WarpMaxIDARM", .value = 4164, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SubgroupEqMask", .value = 4416, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SubgroupEqMaskKHR", .value = 4416, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SubgroupGeMask", .value = 4417, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SubgroupGeMaskKHR", .value = 4417, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SubgroupGtMask", .value = 4418, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SubgroupGtMaskKHR", .value = 4418, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SubgroupLeMask", .value = 4419, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SubgroupLeMaskKHR", .value = 4419, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SubgroupLtMask", .value = 4420, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SubgroupLtMaskKHR", .value = 4420, .parameters = &.{} },
    .{ .kind = .built_in, .name = "BaseVertex", .value = 4424, .parameters = &.{} },
    .{ .kind = .built_in, .name = "BaseInstance", .value = 4425, .parameters = &.{} },
    .{ .kind = .built_in, .name = "DrawIndex", .value = 4426, .parameters = &.{} },
    .{ .kind = .built_in, .name = "PrimitiveShadingRateKHR", .value = 4432, .parameters = &.{} },
    .{ .kind = .built_in, .name = "DeviceIndex", .value = 4438, .parameters = &.{} },
    .{ .kind = .built_in, .name = "ViewIndex", .value = 4440, .parameters = &.{} },
    .{ .kind = .built_in, .name = "ShadingRateKHR", .value = 4444, .parameters = &.{} },
    .{ .kind = .built_in, .name = "TileOffsetQCOM", .value = 4492, .parameters = &.{} },
    .{ .kind = .built_in, .name = "TileDimensionQCOM", .value = 4493, .parameters = &.{} },
    .{ .kind = .built_in, .name = "TileApronSizeQCOM", .value = 4494, .parameters = &.{} },
    .{ .kind = .built_in, .name = "BaryCoordNoPerspAMD", .value = 4992, .parameters = &.{} },
    .{ .kind = .built_in, .name = "BaryCoordNoPerspCentroidAMD", .value = 4993, .parameters = &.{} },
    .{ .kind = .built_in, .name = "BaryCoordNoPerspSampleAMD", .value = 4994, .parameters = &.{} },
    .{ .kind = .built_in, .name = "BaryCoordSmoothAMD", .value = 4995, .parameters = &.{} },
    .{ .kind = .built_in, .name = "BaryCoordSmoothCentroidAMD", .value = 4996, .parameters = &.{} },
    .{ .kind = .built_in, .name = "BaryCoordSmoothSampleAMD", .value = 4997, .parameters = &.{} },
    .{ .kind = .built_in, .name = "BaryCoordPullModelAMD", .value = 4998, .parameters = &.{} },
    .{ .kind = .built_in, .name = "FragStencilRefEXT", .value = 5014, .parameters = &.{} },
    .{ .kind = .built_in, .name = "RemainingRecursionLevelsAMDX", .value = 5021, .parameters = &.{} },
    .{ .kind = .built_in, .name = "ShaderIndexAMDX", .value = 5073, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SamplerHeapEXT", .value = 5122, .parameters = &.{} },
    .{ .kind = .built_in, .name = "ResourceHeapEXT", .value = 5123, .parameters = &.{} },
    .{ .kind = .built_in, .name = "ViewportMaskNV", .value = 5253, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SecondaryPositionNV", .value = 5257, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SecondaryViewportMaskNV", .value = 5258, .parameters = &.{} },
    .{ .kind = .built_in, .name = "PositionPerViewNV", .value = 5261, .parameters = &.{} },
    .{ .kind = .built_in, .name = "ViewportMaskPerViewNV", .value = 5262, .parameters = &.{} },
    .{ .kind = .built_in, .name = "FullyCoveredEXT", .value = 5264, .parameters = &.{} },
    .{ .kind = .built_in, .name = "TaskCountNV", .value = 5274, .parameters = &.{} },
    .{ .kind = .built_in, .name = "PrimitiveCountNV", .value = 5275, .parameters = &.{} },
    .{ .kind = .built_in, .name = "PrimitiveIndicesNV", .value = 5276, .parameters = &.{} },
    .{ .kind = .built_in, .name = "ClipDistancePerViewNV", .value = 5277, .parameters = &.{} },
    .{ .kind = .built_in, .name = "CullDistancePerViewNV", .value = 5278, .parameters = &.{} },
    .{ .kind = .built_in, .name = "LayerPerViewNV", .value = 5279, .parameters = &.{} },
    .{ .kind = .built_in, .name = "MeshViewCountNV", .value = 5280, .parameters = &.{} },
    .{ .kind = .built_in, .name = "MeshViewIndicesNV", .value = 5281, .parameters = &.{} },
    .{ .kind = .built_in, .name = "BaryCoordKHR", .value = 5286, .parameters = &.{} },
    .{ .kind = .built_in, .name = "BaryCoordNV", .value = 5286, .parameters = &.{} },
    .{ .kind = .built_in, .name = "BaryCoordNoPerspKHR", .value = 5287, .parameters = &.{} },
    .{ .kind = .built_in, .name = "BaryCoordNoPerspNV", .value = 5287, .parameters = &.{} },
    .{ .kind = .built_in, .name = "FragSizeEXT", .value = 5292, .parameters = &.{} },
    .{ .kind = .built_in, .name = "FragmentSizeNV", .value = 5292, .parameters = &.{} },
    .{ .kind = .built_in, .name = "FragInvocationCountEXT", .value = 5293, .parameters = &.{} },
    .{ .kind = .built_in, .name = "InvocationsPerPixelNV", .value = 5293, .parameters = &.{} },
    .{ .kind = .built_in, .name = "PrimitivePointIndicesEXT", .value = 5294, .parameters = &.{} },
    .{ .kind = .built_in, .name = "PrimitiveLineIndicesEXT", .value = 5295, .parameters = &.{} },
    .{ .kind = .built_in, .name = "PrimitiveTriangleIndicesEXT", .value = 5296, .parameters = &.{} },
    .{ .kind = .built_in, .name = "CullPrimitiveEXT", .value = 5299, .parameters = &.{} },
    .{ .kind = .built_in, .name = "LaunchIdKHR", .value = 5319, .parameters = &.{} },
    .{ .kind = .built_in, .name = "LaunchIdNV", .value = 5319, .parameters = &.{} },
    .{ .kind = .built_in, .name = "LaunchSizeKHR", .value = 5320, .parameters = &.{} },
    .{ .kind = .built_in, .name = "LaunchSizeNV", .value = 5320, .parameters = &.{} },
    .{ .kind = .built_in, .name = "WorldRayOriginKHR", .value = 5321, .parameters = &.{} },
    .{ .kind = .built_in, .name = "WorldRayOriginNV", .value = 5321, .parameters = &.{} },
    .{ .kind = .built_in, .name = "WorldRayDirectionKHR", .value = 5322, .parameters = &.{} },
    .{ .kind = .built_in, .name = "WorldRayDirectionNV", .value = 5322, .parameters = &.{} },
    .{ .kind = .built_in, .name = "ObjectRayOriginKHR", .value = 5323, .parameters = &.{} },
    .{ .kind = .built_in, .name = "ObjectRayOriginNV", .value = 5323, .parameters = &.{} },
    .{ .kind = .built_in, .name = "ObjectRayDirectionKHR", .value = 5324, .parameters = &.{} },
    .{ .kind = .built_in, .name = "ObjectRayDirectionNV", .value = 5324, .parameters = &.{} },
    .{ .kind = .built_in, .name = "RayTminKHR", .value = 5325, .parameters = &.{} },
    .{ .kind = .built_in, .name = "RayTminNV", .value = 5325, .parameters = &.{} },
    .{ .kind = .built_in, .name = "RayTmaxKHR", .value = 5326, .parameters = &.{} },
    .{ .kind = .built_in, .name = "RayTmaxNV", .value = 5326, .parameters = &.{} },
    .{ .kind = .built_in, .name = "InstanceCustomIndexKHR", .value = 5327, .parameters = &.{} },
    .{ .kind = .built_in, .name = "InstanceCustomIndexNV", .value = 5327, .parameters = &.{} },
    .{ .kind = .built_in, .name = "ObjectToWorldKHR", .value = 5330, .parameters = &.{} },
    .{ .kind = .built_in, .name = "ObjectToWorldNV", .value = 5330, .parameters = &.{} },
    .{ .kind = .built_in, .name = "WorldToObjectKHR", .value = 5331, .parameters = &.{} },
    .{ .kind = .built_in, .name = "WorldToObjectNV", .value = 5331, .parameters = &.{} },
    .{ .kind = .built_in, .name = "HitTNV", .value = 5332, .parameters = &.{} },
    .{ .kind = .built_in, .name = "HitKindKHR", .value = 5333, .parameters = &.{} },
    .{ .kind = .built_in, .name = "HitKindNV", .value = 5333, .parameters = &.{} },
    .{ .kind = .built_in, .name = "CurrentRayTimeNV", .value = 5334, .parameters = &.{} },
    .{ .kind = .built_in, .name = "HitTriangleVertexPositionsKHR", .value = 5335, .parameters = &.{} },
    .{ .kind = .built_in, .name = "HitMicroTriangleVertexPositionsNV", .value = 5337, .parameters = &.{} },
    .{ .kind = .built_in, .name = "HitMicroTriangleVertexBarycentricsNV", .value = 5344, .parameters = &.{} },
    .{ .kind = .built_in, .name = "IncomingRayFlagsKHR", .value = 5351, .parameters = &.{} },
    .{ .kind = .built_in, .name = "IncomingRayFlagsNV", .value = 5351, .parameters = &.{} },
    .{ .kind = .built_in, .name = "RayGeometryIndexKHR", .value = 5352, .parameters = &.{} },
    .{ .kind = .built_in, .name = "HitIsSphereNV", .value = 5359, .parameters = &.{} },
    .{ .kind = .built_in, .name = "HitIsLSSNV", .value = 5360, .parameters = &.{} },
    .{ .kind = .built_in, .name = "HitSpherePositionNV", .value = 5361, .parameters = &.{} },
    .{ .kind = .built_in, .name = "WarpsPerSMNV", .value = 5374, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SMCountNV", .value = 5375, .parameters = &.{} },
    .{ .kind = .built_in, .name = "WarpIDNV", .value = 5376, .parameters = &.{} },
    .{ .kind = .built_in, .name = "SMIDNV", .value = 5377, .parameters = &.{} },
    .{ .kind = .built_in, .name = "HitLSSPositionsNV", .value = 5396, .parameters = &.{} },
    .{ .kind = .built_in, .name = "HitKindFrontFacingMicroTriangleNV", .value = 5405, .parameters = &.{} },
    .{ .kind = .built_in, .name = "HitKindBackFacingMicroTriangleNV", .value = 5406, .parameters = &.{} },
    .{ .kind = .built_in, .name = "HitSphereRadiusNV", .value = 5420, .parameters = &.{} },
    .{ .kind = .built_in, .name = "HitLSSRadiiNV", .value = 5421, .parameters = &.{} },
    .{ .kind = .built_in, .name = "ClusterIDNV", .value = 5436, .parameters = &.{} },
    .{ .kind = .built_in, .name = "CullMaskKHR", .value = 6021, .parameters = &.{} },
    .{ .kind = .scope, .name = "CrossDevice", .value = 0, .parameters = &.{} },
    .{ .kind = .scope, .name = "Device", .value = 1, .parameters = &.{} },
    .{ .kind = .scope, .name = "Workgroup", .value = 2, .parameters = &.{} },
    .{ .kind = .scope, .name = "Subgroup", .value = 3, .parameters = &.{} },
    .{ .kind = .scope, .name = "Invocation", .value = 4, .parameters = &.{} },
    .{ .kind = .scope, .name = "QueueFamily", .value = 5, .parameters = &.{} },
    .{ .kind = .scope, .name = "QueueFamilyKHR", .value = 5, .parameters = &.{} },
    .{ .kind = .scope, .name = "ShaderCallKHR", .value = 6, .parameters = &.{} },
    .{ .kind = .group_operation, .name = "Reduce", .value = 0, .parameters = &.{} },
    .{ .kind = .group_operation, .name = "InclusiveScan", .value = 1, .parameters = &.{} },
    .{ .kind = .group_operation, .name = "ExclusiveScan", .value = 2, .parameters = &.{} },
    .{ .kind = .group_operation, .name = "ClusteredReduce", .value = 3, .parameters = &.{} },
    .{ .kind = .group_operation, .name = "PartitionedReduceEXT", .value = 6, .parameters = &.{} },
    .{ .kind = .group_operation, .name = "PartitionedReduceNV", .value = 6, .parameters = &.{} },
    .{ .kind = .group_operation, .name = "PartitionedInclusiveScanEXT", .value = 7, .parameters = &.{} },
    .{ .kind = .group_operation, .name = "PartitionedInclusiveScanNV", .value = 7, .parameters = &.{} },
    .{ .kind = .group_operation, .name = "PartitionedExclusiveScanEXT", .value = 8, .parameters = &.{} },
    .{ .kind = .group_operation, .name = "PartitionedExclusiveScanNV", .value = 8, .parameters = &.{} },
    .{ .kind = .kernel_enqueue_flags, .name = "NoWait", .value = 0, .parameters = &.{} },
    .{ .kind = .kernel_enqueue_flags, .name = "WaitKernel", .value = 1, .parameters = &.{} },
    .{ .kind = .kernel_enqueue_flags, .name = "WaitWorkGroup", .value = 2, .parameters = &.{} },
    .{ .kind = .capability, .name = "Matrix", .value = 0, .parameters = &.{} },
    .{ .kind = .capability, .name = "Shader", .value = 1, .parameters = &.{} },
    .{ .kind = .capability, .name = "Geometry", .value = 2, .parameters = &.{} },
    .{ .kind = .capability, .name = "Tessellation", .value = 3, .parameters = &.{} },
    .{ .kind = .capability, .name = "Addresses", .value = 4, .parameters = &.{} },
    .{ .kind = .capability, .name = "Linkage", .value = 5, .parameters = &.{} },
    .{ .kind = .capability, .name = "Kernel", .value = 6, .parameters = &.{} },
    .{ .kind = .capability, .name = "Vector16", .value = 7, .parameters = &.{} },
    .{ .kind = .capability, .name = "Float16Buffer", .value = 8, .parameters = &.{} },
    .{ .kind = .capability, .name = "Float16", .value = 9, .parameters = &.{} },
    .{ .kind = .capability, .name = "Float64", .value = 10, .parameters = &.{} },
    .{ .kind = .capability, .name = "Int64", .value = 11, .parameters = &.{} },
    .{ .kind = .capability, .name = "Int64Atomics", .value = 12, .parameters = &.{} },
    .{ .kind = .capability, .name = "ImageBasic", .value = 13, .parameters = &.{} },
    .{ .kind = .capability, .name = "ImageReadWrite", .value = 14, .parameters = &.{} },
    .{ .kind = .capability, .name = "ImageMipmap", .value = 15, .parameters = &.{} },
    .{ .kind = .capability, .name = "Pipes", .value = 17, .parameters = &.{} },
    .{ .kind = .capability, .name = "Groups", .value = 18, .parameters = &.{} },
    .{ .kind = .capability, .name = "DeviceEnqueue", .value = 19, .parameters = &.{} },
    .{ .kind = .capability, .name = "LiteralSampler", .value = 20, .parameters = &.{} },
    .{ .kind = .capability, .name = "AtomicStorage", .value = 21, .parameters = &.{} },
    .{ .kind = .capability, .name = "Int16", .value = 22, .parameters = &.{} },
    .{ .kind = .capability, .name = "TessellationPointSize", .value = 23, .parameters = &.{} },
    .{ .kind = .capability, .name = "GeometryPointSize", .value = 24, .parameters = &.{} },
    .{ .kind = .capability, .name = "ImageGatherExtended", .value = 25, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageImageMultisample", .value = 27, .parameters = &.{} },
    .{ .kind = .capability, .name = "UniformBufferArrayDynamicIndexing", .value = 28, .parameters = &.{} },
    .{ .kind = .capability, .name = "SampledImageArrayDynamicIndexing", .value = 29, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageBufferArrayDynamicIndexing", .value = 30, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageImageArrayDynamicIndexing", .value = 31, .parameters = &.{} },
    .{ .kind = .capability, .name = "ClipDistance", .value = 32, .parameters = &.{} },
    .{ .kind = .capability, .name = "CullDistance", .value = 33, .parameters = &.{} },
    .{ .kind = .capability, .name = "ImageCubeArray", .value = 34, .parameters = &.{} },
    .{ .kind = .capability, .name = "SampleRateShading", .value = 35, .parameters = &.{} },
    .{ .kind = .capability, .name = "ImageRect", .value = 36, .parameters = &.{} },
    .{ .kind = .capability, .name = "SampledRect", .value = 37, .parameters = &.{} },
    .{ .kind = .capability, .name = "GenericPointer", .value = 38, .parameters = &.{} },
    .{ .kind = .capability, .name = "Int8", .value = 39, .parameters = &.{} },
    .{ .kind = .capability, .name = "InputAttachment", .value = 40, .parameters = &.{} },
    .{ .kind = .capability, .name = "SparseResidency", .value = 41, .parameters = &.{} },
    .{ .kind = .capability, .name = "MinLod", .value = 42, .parameters = &.{} },
    .{ .kind = .capability, .name = "Sampled1D", .value = 43, .parameters = &.{} },
    .{ .kind = .capability, .name = "Image1D", .value = 44, .parameters = &.{} },
    .{ .kind = .capability, .name = "SampledCubeArray", .value = 45, .parameters = &.{} },
    .{ .kind = .capability, .name = "SampledBuffer", .value = 46, .parameters = &.{} },
    .{ .kind = .capability, .name = "ImageBuffer", .value = 47, .parameters = &.{} },
    .{ .kind = .capability, .name = "ImageMSArray", .value = 48, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageImageExtendedFormats", .value = 49, .parameters = &.{} },
    .{ .kind = .capability, .name = "ImageQuery", .value = 50, .parameters = &.{} },
    .{ .kind = .capability, .name = "DerivativeControl", .value = 51, .parameters = &.{} },
    .{ .kind = .capability, .name = "InterpolationFunction", .value = 52, .parameters = &.{} },
    .{ .kind = .capability, .name = "TransformFeedback", .value = 53, .parameters = &.{} },
    .{ .kind = .capability, .name = "GeometryStreams", .value = 54, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageImageReadWithoutFormat", .value = 55, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageImageWriteWithoutFormat", .value = 56, .parameters = &.{} },
    .{ .kind = .capability, .name = "MultiViewport", .value = 57, .parameters = &.{} },
    .{ .kind = .capability, .name = "SubgroupDispatch", .value = 58, .parameters = &.{} },
    .{ .kind = .capability, .name = "NamedBarrier", .value = 59, .parameters = &.{} },
    .{ .kind = .capability, .name = "PipeStorage", .value = 60, .parameters = &.{} },
    .{ .kind = .capability, .name = "GroupNonUniform", .value = 61, .parameters = &.{} },
    .{ .kind = .capability, .name = "GroupNonUniformVote", .value = 62, .parameters = &.{} },
    .{ .kind = .capability, .name = "GroupNonUniformArithmetic", .value = 63, .parameters = &.{} },
    .{ .kind = .capability, .name = "GroupNonUniformBallot", .value = 64, .parameters = &.{} },
    .{ .kind = .capability, .name = "GroupNonUniformShuffle", .value = 65, .parameters = &.{} },
    .{ .kind = .capability, .name = "GroupNonUniformShuffleRelative", .value = 66, .parameters = &.{} },
    .{ .kind = .capability, .name = "GroupNonUniformClustered", .value = 67, .parameters = &.{} },
    .{ .kind = .capability, .name = "GroupNonUniformQuad", .value = 68, .parameters = &.{} },
    .{ .kind = .capability, .name = "ShaderLayer", .value = 69, .parameters = &.{} },
    .{ .kind = .capability, .name = "ShaderViewportIndex", .value = 70, .parameters = &.{} },
    .{ .kind = .capability, .name = "UniformDecoration", .value = 71, .parameters = &.{} },
    .{ .kind = .capability, .name = "CoreBuiltinsARM", .value = 4165, .parameters = &.{} },
    .{ .kind = .capability, .name = "TileImageColorReadAccessEXT", .value = 4166, .parameters = &.{} },
    .{ .kind = .capability, .name = "TileImageDepthReadAccessEXT", .value = 4167, .parameters = &.{} },
    .{ .kind = .capability, .name = "TileImageStencilReadAccessEXT", .value = 4168, .parameters = &.{} },
    .{ .kind = .capability, .name = "TensorsARM", .value = 4174, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageTensorArrayDynamicIndexingARM", .value = 4175, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageTensorArrayNonUniformIndexingARM", .value = 4176, .parameters = &.{} },
    .{ .kind = .capability, .name = "GraphARM", .value = 4191, .parameters = &.{} },
    .{ .kind = .capability, .name = "CooperativeMatrixLayoutsARM", .value = 4201, .parameters = &.{} },
    .{ .kind = .capability, .name = "Float8EXT", .value = 4212, .parameters = &.{} },
    .{ .kind = .capability, .name = "Float8CooperativeMatrixEXT", .value = 4213, .parameters = &.{} },
    .{ .kind = .capability, .name = "Float6EXT", .value = 4228, .parameters = &.{} },
    .{ .kind = .capability, .name = "Float4EXT", .value = 4229, .parameters = &.{} },
    .{ .kind = .capability, .name = "Float8UnsignedE8M0EXT", .value = 4230, .parameters = &.{} },
    .{ .kind = .capability, .name = "MXInt8EXT", .value = 4231, .parameters = &.{} },
    .{ .kind = .capability, .name = "BitcastExtractEXT", .value = 4232, .parameters = &.{} },
    .{ .kind = .capability, .name = "FragmentShadingRateKHR", .value = 4422, .parameters = &.{} },
    .{ .kind = .capability, .name = "SubgroupBallotKHR", .value = 4423, .parameters = &.{} },
    .{ .kind = .capability, .name = "DrawParameters", .value = 4427, .parameters = &.{} },
    .{ .kind = .capability, .name = "WorkgroupMemoryExplicitLayoutKHR", .value = 4428, .parameters = &.{} },
    .{ .kind = .capability, .name = "WorkgroupMemoryExplicitLayout8BitAccessKHR", .value = 4429, .parameters = &.{} },
    .{ .kind = .capability, .name = "WorkgroupMemoryExplicitLayout16BitAccessKHR", .value = 4430, .parameters = &.{} },
    .{ .kind = .capability, .name = "SubgroupVoteKHR", .value = 4431, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageBuffer16BitAccess", .value = 4433, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageUniformBufferBlock16", .value = 4433, .parameters = &.{} },
    .{ .kind = .capability, .name = "UniformAndStorageBuffer16BitAccess", .value = 4434, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageUniform16", .value = 4434, .parameters = &.{} },
    .{ .kind = .capability, .name = "StoragePushConstant16", .value = 4435, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageInputOutput16", .value = 4436, .parameters = &.{} },
    .{ .kind = .capability, .name = "DeviceGroup", .value = 4437, .parameters = &.{} },
    .{ .kind = .capability, .name = "MultiView", .value = 4439, .parameters = &.{} },
    .{ .kind = .capability, .name = "VariablePointersStorageBuffer", .value = 4441, .parameters = &.{} },
    .{ .kind = .capability, .name = "VariablePointers", .value = 4442, .parameters = &.{} },
    .{ .kind = .capability, .name = "AtomicStorageOps", .value = 4445, .parameters = &.{} },
    .{ .kind = .capability, .name = "SampleMaskPostDepthCoverage", .value = 4447, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageBuffer8BitAccess", .value = 4448, .parameters = &.{} },
    .{ .kind = .capability, .name = "UniformAndStorageBuffer8BitAccess", .value = 4449, .parameters = &.{} },
    .{ .kind = .capability, .name = "StoragePushConstant8", .value = 4450, .parameters = &.{} },
    .{ .kind = .capability, .name = "DenormPreserve", .value = 4464, .parameters = &.{} },
    .{ .kind = .capability, .name = "DenormFlushToZero", .value = 4465, .parameters = &.{} },
    .{ .kind = .capability, .name = "SignedZeroInfNanPreserve", .value = 4466, .parameters = &.{} },
    .{ .kind = .capability, .name = "RoundingModeRTE", .value = 4467, .parameters = &.{} },
    .{ .kind = .capability, .name = "RoundingModeRTZ", .value = 4468, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayQueryProvisionalKHR", .value = 4471, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayQueryKHR", .value = 4472, .parameters = &.{} },
    .{ .kind = .capability, .name = "UntypedPointersKHR", .value = 4473, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayTraversalPrimitiveCullingKHR", .value = 4478, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayTracingKHR", .value = 4479, .parameters = &.{} },
    .{ .kind = .capability, .name = "TextureSampleWeightedQCOM", .value = 4484, .parameters = &.{} },
    .{ .kind = .capability, .name = "TextureBoxFilterQCOM", .value = 4485, .parameters = &.{} },
    .{ .kind = .capability, .name = "TextureBlockMatchQCOM", .value = 4486, .parameters = &.{} },
    .{ .kind = .capability, .name = "TileShadingQCOM", .value = 4495, .parameters = &.{} },
    .{ .kind = .capability, .name = "CooperativeMatrixConversionQCOM", .value = 4496, .parameters = &.{} },
    .{ .kind = .capability, .name = "TextureBlockMatch2QCOM", .value = 4498, .parameters = &.{} },
    .{ .kind = .capability, .name = "BFloat16MulAddQCOM", .value = 4504, .parameters = &.{} },
    .{ .kind = .capability, .name = "SubgroupSizeQCOM", .value = 4506, .parameters = &.{} },
    .{ .kind = .capability, .name = "MultipleWaitQueuesQCOM", .value = 4539, .parameters = &.{} },
    .{ .kind = .capability, .name = "ImageGatherLinearQCOM", .value = 4543, .parameters = &.{} },
    .{ .kind = .capability, .name = "ImageGatherExtendedModesQCOM", .value = 4544, .parameters = &.{} },
    .{ .kind = .capability, .name = "Float16ImageAMD", .value = 5008, .parameters = &.{} },
    .{ .kind = .capability, .name = "ImageGatherBiasLodAMD", .value = 5009, .parameters = &.{} },
    .{ .kind = .capability, .name = "FragmentMaskAMD", .value = 5010, .parameters = &.{} },
    .{ .kind = .capability, .name = "StencilExportEXT", .value = 5013, .parameters = &.{} },
    .{ .kind = .capability, .name = "ImageReadWriteLodAMD", .value = 5015, .parameters = &.{} },
    .{ .kind = .capability, .name = "Int64ImageEXT", .value = 5016, .parameters = &.{} },
    .{ .kind = .capability, .name = "ShaderClockKHR", .value = 5055, .parameters = &.{} },
    .{ .kind = .capability, .name = "ShaderEnqueueAMDX", .value = 5067, .parameters = &.{} },
    .{ .kind = .capability, .name = "QuadControlKHR", .value = 5087, .parameters = &.{} },
    .{ .kind = .capability, .name = "Int4TypeINTEL", .value = 5112, .parameters = &.{} },
    .{ .kind = .capability, .name = "Int4CooperativeMatrixINTEL", .value = 5114, .parameters = &.{} },
    .{ .kind = .capability, .name = "BFloat16TypeKHR", .value = 5116, .parameters = &.{} },
    .{ .kind = .capability, .name = "BFloat16DotProductKHR", .value = 5117, .parameters = &.{} },
    .{ .kind = .capability, .name = "BFloat16CooperativeMatrixKHR", .value = 5118, .parameters = &.{} },
    .{ .kind = .capability, .name = "AbortKHR", .value = 5120, .parameters = &.{} },
    .{ .kind = .capability, .name = "DescriptorHeapEXT", .value = 5128, .parameters = &.{} },
    .{ .kind = .capability, .name = "ConstantDataKHR", .value = 5146, .parameters = &.{} },
    .{ .kind = .capability, .name = "PoisonFreezeKHR", .value = 5156, .parameters = &.{} },
    .{ .kind = .capability, .name = "WeakLinkageAMD", .value = 5181, .parameters = &.{} },
    .{ .kind = .capability, .name = "SampleMaskOverrideCoverageNV", .value = 5249, .parameters = &.{} },
    .{ .kind = .capability, .name = "GeometryShaderPassthroughNV", .value = 5251, .parameters = &.{} },
    .{ .kind = .capability, .name = "ShaderViewportIndexLayerEXT", .value = 5254, .parameters = &.{} },
    .{ .kind = .capability, .name = "ShaderViewportIndexLayerNV", .value = 5254, .parameters = &.{} },
    .{ .kind = .capability, .name = "ShaderViewportMaskNV", .value = 5255, .parameters = &.{} },
    .{ .kind = .capability, .name = "ShaderStereoViewNV", .value = 5259, .parameters = &.{} },
    .{ .kind = .capability, .name = "PerViewAttributesNV", .value = 5260, .parameters = &.{} },
    .{ .kind = .capability, .name = "FragmentFullyCoveredEXT", .value = 5265, .parameters = &.{} },
    .{ .kind = .capability, .name = "MeshShadingNV", .value = 5266, .parameters = &.{} },
    .{ .kind = .capability, .name = "ImageFootprintNV", .value = 5282, .parameters = &.{} },
    .{ .kind = .capability, .name = "MeshShadingEXT", .value = 5283, .parameters = &.{} },
    .{ .kind = .capability, .name = "FragmentBarycentricKHR", .value = 5284, .parameters = &.{} },
    .{ .kind = .capability, .name = "FragmentBarycentricNV", .value = 5284, .parameters = &.{} },
    .{ .kind = .capability, .name = "ComputeDerivativeGroupQuadsKHR", .value = 5288, .parameters = &.{} },
    .{ .kind = .capability, .name = "ComputeDerivativeGroupQuadsNV", .value = 5288, .parameters = &.{} },
    .{ .kind = .capability, .name = "FragmentDensityEXT", .value = 5291, .parameters = &.{} },
    .{ .kind = .capability, .name = "ShadingRateNV", .value = 5291, .parameters = &.{} },
    .{ .kind = .capability, .name = "GroupNonUniformPartitionedEXT", .value = 5297, .parameters = &.{} },
    .{ .kind = .capability, .name = "GroupNonUniformPartitionedNV", .value = 5297, .parameters = &.{} },
    .{ .kind = .capability, .name = "ShaderNonUniform", .value = 5301, .parameters = &.{} },
    .{ .kind = .capability, .name = "ShaderNonUniformEXT", .value = 5301, .parameters = &.{} },
    .{ .kind = .capability, .name = "RuntimeDescriptorArray", .value = 5302, .parameters = &.{} },
    .{ .kind = .capability, .name = "RuntimeDescriptorArrayEXT", .value = 5302, .parameters = &.{} },
    .{ .kind = .capability, .name = "InputAttachmentArrayDynamicIndexing", .value = 5303, .parameters = &.{} },
    .{ .kind = .capability, .name = "InputAttachmentArrayDynamicIndexingEXT", .value = 5303, .parameters = &.{} },
    .{ .kind = .capability, .name = "UniformTexelBufferArrayDynamicIndexing", .value = 5304, .parameters = &.{} },
    .{ .kind = .capability, .name = "UniformTexelBufferArrayDynamicIndexingEXT", .value = 5304, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageTexelBufferArrayDynamicIndexing", .value = 5305, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageTexelBufferArrayDynamicIndexingEXT", .value = 5305, .parameters = &.{} },
    .{ .kind = .capability, .name = "UniformBufferArrayNonUniformIndexing", .value = 5306, .parameters = &.{} },
    .{ .kind = .capability, .name = "UniformBufferArrayNonUniformIndexingEXT", .value = 5306, .parameters = &.{} },
    .{ .kind = .capability, .name = "SampledImageArrayNonUniformIndexing", .value = 5307, .parameters = &.{} },
    .{ .kind = .capability, .name = "SampledImageArrayNonUniformIndexingEXT", .value = 5307, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageBufferArrayNonUniformIndexing", .value = 5308, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageBufferArrayNonUniformIndexingEXT", .value = 5308, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageImageArrayNonUniformIndexing", .value = 5309, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageImageArrayNonUniformIndexingEXT", .value = 5309, .parameters = &.{} },
    .{ .kind = .capability, .name = "InputAttachmentArrayNonUniformIndexing", .value = 5310, .parameters = &.{} },
    .{ .kind = .capability, .name = "InputAttachmentArrayNonUniformIndexingEXT", .value = 5310, .parameters = &.{} },
    .{ .kind = .capability, .name = "UniformTexelBufferArrayNonUniformIndexing", .value = 5311, .parameters = &.{} },
    .{ .kind = .capability, .name = "UniformTexelBufferArrayNonUniformIndexingEXT", .value = 5311, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageTexelBufferArrayNonUniformIndexing", .value = 5312, .parameters = &.{} },
    .{ .kind = .capability, .name = "StorageTexelBufferArrayNonUniformIndexingEXT", .value = 5312, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayTracingPositionFetchKHR", .value = 5336, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayTracingNV", .value = 5340, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayTracingMotionBlurNV", .value = 5341, .parameters = &.{} },
    .{ .kind = .capability, .name = "VulkanMemoryModel", .value = 5345, .parameters = &.{} },
    .{ .kind = .capability, .name = "VulkanMemoryModelKHR", .value = 5345, .parameters = &.{} },
    .{ .kind = .capability, .name = "VulkanMemoryModelDeviceScope", .value = 5346, .parameters = &.{} },
    .{ .kind = .capability, .name = "VulkanMemoryModelDeviceScopeKHR", .value = 5346, .parameters = &.{} },
    .{ .kind = .capability, .name = "PhysicalStorageBufferAddresses", .value = 5347, .parameters = &.{} },
    .{ .kind = .capability, .name = "PhysicalStorageBufferAddressesEXT", .value = 5347, .parameters = &.{} },
    .{ .kind = .capability, .name = "ComputeDerivativeGroupLinearKHR", .value = 5350, .parameters = &.{} },
    .{ .kind = .capability, .name = "ComputeDerivativeGroupLinearNV", .value = 5350, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayTracingProvisionalKHR", .value = 5353, .parameters = &.{} },
    .{ .kind = .capability, .name = "CooperativeMatrixNV", .value = 5357, .parameters = &.{} },
    .{ .kind = .capability, .name = "FragmentShaderSampleInterlockEXT", .value = 5363, .parameters = &.{} },
    .{ .kind = .capability, .name = "FragmentShaderShadingRateInterlockEXT", .value = 5372, .parameters = &.{} },
    .{ .kind = .capability, .name = "ShaderSMBuiltinsNV", .value = 5373, .parameters = &.{} },
    .{ .kind = .capability, .name = "FragmentShaderPixelInterlockEXT", .value = 5378, .parameters = &.{} },
    .{ .kind = .capability, .name = "DemoteToHelperInvocation", .value = 5379, .parameters = &.{} },
    .{ .kind = .capability, .name = "DemoteToHelperInvocationEXT", .value = 5379, .parameters = &.{} },
    .{ .kind = .capability, .name = "DisplacementMicromapNV", .value = 5380, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayTracingOpacityMicromapKHR", .value = 5381, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayTracingOpacityMicromapEXT", .value = 5381, .parameters = &.{} },
    .{ .kind = .capability, .name = "ShaderInvocationReorderNV", .value = 5383, .parameters = &.{} },
    .{ .kind = .capability, .name = "ShaderInvocationReorderEXT", .value = 5388, .parameters = &.{} },
    .{ .kind = .capability, .name = "BindlessTextureNV", .value = 5390, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayQueryPositionFetchKHR", .value = 5391, .parameters = &.{} },
    .{ .kind = .capability, .name = "CooperativeVectorNV", .value = 5394, .parameters = &.{} },
    .{ .kind = .capability, .name = "AtomicFloat16VectorNV", .value = 5404, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayTracingDisplacementMicromapNV", .value = 5409, .parameters = &.{} },
    .{ .kind = .capability, .name = "RawAccessChainsNV", .value = 5414, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayTracingSpheresGeometryNV", .value = 5418, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayTracingLinearSweptSpheresGeometryNV", .value = 5419, .parameters = &.{} },
    .{ .kind = .capability, .name = "PushConstantBanksNV", .value = 5423, .parameters = &.{} },
    .{ .kind = .capability, .name = "LongVectorEXT", .value = 5425, .parameters = &.{} },
    .{ .kind = .capability, .name = "Shader64BitIndexingEXT", .value = 5426, .parameters = &.{} },
    .{ .kind = .capability, .name = "CooperativeMatrixConversionsEXT", .value = 5429, .parameters = &.{} },
    .{ .kind = .capability, .name = "CooperativeMatrixReductionsEXT", .value = 5430, .parameters = &.{} },
    .{ .kind = .capability, .name = "CooperativeMatrixReductionsNV", .value = 5430, .parameters = &.{} },
    .{ .kind = .capability, .name = "CooperativeMatrixConversionsNV", .value = 5431, .parameters = &.{} },
    .{ .kind = .capability, .name = "CooperativeMatrixPerElementOperationsEXT", .value = 5432, .parameters = &.{} },
    .{ .kind = .capability, .name = "CooperativeMatrixPerElementOperationsNV", .value = 5432, .parameters = &.{} },
    .{ .kind = .capability, .name = "CooperativeMatrixTensorAddressingNV", .value = 5433, .parameters = &.{} },
    .{ .kind = .capability, .name = "CooperativeMatrixBlockLoadsNV", .value = 5434, .parameters = &.{} },
    .{ .kind = .capability, .name = "CooperativeVectorTrainingNV", .value = 5435, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayTracingClusterAccelerationStructureNV", .value = 5437, .parameters = &.{} },
    .{ .kind = .capability, .name = "CooperativeMatrixGetCoordinateEXT", .value = 5438, .parameters = &.{} },
    .{ .kind = .capability, .name = "TensorAddressingNV", .value = 5439, .parameters = &.{} },
    .{ .kind = .capability, .name = "CooperativeMatrixDecodeVectorNV", .value = 5447, .parameters = &.{} },
    .{ .kind = .capability, .name = "SubgroupShuffleINTEL", .value = 5568, .parameters = &.{} },
    .{ .kind = .capability, .name = "SubgroupBufferBlockIOINTEL", .value = 5569, .parameters = &.{} },
    .{ .kind = .capability, .name = "SubgroupImageBlockIOINTEL", .value = 5570, .parameters = &.{} },
    .{ .kind = .capability, .name = "SubgroupImageMediaBlockIOINTEL", .value = 5579, .parameters = &.{} },
    .{ .kind = .capability, .name = "RoundToInfinityINTEL", .value = 5582, .parameters = &.{} },
    .{ .kind = .capability, .name = "FloatingPointModeINTEL", .value = 5583, .parameters = &.{} },
    .{ .kind = .capability, .name = "IntegerFunctions2INTEL", .value = 5584, .parameters = &.{} },
    .{ .kind = .capability, .name = "FunctionPointersINTEL", .value = 5603, .parameters = &.{} },
    .{ .kind = .capability, .name = "IndirectReferencesINTEL", .value = 5604, .parameters = &.{} },
    .{ .kind = .capability, .name = "AsmINTEL", .value = 5606, .parameters = &.{} },
    .{ .kind = .capability, .name = "AtomicFloat32MinMaxEXT", .value = 5612, .parameters = &.{} },
    .{ .kind = .capability, .name = "AtomicFloat64MinMaxEXT", .value = 5613, .parameters = &.{} },
    .{ .kind = .capability, .name = "AtomicFloat16MinMaxEXT", .value = 5616, .parameters = &.{} },
    .{ .kind = .capability, .name = "VectorComputeINTEL", .value = 5617, .parameters = &.{} },
    .{ .kind = .capability, .name = "VectorAnyINTEL", .value = 5619, .parameters = &.{} },
    .{ .kind = .capability, .name = "ExpectAssumeKHR", .value = 5629, .parameters = &.{} },
    .{ .kind = .capability, .name = "SubgroupAvcMotionEstimationINTEL", .value = 5696, .parameters = &.{} },
    .{ .kind = .capability, .name = "SubgroupAvcMotionEstimationIntraINTEL", .value = 5697, .parameters = &.{} },
    .{ .kind = .capability, .name = "SubgroupAvcMotionEstimationChromaINTEL", .value = 5698, .parameters = &.{} },
    .{ .kind = .capability, .name = "VariableLengthArrayINTEL", .value = 5817, .parameters = &.{} },
    .{ .kind = .capability, .name = "FunctionFloatControlINTEL", .value = 5821, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGAMemoryAttributesALTERA", .value = 5824, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGAMemoryAttributesINTEL", .value = 5824, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPFastMathModeINTEL", .value = 5837, .parameters = &.{} },
    .{ .kind = .capability, .name = "ArbitraryPrecisionIntegersALTERA", .value = 5844, .parameters = &.{} },
    .{ .kind = .capability, .name = "ArbitraryPrecisionIntegersINTEL", .value = 5844, .parameters = &.{} },
    .{ .kind = .capability, .name = "ArbitraryPrecisionFloatingPointALTERA", .value = 5845, .parameters = &.{} },
    .{ .kind = .capability, .name = "ArbitraryPrecisionFloatingPointINTEL", .value = 5845, .parameters = &.{} },
    .{ .kind = .capability, .name = "UnstructuredLoopControlsINTEL", .value = 5886, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGALoopControlsALTERA", .value = 5888, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGALoopControlsINTEL", .value = 5888, .parameters = &.{} },
    .{ .kind = .capability, .name = "KernelAttributesINTEL", .value = 5892, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGAKernelAttributesINTEL", .value = 5897, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGAMemoryAccessesALTERA", .value = 5898, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGAMemoryAccessesINTEL", .value = 5898, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGAClusterAttributesALTERA", .value = 5904, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGAClusterAttributesINTEL", .value = 5904, .parameters = &.{} },
    .{ .kind = .capability, .name = "LoopFuseALTERA", .value = 5906, .parameters = &.{} },
    .{ .kind = .capability, .name = "LoopFuseINTEL", .value = 5906, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGADSPControlALTERA", .value = 5908, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGADSPControlINTEL", .value = 5908, .parameters = &.{} },
    .{ .kind = .capability, .name = "MemoryAccessAliasingINTEL", .value = 5910, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGAInvocationPipeliningAttributesALTERA", .value = 5916, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGAInvocationPipeliningAttributesINTEL", .value = 5916, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGABufferLocationALTERA", .value = 5920, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGABufferLocationINTEL", .value = 5920, .parameters = &.{} },
    .{ .kind = .capability, .name = "ArbitraryPrecisionFixedPointALTERA", .value = 5922, .parameters = &.{} },
    .{ .kind = .capability, .name = "ArbitraryPrecisionFixedPointINTEL", .value = 5922, .parameters = &.{} },
    .{ .kind = .capability, .name = "USMStorageClassesALTERA", .value = 5935, .parameters = &.{} },
    .{ .kind = .capability, .name = "USMStorageClassesINTEL", .value = 5935, .parameters = &.{} },
    .{ .kind = .capability, .name = "RuntimeAlignedAttributeALTERA", .value = 5939, .parameters = &.{} },
    .{ .kind = .capability, .name = "RuntimeAlignedAttributeINTEL", .value = 5939, .parameters = &.{} },
    .{ .kind = .capability, .name = "IOPipesALTERA", .value = 5943, .parameters = &.{} },
    .{ .kind = .capability, .name = "IOPipesINTEL", .value = 5943, .parameters = &.{} },
    .{ .kind = .capability, .name = "BlockingPipesALTERA", .value = 5945, .parameters = &.{} },
    .{ .kind = .capability, .name = "BlockingPipesINTEL", .value = 5945, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGARegALTERA", .value = 5948, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGARegINTEL", .value = 5948, .parameters = &.{} },
    .{ .kind = .capability, .name = "DotProductInputAll", .value = 6016, .parameters = &.{} },
    .{ .kind = .capability, .name = "DotProductInputAllKHR", .value = 6016, .parameters = &.{} },
    .{ .kind = .capability, .name = "DotProductInput4x8Bit", .value = 6017, .parameters = &.{} },
    .{ .kind = .capability, .name = "DotProductInput4x8BitKHR", .value = 6017, .parameters = &.{} },
    .{ .kind = .capability, .name = "DotProductInput4x8BitPacked", .value = 6018, .parameters = &.{} },
    .{ .kind = .capability, .name = "DotProductInput4x8BitPackedKHR", .value = 6018, .parameters = &.{} },
    .{ .kind = .capability, .name = "DotProduct", .value = 6019, .parameters = &.{} },
    .{ .kind = .capability, .name = "DotProductKHR", .value = 6019, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayCullMaskKHR", .value = 6020, .parameters = &.{} },
    .{ .kind = .capability, .name = "CooperativeMatrixKHR", .value = 6022, .parameters = &.{} },
    .{ .kind = .capability, .name = "ReplicatedCompositesEXT", .value = 6024, .parameters = &.{} },
    .{ .kind = .capability, .name = "BitInstructions", .value = 6025, .parameters = &.{} },
    .{ .kind = .capability, .name = "GroupNonUniformRotateKHR", .value = 6026, .parameters = &.{} },
    .{ .kind = .capability, .name = "FloatControls2", .value = 6029, .parameters = &.{} },
    .{ .kind = .capability, .name = "FMAKHR", .value = 6030, .parameters = &.{} },
    .{ .kind = .capability, .name = "RayTracingOpacityMicromapExecutionModeKHR", .value = 6032, .parameters = &.{} },
    .{ .kind = .capability, .name = "AtomicFloat32AddEXT", .value = 6033, .parameters = &.{} },
    .{ .kind = .capability, .name = "AtomicFloat64AddEXT", .value = 6034, .parameters = &.{} },
    .{ .kind = .capability, .name = "LongCompositesINTEL", .value = 6089, .parameters = &.{} },
    .{ .kind = .capability, .name = "OptNoneEXT", .value = 6094, .parameters = &.{} },
    .{ .kind = .capability, .name = "OptNoneINTEL", .value = 6094, .parameters = &.{} },
    .{ .kind = .capability, .name = "AtomicFloat16AddEXT", .value = 6095, .parameters = &.{} },
    .{ .kind = .capability, .name = "DebugInfoModuleINTEL", .value = 6114, .parameters = &.{} },
    .{ .kind = .capability, .name = "BFloat16ConversionINTEL", .value = 6115, .parameters = &.{} },
    .{ .kind = .capability, .name = "SplitBarrierEXT", .value = 6141, .parameters = &.{} },
    .{ .kind = .capability, .name = "SplitBarrierINTEL", .value = 6141, .parameters = &.{} },
    .{ .kind = .capability, .name = "ArithmeticFenceEXT", .value = 6144, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGAClusterAttributesV2ALTERA", .value = 6150, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGAClusterAttributesV2INTEL", .value = 6150, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGAKernelAttributesv2INTEL", .value = 6161, .parameters = &.{} },
    .{ .kind = .capability, .name = "TaskSequenceALTERA", .value = 6162, .parameters = &.{} },
    .{ .kind = .capability, .name = "TaskSequenceINTEL", .value = 6162, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPMaxErrorINTEL", .value = 6169, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGALatencyControlALTERA", .value = 6171, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGALatencyControlINTEL", .value = 6171, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGAArgumentInterfacesALTERA", .value = 6174, .parameters = &.{} },
    .{ .kind = .capability, .name = "FPGAArgumentInterfacesINTEL", .value = 6174, .parameters = &.{} },
    .{ .kind = .capability, .name = "GlobalVariableHostAccessINTEL", .value = 6187, .parameters = &.{} },
    .{ .kind = .capability, .name = "GlobalVariableFPGADecorationsALTERA", .value = 6189, .parameters = &.{} },
    .{ .kind = .capability, .name = "GlobalVariableFPGADecorationsINTEL", .value = 6189, .parameters = &.{} },
    .{ .kind = .capability, .name = "SubgroupBufferPrefetchINTEL", .value = 6220, .parameters = &.{} },
    .{ .kind = .capability, .name = "Subgroup2DBlockIOINTEL", .value = 6228, .parameters = &.{} },
    .{ .kind = .capability, .name = "Subgroup2DBlockTransformINTEL", .value = 6229, .parameters = &.{} },
    .{ .kind = .capability, .name = "Subgroup2DBlockTransposeINTEL", .value = 6230, .parameters = &.{} },
    .{ .kind = .capability, .name = "SubgroupMatrixMultiplyAccumulateINTEL", .value = 6236, .parameters = &.{} },
    .{ .kind = .capability, .name = "TernaryBitwiseFunctionINTEL", .value = 6241, .parameters = &.{} },
    .{ .kind = .capability, .name = "UntypedVariableLengthArrayINTEL", .value = 6243, .parameters = &.{} },
    .{ .kind = .capability, .name = "SpecConditionalINTEL", .value = 6245, .parameters = &.{} },
    .{ .kind = .capability, .name = "FunctionVariantsINTEL", .value = 6246, .parameters = &.{} },
    .{ .kind = .capability, .name = "PredicatedIOINTEL", .value = 6257, .parameters = &.{} },
    .{ .kind = .capability, .name = "RoundedDivideSqrtINTEL", .value = 6265, .parameters = &.{} },
    .{ .kind = .capability, .name = "GroupUniformArithmeticKHR", .value = 6400, .parameters = &.{} },
    .{ .kind = .capability, .name = "TensorFloat32RoundingINTEL", .value = 6425, .parameters = &.{} },
    .{ .kind = .capability, .name = "MaskedGatherScatterINTEL", .value = 6427, .parameters = &.{} },
    .{ .kind = .capability, .name = "CacheControlsINTEL", .value = 6441, .parameters = &.{} },
    .{ .kind = .capability, .name = "RegisterLimitsINTEL", .value = 6460, .parameters = &.{} },
    .{ .kind = .capability, .name = "BindlessImagesINTEL", .value = 6528, .parameters = &.{} },
    .{ .kind = .capability, .name = "DotProductFloat16AccFloat32VALVE", .value = 6912, .parameters = &.{} },
    .{ .kind = .capability, .name = "DotProductFloat16AccFloat16VALVE", .value = 6913, .parameters = &.{} },
    .{ .kind = .capability, .name = "DotProductBFloat16AccVALVE", .value = 6914, .parameters = &.{} },
    .{ .kind = .capability, .name = "DotProductFloat8AccFloat32VALVE", .value = 6915, .parameters = &.{} },
    .{ .kind = .capability, .name = "IntrinsicSAMSUNG", .value = 7041, .parameters = &.{} },
    .{ .kind = .ray_query_intersection, .name = "RayQueryCandidateIntersectionKHR", .value = 0, .parameters = &.{} },
    .{ .kind = .ray_query_intersection, .name = "RayQueryCommittedIntersectionKHR", .value = 1, .parameters = &.{} },
    .{ .kind = .ray_query_committed_intersection_type, .name = "RayQueryCommittedIntersectionNoneKHR", .value = 0, .parameters = &.{} },
    .{ .kind = .ray_query_committed_intersection_type, .name = "RayQueryCommittedIntersectionTriangleKHR", .value = 1, .parameters = &.{} },
    .{ .kind = .ray_query_committed_intersection_type, .name = "RayQueryCommittedIntersectionGeneratedKHR", .value = 2, .parameters = &.{} },
    .{ .kind = .ray_query_candidate_intersection_type, .name = "RayQueryCandidateIntersectionTriangleKHR", .value = 0, .parameters = &.{} },
    .{ .kind = .ray_query_candidate_intersection_type, .name = "RayQueryCandidateIntersectionAABBKHR", .value = 1, .parameters = &.{} },
    .{ .kind = .packed_vector_format, .name = "PackedVectorFormat4x8Bit", .value = 0, .parameters = &.{} },
    .{ .kind = .packed_vector_format, .name = "PackedVectorFormat4x8BitKHR", .value = 0, .parameters = &.{} },
    .{ .kind = .cooperative_matrix_operands, .name = "NoneKHR", .value = 0, .parameters = &.{} },
    .{ .kind = .cooperative_matrix_operands, .name = "MatrixASignedComponentsKHR", .value = 1, .parameters = &.{} },
    .{ .kind = .cooperative_matrix_operands, .name = "MatrixBSignedComponentsKHR", .value = 2, .parameters = &.{} },
    .{ .kind = .cooperative_matrix_operands, .name = "MatrixCSignedComponentsKHR", .value = 4, .parameters = &.{} },
    .{ .kind = .cooperative_matrix_operands, .name = "MatrixResultSignedComponentsKHR", .value = 8, .parameters = &.{} },
    .{ .kind = .cooperative_matrix_operands, .name = "SaturatingAccumulationKHR", .value = 16, .parameters = &.{} },
    .{ .kind = .cooperative_matrix_layout, .name = "RowMajorKHR", .value = 0, .parameters = &.{} },
    .{ .kind = .cooperative_matrix_layout, .name = "ColumnMajorKHR", .value = 1, .parameters = &.{} },
    .{ .kind = .cooperative_matrix_layout, .name = "RowBlockedInterleavedARM", .value = 4202, .parameters = &.{} },
    .{ .kind = .cooperative_matrix_layout, .name = "ColumnBlockedInterleavedARM", .value = 4203, .parameters = &.{} },
    .{ .kind = .cooperative_matrix_use, .name = "MatrixAKHR", .value = 0, .parameters = &.{} },
    .{ .kind = .cooperative_matrix_use, .name = "MatrixBKHR", .value = 1, .parameters = &.{} },
    .{ .kind = .cooperative_matrix_use, .name = "MatrixAccumulatorKHR", .value = 2, .parameters = &.{} },
    .{ .kind = .cooperative_matrix_reduce, .name = "Row", .value = 1, .parameters = &.{} },
    .{ .kind = .cooperative_matrix_reduce, .name = "Column", .value = 2, .parameters = &.{} },
    .{ .kind = .cooperative_matrix_reduce, .name = "2x2", .value = 4, .parameters = &.{} },
    .{ .kind = .tensor_clamp_mode, .name = "Undefined", .value = 0, .parameters = &.{} },
    .{ .kind = .tensor_clamp_mode, .name = "Constant", .value = 1, .parameters = &.{} },
    .{ .kind = .tensor_clamp_mode, .name = "ClampToEdge", .value = 2, .parameters = &.{} },
    .{ .kind = .tensor_clamp_mode, .name = "Repeat", .value = 3, .parameters = &.{} },
    .{ .kind = .tensor_clamp_mode, .name = "RepeatMirrored", .value = 4, .parameters = &.{} },
    .{ .kind = .tensor_addressing_operands, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .tensor_addressing_operands, .name = "TensorView", .value = 1, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .tensor_addressing_operands, .name = "DecodeFunc", .value = 2, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .tensor_addressing_operands, .name = "DecodeVectorFunc", .value = 4, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .initialization_mode_qualifier, .name = "InitOnDeviceReprogramALTERA", .value = 0, .parameters = &.{} },
    .{ .kind = .initialization_mode_qualifier, .name = "InitOnDeviceReprogramINTEL", .value = 0, .parameters = &.{} },
    .{ .kind = .initialization_mode_qualifier, .name = "InitOnDeviceResetALTERA", .value = 1, .parameters = &.{} },
    .{ .kind = .initialization_mode_qualifier, .name = "InitOnDeviceResetINTEL", .value = 1, .parameters = &.{} },
    .{ .kind = .load_cache_control, .name = "UncachedINTEL", .value = 0, .parameters = &.{} },
    .{ .kind = .load_cache_control, .name = "CachedINTEL", .value = 1, .parameters = &.{} },
    .{ .kind = .load_cache_control, .name = "StreamingINTEL", .value = 2, .parameters = &.{} },
    .{ .kind = .load_cache_control, .name = "InvalidateAfterReadINTEL", .value = 3, .parameters = &.{} },
    .{ .kind = .load_cache_control, .name = "ConstCachedINTEL", .value = 4, .parameters = &.{} },
    .{ .kind = .store_cache_control, .name = "UncachedINTEL", .value = 0, .parameters = &.{} },
    .{ .kind = .store_cache_control, .name = "WriteThroughINTEL", .value = 1, .parameters = &.{} },
    .{ .kind = .store_cache_control, .name = "WriteBackINTEL", .value = 2, .parameters = &.{} },
    .{ .kind = .store_cache_control, .name = "StreamingINTEL", .value = 3, .parameters = &.{} },
    .{ .kind = .named_maximum_number_of_registers, .name = "AutoINTEL", .value = 0, .parameters = &.{} },
    .{ .kind = .matrix_multiply_accumulate_operands, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .matrix_multiply_accumulate_operands, .name = "MatrixASignedComponentsINTEL", .value = 1, .parameters = &.{} },
    .{ .kind = .matrix_multiply_accumulate_operands, .name = "MatrixBSignedComponentsINTEL", .value = 2, .parameters = &.{} },
    .{ .kind = .matrix_multiply_accumulate_operands, .name = "MatrixCBFloat16INTEL", .value = 4, .parameters = &.{} },
    .{ .kind = .matrix_multiply_accumulate_operands, .name = "MatrixResultBFloat16INTEL", .value = 8, .parameters = &.{} },
    .{ .kind = .matrix_multiply_accumulate_operands, .name = "MatrixAPackedInt8INTEL", .value = 16, .parameters = &.{} },
    .{ .kind = .matrix_multiply_accumulate_operands, .name = "MatrixBPackedInt8INTEL", .value = 32, .parameters = &.{} },
    .{ .kind = .matrix_multiply_accumulate_operands, .name = "MatrixAPackedInt4INTEL", .value = 64, .parameters = &.{} },
    .{ .kind = .matrix_multiply_accumulate_operands, .name = "MatrixBPackedInt4INTEL", .value = 128, .parameters = &.{} },
    .{ .kind = .matrix_multiply_accumulate_operands, .name = "MatrixATF32INTEL", .value = 256, .parameters = &.{} },
    .{ .kind = .matrix_multiply_accumulate_operands, .name = "MatrixBTF32INTEL", .value = 512, .parameters = &.{} },
    .{ .kind = .matrix_multiply_accumulate_operands, .name = "MatrixAPackedFloat16INTEL", .value = 1024, .parameters = &.{} },
    .{ .kind = .matrix_multiply_accumulate_operands, .name = "MatrixBPackedFloat16INTEL", .value = 2048, .parameters = &.{} },
    .{ .kind = .matrix_multiply_accumulate_operands, .name = "MatrixAPackedBFloat16INTEL", .value = 4096, .parameters = &.{} },
    .{ .kind = .matrix_multiply_accumulate_operands, .name = "MatrixBPackedBFloat16INTEL", .value = 8192, .parameters = &.{} },
    .{ .kind = .fp_encoding, .name = "BFloat16KHR", .value = 0, .parameters = &.{} },
    .{ .kind = .fp_encoding, .name = "Float8E4M3EXT", .value = 4214, .parameters = &.{} },
    .{ .kind = .fp_encoding, .name = "Float8E5M2EXT", .value = 4215, .parameters = &.{} },
    .{ .kind = .fp_encoding, .name = "Float6E2M3EXT", .value = 4223, .parameters = &.{} },
    .{ .kind = .fp_encoding, .name = "Float6E3M2EXT", .value = 4224, .parameters = &.{} },
    .{ .kind = .fp_encoding, .name = "Float4E2M1EXT", .value = 4225, .parameters = &.{} },
    .{ .kind = .fp_encoding, .name = "Float8UnsignedE8M0EXT", .value = 4226, .parameters = &.{} },
    .{ .kind = .fp_encoding, .name = "MXInt8EXT", .value = 4227, .parameters = &.{} },
    .{ .kind = .cooperative_vector_matrix_layout, .name = "RowMajorNV", .value = 0, .parameters = &.{} },
    .{ .kind = .cooperative_vector_matrix_layout, .name = "ColumnMajorNV", .value = 1, .parameters = &.{} },
    .{ .kind = .cooperative_vector_matrix_layout, .name = "InferencingOptimalNV", .value = 2, .parameters = &.{} },
    .{ .kind = .cooperative_vector_matrix_layout, .name = "TrainingOptimalNV", .value = 3, .parameters = &.{} },
    .{ .kind = .component_type, .name = "Float16NV", .value = 0, .parameters = &.{} },
    .{ .kind = .component_type, .name = "Float32NV", .value = 1, .parameters = &.{} },
    .{ .kind = .component_type, .name = "Float64NV", .value = 2, .parameters = &.{} },
    .{ .kind = .component_type, .name = "SignedInt8NV", .value = 3, .parameters = &.{} },
    .{ .kind = .component_type, .name = "SignedInt16NV", .value = 4, .parameters = &.{} },
    .{ .kind = .component_type, .name = "SignedInt32NV", .value = 5, .parameters = &.{} },
    .{ .kind = .component_type, .name = "SignedInt64NV", .value = 6, .parameters = &.{} },
    .{ .kind = .component_type, .name = "UnsignedInt8NV", .value = 7, .parameters = &.{} },
    .{ .kind = .component_type, .name = "UnsignedInt16NV", .value = 8, .parameters = &.{} },
    .{ .kind = .component_type, .name = "UnsignedInt32NV", .value = 9, .parameters = &.{} },
    .{ .kind = .component_type, .name = "UnsignedInt64NV", .value = 10, .parameters = &.{} },
    .{ .kind = .component_type, .name = "SignedInt8PackedNV", .value = 1000491000, .parameters = &.{} },
    .{ .kind = .component_type, .name = "UnsignedInt8PackedNV", .value = 1000491001, .parameters = &.{} },
    .{ .kind = .component_type, .name = "FloatE4M3NV", .value = 1000491002, .parameters = &.{} },
    .{ .kind = .component_type, .name = "FloatE5M2NV", .value = 1000491003, .parameters = &.{} },
    .{ .kind = .gather_modes, .name = "Gather4x1QCOM", .value = 0, .parameters = &.{} },
    .{ .kind = .gather_modes, .name = "GatherDQCOM", .value = 1, .parameters = &.{} },
    .{ .kind = .gather_modes, .name = "GatherH2QCOM", .value = 2, .parameters = &.{} },
    .{ .kind = .gather_modes, .name = "GatherV2QCOM", .value = 3, .parameters = &.{} },
    .{ .kind = .tensor_operands, .name = "NoneARM", .value = 0, .parameters = &.{} },
    .{ .kind = .tensor_operands, .name = "NontemporalARM", .value = 1, .parameters = &.{} },
    .{ .kind = .tensor_operands, .name = "OutOfBoundsValueARM", .value = 2, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .tensor_operands, .name = "MakeElementAvailableARM", .value = 4, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .tensor_operands, .name = "MakeElementVisibleARM", .value = 8, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .tensor_operands, .name = "NonPrivateElementARM", .value = 16, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagIsProtected", .value = 1, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagIsPrivate", .value = 2, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagIsPublic", .value = 3, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagIsLocal", .value = 4, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagIsDefinition", .value = 8, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagFwdDecl", .value = 16, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagArtificial", .value = 32, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagExplicit", .value = 64, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagPrototyped", .value = 128, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagObjectPointer", .value = 256, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagStaticMember", .value = 512, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagIndirectVariable", .value = 1024, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagLValueReference", .value = 2048, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagRValueReference", .value = 4096, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagIsOptimized", .value = 8192, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagIsEnumClass", .value = 16384, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagTypePassByValue", .value = 32768, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .name = "FlagTypePassByReference", .value = 65536, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_base_type_attribute_encoding, .name = "Unspecified", .value = 0, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_base_type_attribute_encoding, .name = "Address", .value = 1, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_base_type_attribute_encoding, .name = "Boolean", .value = 2, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_base_type_attribute_encoding, .name = "Float", .value = 3, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_base_type_attribute_encoding, .name = "Signed", .value = 4, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_base_type_attribute_encoding, .name = "SignedChar", .value = 5, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_base_type_attribute_encoding, .name = "Unsigned", .value = 6, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_base_type_attribute_encoding, .name = "UnsignedChar", .value = 7, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_composite_type, .name = "Class", .value = 0, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_composite_type, .name = "Structure", .value = 1, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_composite_type, .name = "Union", .value = 2, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_type_qualifier, .name = "ConstType", .value = 0, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_type_qualifier, .name = "VolatileType", .value = 1, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_type_qualifier, .name = "RestrictType", .value = 2, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_type_qualifier, .name = "AtomicType", .value = 3, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_operation, .name = "Deref", .value = 0, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_operation, .name = "Plus", .value = 1, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_operation, .name = "Minus", .value = 2, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_operation, .name = "PlusUconst", .value = 3, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .opencl_debug_info_100_debug_operation, .name = "BitPiece", .value = 4, .parameters = &.{ .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one } } },
    .{ .kind = .opencl_debug_info_100_debug_operation, .name = "Swap", .value = 5, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_operation, .name = "Xderef", .value = 6, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_operation, .name = "StackValue", .value = 7, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_operation, .name = "Constu", .value = 8, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .opencl_debug_info_100_debug_operation, .name = "Fragment", .value = 9, .parameters = &.{ .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one } } },
    .{ .kind = .opencl_debug_info_100_debug_imported_entity, .name = "ImportedModule", .value = 0, .parameters = &.{} },
    .{ .kind = .opencl_debug_info_100_debug_imported_entity, .name = "ImportedDeclaration", .value = 1, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagIsProtected", .value = 1, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagIsPrivate", .value = 2, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagIsPublic", .value = 3, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagIsLocal", .value = 4, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagIsDefinition", .value = 8, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagFwdDecl", .value = 16, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagArtificial", .value = 32, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagExplicit", .value = 64, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagPrototyped", .value = 128, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagObjectPointer", .value = 256, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagStaticMember", .value = 512, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagIndirectVariable", .value = 1024, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagLValueReference", .value = 2048, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagRValueReference", .value = 4096, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagIsOptimized", .value = 8192, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagIsEnumClass", .value = 16384, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagTypePassByValue", .value = 32768, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagTypePassByReference", .value = 65536, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_info_flags, .name = "FlagUnknownPhysicalLayout", .value = 131072, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_build_identifier_flags, .name = "IdentifierPossibleDuplicates", .value = 1, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_base_type_attribute_encoding, .name = "Unspecified", .value = 0, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_base_type_attribute_encoding, .name = "Address", .value = 1, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_base_type_attribute_encoding, .name = "Boolean", .value = 2, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_base_type_attribute_encoding, .name = "Float", .value = 3, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_base_type_attribute_encoding, .name = "Signed", .value = 4, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_base_type_attribute_encoding, .name = "SignedChar", .value = 5, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_base_type_attribute_encoding, .name = "Unsigned", .value = 6, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_base_type_attribute_encoding, .name = "UnsignedChar", .value = 7, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_composite_type, .name = "Class", .value = 0, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_composite_type, .name = "Structure", .value = 1, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_composite_type, .name = "Union", .value = 2, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_type_qualifier, .name = "ConstType", .value = 0, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_type_qualifier, .name = "VolatileType", .value = 1, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_type_qualifier, .name = "RestrictType", .value = 2, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_type_qualifier, .name = "AtomicType", .value = 3, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_operation, .name = "Deref", .value = 0, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_operation, .name = "Plus", .value = 1, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_operation, .name = "Minus", .value = 2, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_operation, .name = "PlusUconst", .value = 3, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_operation, .name = "BitPiece", .value = 4, .parameters = &.{ .{ .kind = .id_ref, .quantifier = .one }, .{ .kind = .id_ref, .quantifier = .one } } },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_operation, .name = "Swap", .value = 5, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_operation, .name = "Xderef", .value = 6, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_operation, .name = "StackValue", .value = 7, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_operation, .name = "Constu", .value = 8, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_operation, .name = "Fragment", .value = 9, .parameters = &.{ .{ .kind = .id_ref, .quantifier = .one }, .{ .kind = .id_ref, .quantifier = .one } } },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_imported_entity, .name = "ImportedModule", .value = 0, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_100_debug_imported_entity, .name = "ImportedDeclaration", .value = 1, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagIsProtected", .value = 1, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagIsPrivate", .value = 2, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagIsPublic", .value = 3, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagIsLocal", .value = 4, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagIsDefinition", .value = 8, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagFwdDecl", .value = 16, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagArtificial", .value = 32, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagExplicit", .value = 64, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagPrototyped", .value = 128, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagObjectPointer", .value = 256, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagStaticMember", .value = 512, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagIndirectVariable", .value = 1024, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagLValueReference", .value = 2048, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagRValueReference", .value = 4096, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagIsOptimized", .value = 8192, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagIsEnumClass", .value = 16384, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagTypePassByValue", .value = 32768, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagTypePassByReference", .value = 65536, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_info_flags, .name = "FlagUnknownPhysicalLayout", .value = 131072, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_build_identifier_flags, .name = "IdentifierPossibleDuplicates", .value = 1, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_base_type_attribute_encoding, .name = "Unspecified", .value = 0, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_base_type_attribute_encoding, .name = "Address", .value = 1, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_base_type_attribute_encoding, .name = "Boolean", .value = 2, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_base_type_attribute_encoding, .name = "Float", .value = 3, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_base_type_attribute_encoding, .name = "Signed", .value = 4, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_base_type_attribute_encoding, .name = "SignedChar", .value = 5, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_base_type_attribute_encoding, .name = "Unsigned", .value = 6, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_base_type_attribute_encoding, .name = "UnsignedChar", .value = 7, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_composite_type, .name = "Class", .value = 0, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_composite_type, .name = "Structure", .value = 1, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_composite_type, .name = "Union", .value = 2, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_type_qualifier, .name = "ConstType", .value = 0, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_type_qualifier, .name = "VolatileType", .value = 1, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_type_qualifier, .name = "RestrictType", .value = 2, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_type_qualifier, .name = "AtomicType", .value = 3, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_operation, .name = "Deref", .value = 0, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_operation, .name = "Plus", .value = 1, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_operation, .name = "Minus", .value = 2, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_operation, .name = "PlusUconst", .value = 3, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_operation, .name = "BitPiece", .value = 4, .parameters = &.{ .{ .kind = .id_ref, .quantifier = .one }, .{ .kind = .id_ref, .quantifier = .one } } },
    .{ .kind = .nonsemantic_shader_debug_info_debug_operation, .name = "Swap", .value = 5, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_operation, .name = "Xderef", .value = 6, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_operation, .name = "StackValue", .value = 7, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_operation, .name = "Constu", .value = 8, .parameters = &.{.{ .kind = .id_ref, .quantifier = .one }} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_operation, .name = "Fragment", .value = 9, .parameters = &.{ .{ .kind = .id_ref, .quantifier = .one }, .{ .kind = .id_ref, .quantifier = .one } } },
    .{ .kind = .nonsemantic_shader_debug_info_debug_imported_entity, .name = "ImportedModule", .value = 0, .parameters = &.{} },
    .{ .kind = .nonsemantic_shader_debug_info_debug_imported_entity, .name = "ImportedDeclaration", .value = 1, .parameters = &.{} },
    .{ .kind = .debug_info_debug_info_flags, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .debug_info_debug_info_flags, .name = "FlagIsProtected", .value = 1, .parameters = &.{} },
    .{ .kind = .debug_info_debug_info_flags, .name = "FlagIsPrivate", .value = 2, .parameters = &.{} },
    .{ .kind = .debug_info_debug_info_flags, .name = "FlagIsPublic", .value = 3, .parameters = &.{} },
    .{ .kind = .debug_info_debug_info_flags, .name = "FlagIsLocal", .value = 4, .parameters = &.{} },
    .{ .kind = .debug_info_debug_info_flags, .name = "FlagIsDefinition", .value = 8, .parameters = &.{} },
    .{ .kind = .debug_info_debug_info_flags, .name = "FlagFwdDecl", .value = 16, .parameters = &.{} },
    .{ .kind = .debug_info_debug_info_flags, .name = "FlagArtificial", .value = 32, .parameters = &.{} },
    .{ .kind = .debug_info_debug_info_flags, .name = "FlagExplicit", .value = 64, .parameters = &.{} },
    .{ .kind = .debug_info_debug_info_flags, .name = "FlagPrototyped", .value = 128, .parameters = &.{} },
    .{ .kind = .debug_info_debug_info_flags, .name = "FlagObjectPointer", .value = 256, .parameters = &.{} },
    .{ .kind = .debug_info_debug_info_flags, .name = "FlagStaticMember", .value = 512, .parameters = &.{} },
    .{ .kind = .debug_info_debug_info_flags, .name = "FlagIndirectVariable", .value = 1024, .parameters = &.{} },
    .{ .kind = .debug_info_debug_info_flags, .name = "FlagLValueReference", .value = 2048, .parameters = &.{} },
    .{ .kind = .debug_info_debug_info_flags, .name = "FlagRValueReference", .value = 4096, .parameters = &.{} },
    .{ .kind = .debug_info_debug_info_flags, .name = "FlagIsOptimized", .value = 8192, .parameters = &.{} },
    .{ .kind = .debug_info_debug_base_type_attribute_encoding, .name = "Unspecified", .value = 0, .parameters = &.{} },
    .{ .kind = .debug_info_debug_base_type_attribute_encoding, .name = "Address", .value = 1, .parameters = &.{} },
    .{ .kind = .debug_info_debug_base_type_attribute_encoding, .name = "Boolean", .value = 2, .parameters = &.{} },
    .{ .kind = .debug_info_debug_base_type_attribute_encoding, .name = "Float", .value = 4, .parameters = &.{} },
    .{ .kind = .debug_info_debug_base_type_attribute_encoding, .name = "Signed", .value = 5, .parameters = &.{} },
    .{ .kind = .debug_info_debug_base_type_attribute_encoding, .name = "SignedChar", .value = 6, .parameters = &.{} },
    .{ .kind = .debug_info_debug_base_type_attribute_encoding, .name = "Unsigned", .value = 7, .parameters = &.{} },
    .{ .kind = .debug_info_debug_base_type_attribute_encoding, .name = "UnsignedChar", .value = 8, .parameters = &.{} },
    .{ .kind = .debug_info_debug_composite_type, .name = "Class", .value = 0, .parameters = &.{} },
    .{ .kind = .debug_info_debug_composite_type, .name = "Structure", .value = 1, .parameters = &.{} },
    .{ .kind = .debug_info_debug_composite_type, .name = "Union", .value = 2, .parameters = &.{} },
    .{ .kind = .debug_info_debug_type_qualifier, .name = "ConstType", .value = 0, .parameters = &.{} },
    .{ .kind = .debug_info_debug_type_qualifier, .name = "VolatileType", .value = 1, .parameters = &.{} },
    .{ .kind = .debug_info_debug_type_qualifier, .name = "RestrictType", .value = 2, .parameters = &.{} },
    .{ .kind = .debug_info_debug_operation, .name = "Deref", .value = 0, .parameters = &.{} },
    .{ .kind = .debug_info_debug_operation, .name = "Plus", .value = 1, .parameters = &.{} },
    .{ .kind = .debug_info_debug_operation, .name = "Minus", .value = 2, .parameters = &.{} },
    .{ .kind = .debug_info_debug_operation, .name = "PlusUconst", .value = 3, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .debug_info_debug_operation, .name = "BitPiece", .value = 4, .parameters = &.{ .{ .kind = .literal_integer, .quantifier = .one }, .{ .kind = .literal_integer, .quantifier = .one } } },
    .{ .kind = .debug_info_debug_operation, .name = "Swap", .value = 5, .parameters = &.{} },
    .{ .kind = .debug_info_debug_operation, .name = "Xderef", .value = 6, .parameters = &.{} },
    .{ .kind = .debug_info_debug_operation, .name = "StackValue", .value = 7, .parameters = &.{} },
    .{ .kind = .debug_info_debug_operation, .name = "Constu", .value = 8, .parameters = &.{.{ .kind = .literal_integer, .quantifier = .one }} },
    .{ .kind = .nonsemantic_clspv_reflection_kernel_property_flags, .name = "None", .value = 0, .parameters = &.{} },
    .{ .kind = .nonsemantic_clspv_reflection_kernel_property_flags, .name = "MayUsePrintf", .value = 1, .parameters = &.{} },
};

const spec_operands_access_chain = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const spec_operands_in_bounds_access_chain = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const spec_operands_ptr_access_chain = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const spec_operands_in_bounds_ptr_access_chain = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const spec_operands_vector_shuffle = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .variable },
};
const spec_operands_composite_extract = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .variable },
};
const spec_operands_composite_insert = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .variable },
};
const spec_operands_convert_f_to_u = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_convert_f_to_s = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_convert_s_to_f = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_convert_u_to_f = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_u_convert = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_s_convert = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_f_convert = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_quantize_to_f16 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_convert_ptr_to_u = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_convert_u_to_ptr = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_ptr_cast_to_generic = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_generic_cast_to_ptr = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_bitcast = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_s_negate = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_f_negate = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_i_add = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_f_add = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_i_sub = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_f_sub = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_i_mul = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_f_mul = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_u_div = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_s_div = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_f_div = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_u_mod = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_s_rem = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_s_mod = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_f_rem = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_f_mod = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_logical_equal = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_logical_not_equal = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_logical_or = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_logical_and = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_logical_not = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_select = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_i_equal = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_i_not_equal = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_u_greater_than = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_s_greater_than = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_u_greater_than_equal = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_s_greater_than_equal = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_u_less_than = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_s_less_than = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_u_less_than_equal = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_s_less_than_equal = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_shift_right_logical = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_shift_right_arithmetic = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_shift_left_logical = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_bitwise_or = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_bitwise_xor = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_bitwise_and = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const spec_operands_not = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};

pub const spec_constant_opcodes = [_]OpcodeInfo{
    .{ .name = "AccessChain", .opcode = 65, .operands = &spec_operands_access_chain },
    .{ .name = "InBoundsAccessChain", .opcode = 66, .operands = &spec_operands_in_bounds_access_chain },
    .{ .name = "PtrAccessChain", .opcode = 67, .operands = &spec_operands_ptr_access_chain },
    .{ .name = "InBoundsPtrAccessChain", .opcode = 70, .operands = &spec_operands_in_bounds_ptr_access_chain },
    .{ .name = "VectorShuffle", .opcode = 79, .operands = &spec_operands_vector_shuffle },
    .{ .name = "CompositeExtract", .opcode = 81, .operands = &spec_operands_composite_extract },
    .{ .name = "CompositeInsert", .opcode = 82, .operands = &spec_operands_composite_insert },
    .{ .name = "ConvertFToU", .opcode = 109, .operands = &spec_operands_convert_f_to_u },
    .{ .name = "ConvertFToS", .opcode = 110, .operands = &spec_operands_convert_f_to_s },
    .{ .name = "ConvertSToF", .opcode = 111, .operands = &spec_operands_convert_s_to_f },
    .{ .name = "ConvertUToF", .opcode = 112, .operands = &spec_operands_convert_u_to_f },
    .{ .name = "UConvert", .opcode = 113, .operands = &spec_operands_u_convert },
    .{ .name = "SConvert", .opcode = 114, .operands = &spec_operands_s_convert },
    .{ .name = "FConvert", .opcode = 115, .operands = &spec_operands_f_convert },
    .{ .name = "QuantizeToF16", .opcode = 116, .operands = &spec_operands_quantize_to_f16 },
    .{ .name = "ConvertPtrToU", .opcode = 117, .operands = &spec_operands_convert_ptr_to_u },
    .{ .name = "ConvertUToPtr", .opcode = 120, .operands = &spec_operands_convert_u_to_ptr },
    .{ .name = "PtrCastToGeneric", .opcode = 121, .operands = &spec_operands_ptr_cast_to_generic },
    .{ .name = "GenericCastToPtr", .opcode = 122, .operands = &spec_operands_generic_cast_to_ptr },
    .{ .name = "Bitcast", .opcode = 124, .operands = &spec_operands_bitcast },
    .{ .name = "SNegate", .opcode = 126, .operands = &spec_operands_s_negate },
    .{ .name = "FNegate", .opcode = 127, .operands = &spec_operands_f_negate },
    .{ .name = "IAdd", .opcode = 128, .operands = &spec_operands_i_add },
    .{ .name = "FAdd", .opcode = 129, .operands = &spec_operands_f_add },
    .{ .name = "ISub", .opcode = 130, .operands = &spec_operands_i_sub },
    .{ .name = "FSub", .opcode = 131, .operands = &spec_operands_f_sub },
    .{ .name = "IMul", .opcode = 132, .operands = &spec_operands_i_mul },
    .{ .name = "FMul", .opcode = 133, .operands = &spec_operands_f_mul },
    .{ .name = "UDiv", .opcode = 134, .operands = &spec_operands_u_div },
    .{ .name = "SDiv", .opcode = 135, .operands = &spec_operands_s_div },
    .{ .name = "FDiv", .opcode = 136, .operands = &spec_operands_f_div },
    .{ .name = "UMod", .opcode = 137, .operands = &spec_operands_u_mod },
    .{ .name = "SRem", .opcode = 138, .operands = &spec_operands_s_rem },
    .{ .name = "SMod", .opcode = 139, .operands = &spec_operands_s_mod },
    .{ .name = "FRem", .opcode = 140, .operands = &spec_operands_f_rem },
    .{ .name = "FMod", .opcode = 141, .operands = &spec_operands_f_mod },
    .{ .name = "LogicalEqual", .opcode = 164, .operands = &spec_operands_logical_equal },
    .{ .name = "LogicalNotEqual", .opcode = 165, .operands = &spec_operands_logical_not_equal },
    .{ .name = "LogicalOr", .opcode = 166, .operands = &spec_operands_logical_or },
    .{ .name = "LogicalAnd", .opcode = 167, .operands = &spec_operands_logical_and },
    .{ .name = "LogicalNot", .opcode = 168, .operands = &spec_operands_logical_not },
    .{ .name = "Select", .opcode = 169, .operands = &spec_operands_select },
    .{ .name = "IEqual", .opcode = 170, .operands = &spec_operands_i_equal },
    .{ .name = "INotEqual", .opcode = 171, .operands = &spec_operands_i_not_equal },
    .{ .name = "UGreaterThan", .opcode = 172, .operands = &spec_operands_u_greater_than },
    .{ .name = "SGreaterThan", .opcode = 173, .operands = &spec_operands_s_greater_than },
    .{ .name = "UGreaterThanEqual", .opcode = 174, .operands = &spec_operands_u_greater_than_equal },
    .{ .name = "SGreaterThanEqual", .opcode = 175, .operands = &spec_operands_s_greater_than_equal },
    .{ .name = "ULessThan", .opcode = 176, .operands = &spec_operands_u_less_than },
    .{ .name = "SLessThan", .opcode = 177, .operands = &spec_operands_s_less_than },
    .{ .name = "ULessThanEqual", .opcode = 178, .operands = &spec_operands_u_less_than_equal },
    .{ .name = "SLessThanEqual", .opcode = 179, .operands = &spec_operands_s_less_than_equal },
    .{ .name = "ShiftRightLogical", .opcode = 194, .operands = &spec_operands_shift_right_logical },
    .{ .name = "ShiftRightArithmetic", .opcode = 195, .operands = &spec_operands_shift_right_arithmetic },
    .{ .name = "ShiftLeftLogical", .opcode = 196, .operands = &spec_operands_shift_left_logical },
    .{ .name = "BitwiseOr", .opcode = 197, .operands = &spec_operands_bitwise_or },
    .{ .name = "BitwiseXor", .opcode = 198, .operands = &spec_operands_bitwise_xor },
    .{ .name = "BitwiseAnd", .opcode = 199, .operands = &spec_operands_bitwise_and },
    .{ .name = "Not", .opcode = 200, .operands = &spec_operands_not },
};

const glsl_std_450_ext_operands_round = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_round_even = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_trunc = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_f_abs = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_s_abs = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_f_sign = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_s_sign = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_floor = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_ceil = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_fract = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_radians = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_degrees = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_sin = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_cos = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_tan = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_asin = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_acos = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_atan = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_sinh = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_cosh = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_tanh = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_asinh = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_acosh = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_atanh = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_atan2 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_pow = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_exp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_log = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_exp2 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_log2 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_sqrt = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_inverse_sqrt = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_determinant = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_matrix_inverse = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_modf = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_modf_struct = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_f_min = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_u_min = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_s_min = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_f_max = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_u_max = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_s_max = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_f_clamp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_u_clamp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_s_clamp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_f_mix = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_i_mix = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_step = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_smooth_step = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_fma = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_frexp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_frexp_struct = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_ldexp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_pack_snorm4x8 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_pack_unorm4x8 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_pack_snorm2x16 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_pack_unorm2x16 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_pack_half2x16 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_pack_double2x32 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_unpack_snorm2x16 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_unpack_unorm2x16 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_unpack_half2x16 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_unpack_snorm4x8 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_unpack_unorm4x8 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_unpack_double2x32 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_length = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_distance = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_cross = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_normalize = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_face_forward = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_reflect = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_refract = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_find_i_lsb = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_find_s_msb = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_find_u_msb = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_interpolate_at_centroid = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_interpolate_at_sample = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_interpolate_at_offset = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_n_min = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_n_max = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const glsl_std_450_ext_operands_n_clamp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};

pub const glsl_std_450_extinsts = [_]ExtInstInfo{
    .{ .name = "Round", .value = 1, .operands = &glsl_std_450_ext_operands_round },
    .{ .name = "RoundEven", .value = 2, .operands = &glsl_std_450_ext_operands_round_even },
    .{ .name = "Trunc", .value = 3, .operands = &glsl_std_450_ext_operands_trunc },
    .{ .name = "FAbs", .value = 4, .operands = &glsl_std_450_ext_operands_f_abs },
    .{ .name = "SAbs", .value = 5, .operands = &glsl_std_450_ext_operands_s_abs },
    .{ .name = "FSign", .value = 6, .operands = &glsl_std_450_ext_operands_f_sign },
    .{ .name = "SSign", .value = 7, .operands = &glsl_std_450_ext_operands_s_sign },
    .{ .name = "Floor", .value = 8, .operands = &glsl_std_450_ext_operands_floor },
    .{ .name = "Ceil", .value = 9, .operands = &glsl_std_450_ext_operands_ceil },
    .{ .name = "Fract", .value = 10, .operands = &glsl_std_450_ext_operands_fract },
    .{ .name = "Radians", .value = 11, .operands = &glsl_std_450_ext_operands_radians },
    .{ .name = "Degrees", .value = 12, .operands = &glsl_std_450_ext_operands_degrees },
    .{ .name = "Sin", .value = 13, .operands = &glsl_std_450_ext_operands_sin },
    .{ .name = "Cos", .value = 14, .operands = &glsl_std_450_ext_operands_cos },
    .{ .name = "Tan", .value = 15, .operands = &glsl_std_450_ext_operands_tan },
    .{ .name = "Asin", .value = 16, .operands = &glsl_std_450_ext_operands_asin },
    .{ .name = "Acos", .value = 17, .operands = &glsl_std_450_ext_operands_acos },
    .{ .name = "Atan", .value = 18, .operands = &glsl_std_450_ext_operands_atan },
    .{ .name = "Sinh", .value = 19, .operands = &glsl_std_450_ext_operands_sinh },
    .{ .name = "Cosh", .value = 20, .operands = &glsl_std_450_ext_operands_cosh },
    .{ .name = "Tanh", .value = 21, .operands = &glsl_std_450_ext_operands_tanh },
    .{ .name = "Asinh", .value = 22, .operands = &glsl_std_450_ext_operands_asinh },
    .{ .name = "Acosh", .value = 23, .operands = &glsl_std_450_ext_operands_acosh },
    .{ .name = "Atanh", .value = 24, .operands = &glsl_std_450_ext_operands_atanh },
    .{ .name = "Atan2", .value = 25, .operands = &glsl_std_450_ext_operands_atan2 },
    .{ .name = "Pow", .value = 26, .operands = &glsl_std_450_ext_operands_pow },
    .{ .name = "Exp", .value = 27, .operands = &glsl_std_450_ext_operands_exp },
    .{ .name = "Log", .value = 28, .operands = &glsl_std_450_ext_operands_log },
    .{ .name = "Exp2", .value = 29, .operands = &glsl_std_450_ext_operands_exp2 },
    .{ .name = "Log2", .value = 30, .operands = &glsl_std_450_ext_operands_log2 },
    .{ .name = "Sqrt", .value = 31, .operands = &glsl_std_450_ext_operands_sqrt },
    .{ .name = "InverseSqrt", .value = 32, .operands = &glsl_std_450_ext_operands_inverse_sqrt },
    .{ .name = "Determinant", .value = 33, .operands = &glsl_std_450_ext_operands_determinant },
    .{ .name = "MatrixInverse", .value = 34, .operands = &glsl_std_450_ext_operands_matrix_inverse },
    .{ .name = "Modf", .value = 35, .operands = &glsl_std_450_ext_operands_modf },
    .{ .name = "ModfStruct", .value = 36, .operands = &glsl_std_450_ext_operands_modf_struct },
    .{ .name = "FMin", .value = 37, .operands = &glsl_std_450_ext_operands_f_min },
    .{ .name = "UMin", .value = 38, .operands = &glsl_std_450_ext_operands_u_min },
    .{ .name = "SMin", .value = 39, .operands = &glsl_std_450_ext_operands_s_min },
    .{ .name = "FMax", .value = 40, .operands = &glsl_std_450_ext_operands_f_max },
    .{ .name = "UMax", .value = 41, .operands = &glsl_std_450_ext_operands_u_max },
    .{ .name = "SMax", .value = 42, .operands = &glsl_std_450_ext_operands_s_max },
    .{ .name = "FClamp", .value = 43, .operands = &glsl_std_450_ext_operands_f_clamp },
    .{ .name = "UClamp", .value = 44, .operands = &glsl_std_450_ext_operands_u_clamp },
    .{ .name = "SClamp", .value = 45, .operands = &glsl_std_450_ext_operands_s_clamp },
    .{ .name = "FMix", .value = 46, .operands = &glsl_std_450_ext_operands_f_mix },
    .{ .name = "IMix", .value = 47, .operands = &glsl_std_450_ext_operands_i_mix },
    .{ .name = "Step", .value = 48, .operands = &glsl_std_450_ext_operands_step },
    .{ .name = "SmoothStep", .value = 49, .operands = &glsl_std_450_ext_operands_smooth_step },
    .{ .name = "Fma", .value = 50, .operands = &glsl_std_450_ext_operands_fma },
    .{ .name = "Frexp", .value = 51, .operands = &glsl_std_450_ext_operands_frexp },
    .{ .name = "FrexpStruct", .value = 52, .operands = &glsl_std_450_ext_operands_frexp_struct },
    .{ .name = "Ldexp", .value = 53, .operands = &glsl_std_450_ext_operands_ldexp },
    .{ .name = "PackSnorm4x8", .value = 54, .operands = &glsl_std_450_ext_operands_pack_snorm4x8 },
    .{ .name = "PackUnorm4x8", .value = 55, .operands = &glsl_std_450_ext_operands_pack_unorm4x8 },
    .{ .name = "PackSnorm2x16", .value = 56, .operands = &glsl_std_450_ext_operands_pack_snorm2x16 },
    .{ .name = "PackUnorm2x16", .value = 57, .operands = &glsl_std_450_ext_operands_pack_unorm2x16 },
    .{ .name = "PackHalf2x16", .value = 58, .operands = &glsl_std_450_ext_operands_pack_half2x16 },
    .{ .name = "PackDouble2x32", .value = 59, .operands = &glsl_std_450_ext_operands_pack_double2x32 },
    .{ .name = "UnpackSnorm2x16", .value = 60, .operands = &glsl_std_450_ext_operands_unpack_snorm2x16 },
    .{ .name = "UnpackUnorm2x16", .value = 61, .operands = &glsl_std_450_ext_operands_unpack_unorm2x16 },
    .{ .name = "UnpackHalf2x16", .value = 62, .operands = &glsl_std_450_ext_operands_unpack_half2x16 },
    .{ .name = "UnpackSnorm4x8", .value = 63, .operands = &glsl_std_450_ext_operands_unpack_snorm4x8 },
    .{ .name = "UnpackUnorm4x8", .value = 64, .operands = &glsl_std_450_ext_operands_unpack_unorm4x8 },
    .{ .name = "UnpackDouble2x32", .value = 65, .operands = &glsl_std_450_ext_operands_unpack_double2x32 },
    .{ .name = "Length", .value = 66, .operands = &glsl_std_450_ext_operands_length },
    .{ .name = "Distance", .value = 67, .operands = &glsl_std_450_ext_operands_distance },
    .{ .name = "Cross", .value = 68, .operands = &glsl_std_450_ext_operands_cross },
    .{ .name = "Normalize", .value = 69, .operands = &glsl_std_450_ext_operands_normalize },
    .{ .name = "FaceForward", .value = 70, .operands = &glsl_std_450_ext_operands_face_forward },
    .{ .name = "Reflect", .value = 71, .operands = &glsl_std_450_ext_operands_reflect },
    .{ .name = "Refract", .value = 72, .operands = &glsl_std_450_ext_operands_refract },
    .{ .name = "FindILsb", .value = 73, .operands = &glsl_std_450_ext_operands_find_i_lsb },
    .{ .name = "FindSMsb", .value = 74, .operands = &glsl_std_450_ext_operands_find_s_msb },
    .{ .name = "FindUMsb", .value = 75, .operands = &glsl_std_450_ext_operands_find_u_msb },
    .{ .name = "InterpolateAtCentroid", .value = 76, .operands = &glsl_std_450_ext_operands_interpolate_at_centroid },
    .{ .name = "InterpolateAtSample", .value = 77, .operands = &glsl_std_450_ext_operands_interpolate_at_sample },
    .{ .name = "InterpolateAtOffset", .value = 78, .operands = &glsl_std_450_ext_operands_interpolate_at_offset },
    .{ .name = "NMin", .value = 79, .operands = &glsl_std_450_ext_operands_n_min },
    .{ .name = "NMax", .value = 80, .operands = &glsl_std_450_ext_operands_n_max },
    .{ .name = "NClamp", .value = 81, .operands = &glsl_std_450_ext_operands_n_clamp },
};

const opencl_std_ext_operands_acos = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_acosh = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_acospi = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_asin = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_asinh = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_asinpi = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_atan = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_atan2 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_atanh = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_atanpi = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_atan2pi = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_cbrt = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_ceil = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_copysign = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_cos = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_cosh = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_cospi = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_erfc = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_erf = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_exp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_exp2 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_exp10 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_expm1 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_fabs = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_fdim = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_floor = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_fma = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_fmax = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_fmin = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_fmod = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_fract = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_frexp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_hypot = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_ilogb = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_ldexp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_lgamma = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_lgamma_r = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_log = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_log2 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_log10 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_log1p = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_logb = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_mad = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_maxmag = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_minmag = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_modf = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_nan = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_nextafter = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_pow = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_pown = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_powr = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_remainder = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_remquo = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_rint = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_rootn = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_round = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_rsqrt = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_sin = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_sincos = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_sinh = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_sinpi = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_sqrt = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_tan = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_tanh = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_tanpi = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_tgamma = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_trunc = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_half_cos = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_half_divide = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_half_exp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_half_exp2 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_half_exp10 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_half_log = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_half_log2 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_half_log10 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_half_powr = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_half_recip = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_half_rsqrt = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_half_sin = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_half_sqrt = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_half_tan = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_native_cos = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_native_divide = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_native_exp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_native_exp2 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_native_exp10 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_native_log = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_native_log2 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_native_log10 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_native_powr = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_native_recip = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_native_rsqrt = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_native_sin = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_native_sqrt = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_native_tan = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_fclamp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_degrees = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_fmax_common = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_fmin_common = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_mix = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_radians = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_step = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_smoothstep = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_sign = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_cross = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_distance = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_length = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_normalize = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_fast_distance = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_fast_length = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_fast_normalize = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_s_abs = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_s_abs_diff = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_s_add_sat = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_u_add_sat = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_s_hadd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_u_hadd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_s_rhadd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_u_rhadd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_s_clamp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_u_clamp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_clz = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_ctz = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_s_mad_hi = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_u_mad_sat = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_s_mad_sat = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_s_max = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_u_max = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_s_min = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_u_min = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_s_mul_hi = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_rotate = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_s_sub_sat = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_u_sub_sat = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_u_upsample = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_s_upsample = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_popcount = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_s_mad24 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_u_mad24 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_s_mul24 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_u_mul24 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_vloadn = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const opencl_std_ext_operands_vstoren = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_vload_half = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_vload_halfn = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const opencl_std_ext_operands_vstore_half = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_vstore_half_r = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .fp_rounding_mode, .quantifier = .one },
};
const opencl_std_ext_operands_vstore_halfn = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_vstore_halfn_r = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .fp_rounding_mode, .quantifier = .one },
};
const opencl_std_ext_operands_vloada_halfn = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const opencl_std_ext_operands_vstorea_halfn = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_vstorea_halfn_r = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .fp_rounding_mode, .quantifier = .one },
};
const opencl_std_ext_operands_shuffle = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_shuffle2 = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_printf = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const opencl_std_ext_operands_prefetch = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_bitselect = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_select = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_u_abs = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_u_abs_diff = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_u_mul_hi = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_std_ext_operands_u_mad_hi = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};

pub const opencl_std_extinsts = [_]ExtInstInfo{
    .{ .name = "acos", .value = 0, .operands = &opencl_std_ext_operands_acos },
    .{ .name = "acosh", .value = 1, .operands = &opencl_std_ext_operands_acosh },
    .{ .name = "acospi", .value = 2, .operands = &opencl_std_ext_operands_acospi },
    .{ .name = "asin", .value = 3, .operands = &opencl_std_ext_operands_asin },
    .{ .name = "asinh", .value = 4, .operands = &opencl_std_ext_operands_asinh },
    .{ .name = "asinpi", .value = 5, .operands = &opencl_std_ext_operands_asinpi },
    .{ .name = "atan", .value = 6, .operands = &opencl_std_ext_operands_atan },
    .{ .name = "atan2", .value = 7, .operands = &opencl_std_ext_operands_atan2 },
    .{ .name = "atanh", .value = 8, .operands = &opencl_std_ext_operands_atanh },
    .{ .name = "atanpi", .value = 9, .operands = &opencl_std_ext_operands_atanpi },
    .{ .name = "atan2pi", .value = 10, .operands = &opencl_std_ext_operands_atan2pi },
    .{ .name = "cbrt", .value = 11, .operands = &opencl_std_ext_operands_cbrt },
    .{ .name = "ceil", .value = 12, .operands = &opencl_std_ext_operands_ceil },
    .{ .name = "copysign", .value = 13, .operands = &opencl_std_ext_operands_copysign },
    .{ .name = "cos", .value = 14, .operands = &opencl_std_ext_operands_cos },
    .{ .name = "cosh", .value = 15, .operands = &opencl_std_ext_operands_cosh },
    .{ .name = "cospi", .value = 16, .operands = &opencl_std_ext_operands_cospi },
    .{ .name = "erfc", .value = 17, .operands = &opencl_std_ext_operands_erfc },
    .{ .name = "erf", .value = 18, .operands = &opencl_std_ext_operands_erf },
    .{ .name = "exp", .value = 19, .operands = &opencl_std_ext_operands_exp },
    .{ .name = "exp2", .value = 20, .operands = &opencl_std_ext_operands_exp2 },
    .{ .name = "exp10", .value = 21, .operands = &opencl_std_ext_operands_exp10 },
    .{ .name = "expm1", .value = 22, .operands = &opencl_std_ext_operands_expm1 },
    .{ .name = "fabs", .value = 23, .operands = &opencl_std_ext_operands_fabs },
    .{ .name = "fdim", .value = 24, .operands = &opencl_std_ext_operands_fdim },
    .{ .name = "floor", .value = 25, .operands = &opencl_std_ext_operands_floor },
    .{ .name = "fma", .value = 26, .operands = &opencl_std_ext_operands_fma },
    .{ .name = "fmax", .value = 27, .operands = &opencl_std_ext_operands_fmax },
    .{ .name = "fmin", .value = 28, .operands = &opencl_std_ext_operands_fmin },
    .{ .name = "fmod", .value = 29, .operands = &opencl_std_ext_operands_fmod },
    .{ .name = "fract", .value = 30, .operands = &opencl_std_ext_operands_fract },
    .{ .name = "frexp", .value = 31, .operands = &opencl_std_ext_operands_frexp },
    .{ .name = "hypot", .value = 32, .operands = &opencl_std_ext_operands_hypot },
    .{ .name = "ilogb", .value = 33, .operands = &opencl_std_ext_operands_ilogb },
    .{ .name = "ldexp", .value = 34, .operands = &opencl_std_ext_operands_ldexp },
    .{ .name = "lgamma", .value = 35, .operands = &opencl_std_ext_operands_lgamma },
    .{ .name = "lgamma_r", .value = 36, .operands = &opencl_std_ext_operands_lgamma_r },
    .{ .name = "log", .value = 37, .operands = &opencl_std_ext_operands_log },
    .{ .name = "log2", .value = 38, .operands = &opencl_std_ext_operands_log2 },
    .{ .name = "log10", .value = 39, .operands = &opencl_std_ext_operands_log10 },
    .{ .name = "log1p", .value = 40, .operands = &opencl_std_ext_operands_log1p },
    .{ .name = "logb", .value = 41, .operands = &opencl_std_ext_operands_logb },
    .{ .name = "mad", .value = 42, .operands = &opencl_std_ext_operands_mad },
    .{ .name = "maxmag", .value = 43, .operands = &opencl_std_ext_operands_maxmag },
    .{ .name = "minmag", .value = 44, .operands = &opencl_std_ext_operands_minmag },
    .{ .name = "modf", .value = 45, .operands = &opencl_std_ext_operands_modf },
    .{ .name = "nan", .value = 46, .operands = &opencl_std_ext_operands_nan },
    .{ .name = "nextafter", .value = 47, .operands = &opencl_std_ext_operands_nextafter },
    .{ .name = "pow", .value = 48, .operands = &opencl_std_ext_operands_pow },
    .{ .name = "pown", .value = 49, .operands = &opencl_std_ext_operands_pown },
    .{ .name = "powr", .value = 50, .operands = &opencl_std_ext_operands_powr },
    .{ .name = "remainder", .value = 51, .operands = &opencl_std_ext_operands_remainder },
    .{ .name = "remquo", .value = 52, .operands = &opencl_std_ext_operands_remquo },
    .{ .name = "rint", .value = 53, .operands = &opencl_std_ext_operands_rint },
    .{ .name = "rootn", .value = 54, .operands = &opencl_std_ext_operands_rootn },
    .{ .name = "round", .value = 55, .operands = &opencl_std_ext_operands_round },
    .{ .name = "rsqrt", .value = 56, .operands = &opencl_std_ext_operands_rsqrt },
    .{ .name = "sin", .value = 57, .operands = &opencl_std_ext_operands_sin },
    .{ .name = "sincos", .value = 58, .operands = &opencl_std_ext_operands_sincos },
    .{ .name = "sinh", .value = 59, .operands = &opencl_std_ext_operands_sinh },
    .{ .name = "sinpi", .value = 60, .operands = &opencl_std_ext_operands_sinpi },
    .{ .name = "sqrt", .value = 61, .operands = &opencl_std_ext_operands_sqrt },
    .{ .name = "tan", .value = 62, .operands = &opencl_std_ext_operands_tan },
    .{ .name = "tanh", .value = 63, .operands = &opencl_std_ext_operands_tanh },
    .{ .name = "tanpi", .value = 64, .operands = &opencl_std_ext_operands_tanpi },
    .{ .name = "tgamma", .value = 65, .operands = &opencl_std_ext_operands_tgamma },
    .{ .name = "trunc", .value = 66, .operands = &opencl_std_ext_operands_trunc },
    .{ .name = "half_cos", .value = 67, .operands = &opencl_std_ext_operands_half_cos },
    .{ .name = "half_divide", .value = 68, .operands = &opencl_std_ext_operands_half_divide },
    .{ .name = "half_exp", .value = 69, .operands = &opencl_std_ext_operands_half_exp },
    .{ .name = "half_exp2", .value = 70, .operands = &opencl_std_ext_operands_half_exp2 },
    .{ .name = "half_exp10", .value = 71, .operands = &opencl_std_ext_operands_half_exp10 },
    .{ .name = "half_log", .value = 72, .operands = &opencl_std_ext_operands_half_log },
    .{ .name = "half_log2", .value = 73, .operands = &opencl_std_ext_operands_half_log2 },
    .{ .name = "half_log10", .value = 74, .operands = &opencl_std_ext_operands_half_log10 },
    .{ .name = "half_powr", .value = 75, .operands = &opencl_std_ext_operands_half_powr },
    .{ .name = "half_recip", .value = 76, .operands = &opencl_std_ext_operands_half_recip },
    .{ .name = "half_rsqrt", .value = 77, .operands = &opencl_std_ext_operands_half_rsqrt },
    .{ .name = "half_sin", .value = 78, .operands = &opencl_std_ext_operands_half_sin },
    .{ .name = "half_sqrt", .value = 79, .operands = &opencl_std_ext_operands_half_sqrt },
    .{ .name = "half_tan", .value = 80, .operands = &opencl_std_ext_operands_half_tan },
    .{ .name = "native_cos", .value = 81, .operands = &opencl_std_ext_operands_native_cos },
    .{ .name = "native_divide", .value = 82, .operands = &opencl_std_ext_operands_native_divide },
    .{ .name = "native_exp", .value = 83, .operands = &opencl_std_ext_operands_native_exp },
    .{ .name = "native_exp2", .value = 84, .operands = &opencl_std_ext_operands_native_exp2 },
    .{ .name = "native_exp10", .value = 85, .operands = &opencl_std_ext_operands_native_exp10 },
    .{ .name = "native_log", .value = 86, .operands = &opencl_std_ext_operands_native_log },
    .{ .name = "native_log2", .value = 87, .operands = &opencl_std_ext_operands_native_log2 },
    .{ .name = "native_log10", .value = 88, .operands = &opencl_std_ext_operands_native_log10 },
    .{ .name = "native_powr", .value = 89, .operands = &opencl_std_ext_operands_native_powr },
    .{ .name = "native_recip", .value = 90, .operands = &opencl_std_ext_operands_native_recip },
    .{ .name = "native_rsqrt", .value = 91, .operands = &opencl_std_ext_operands_native_rsqrt },
    .{ .name = "native_sin", .value = 92, .operands = &opencl_std_ext_operands_native_sin },
    .{ .name = "native_sqrt", .value = 93, .operands = &opencl_std_ext_operands_native_sqrt },
    .{ .name = "native_tan", .value = 94, .operands = &opencl_std_ext_operands_native_tan },
    .{ .name = "fclamp", .value = 95, .operands = &opencl_std_ext_operands_fclamp },
    .{ .name = "degrees", .value = 96, .operands = &opencl_std_ext_operands_degrees },
    .{ .name = "fmax_common", .value = 97, .operands = &opencl_std_ext_operands_fmax_common },
    .{ .name = "fmin_common", .value = 98, .operands = &opencl_std_ext_operands_fmin_common },
    .{ .name = "mix", .value = 99, .operands = &opencl_std_ext_operands_mix },
    .{ .name = "radians", .value = 100, .operands = &opencl_std_ext_operands_radians },
    .{ .name = "step", .value = 101, .operands = &opencl_std_ext_operands_step },
    .{ .name = "smoothstep", .value = 102, .operands = &opencl_std_ext_operands_smoothstep },
    .{ .name = "sign", .value = 103, .operands = &opencl_std_ext_operands_sign },
    .{ .name = "cross", .value = 104, .operands = &opencl_std_ext_operands_cross },
    .{ .name = "distance", .value = 105, .operands = &opencl_std_ext_operands_distance },
    .{ .name = "length", .value = 106, .operands = &opencl_std_ext_operands_length },
    .{ .name = "normalize", .value = 107, .operands = &opencl_std_ext_operands_normalize },
    .{ .name = "fast_distance", .value = 108, .operands = &opencl_std_ext_operands_fast_distance },
    .{ .name = "fast_length", .value = 109, .operands = &opencl_std_ext_operands_fast_length },
    .{ .name = "fast_normalize", .value = 110, .operands = &opencl_std_ext_operands_fast_normalize },
    .{ .name = "s_abs", .value = 141, .operands = &opencl_std_ext_operands_s_abs },
    .{ .name = "s_abs_diff", .value = 142, .operands = &opencl_std_ext_operands_s_abs_diff },
    .{ .name = "s_add_sat", .value = 143, .operands = &opencl_std_ext_operands_s_add_sat },
    .{ .name = "u_add_sat", .value = 144, .operands = &opencl_std_ext_operands_u_add_sat },
    .{ .name = "s_hadd", .value = 145, .operands = &opencl_std_ext_operands_s_hadd },
    .{ .name = "u_hadd", .value = 146, .operands = &opencl_std_ext_operands_u_hadd },
    .{ .name = "s_rhadd", .value = 147, .operands = &opencl_std_ext_operands_s_rhadd },
    .{ .name = "u_rhadd", .value = 148, .operands = &opencl_std_ext_operands_u_rhadd },
    .{ .name = "s_clamp", .value = 149, .operands = &opencl_std_ext_operands_s_clamp },
    .{ .name = "u_clamp", .value = 150, .operands = &opencl_std_ext_operands_u_clamp },
    .{ .name = "clz", .value = 151, .operands = &opencl_std_ext_operands_clz },
    .{ .name = "ctz", .value = 152, .operands = &opencl_std_ext_operands_ctz },
    .{ .name = "s_mad_hi", .value = 153, .operands = &opencl_std_ext_operands_s_mad_hi },
    .{ .name = "u_mad_sat", .value = 154, .operands = &opencl_std_ext_operands_u_mad_sat },
    .{ .name = "s_mad_sat", .value = 155, .operands = &opencl_std_ext_operands_s_mad_sat },
    .{ .name = "s_max", .value = 156, .operands = &opencl_std_ext_operands_s_max },
    .{ .name = "u_max", .value = 157, .operands = &opencl_std_ext_operands_u_max },
    .{ .name = "s_min", .value = 158, .operands = &opencl_std_ext_operands_s_min },
    .{ .name = "u_min", .value = 159, .operands = &opencl_std_ext_operands_u_min },
    .{ .name = "s_mul_hi", .value = 160, .operands = &opencl_std_ext_operands_s_mul_hi },
    .{ .name = "rotate", .value = 161, .operands = &opencl_std_ext_operands_rotate },
    .{ .name = "s_sub_sat", .value = 162, .operands = &opencl_std_ext_operands_s_sub_sat },
    .{ .name = "u_sub_sat", .value = 163, .operands = &opencl_std_ext_operands_u_sub_sat },
    .{ .name = "u_upsample", .value = 164, .operands = &opencl_std_ext_operands_u_upsample },
    .{ .name = "s_upsample", .value = 165, .operands = &opencl_std_ext_operands_s_upsample },
    .{ .name = "popcount", .value = 166, .operands = &opencl_std_ext_operands_popcount },
    .{ .name = "s_mad24", .value = 167, .operands = &opencl_std_ext_operands_s_mad24 },
    .{ .name = "u_mad24", .value = 168, .operands = &opencl_std_ext_operands_u_mad24 },
    .{ .name = "s_mul24", .value = 169, .operands = &opencl_std_ext_operands_s_mul24 },
    .{ .name = "u_mul24", .value = 170, .operands = &opencl_std_ext_operands_u_mul24 },
    .{ .name = "vloadn", .value = 171, .operands = &opencl_std_ext_operands_vloadn },
    .{ .name = "vstoren", .value = 172, .operands = &opencl_std_ext_operands_vstoren },
    .{ .name = "vload_half", .value = 173, .operands = &opencl_std_ext_operands_vload_half },
    .{ .name = "vload_halfn", .value = 174, .operands = &opencl_std_ext_operands_vload_halfn },
    .{ .name = "vstore_half", .value = 175, .operands = &opencl_std_ext_operands_vstore_half },
    .{ .name = "vstore_half_r", .value = 176, .operands = &opencl_std_ext_operands_vstore_half_r },
    .{ .name = "vstore_halfn", .value = 177, .operands = &opencl_std_ext_operands_vstore_halfn },
    .{ .name = "vstore_halfn_r", .value = 178, .operands = &opencl_std_ext_operands_vstore_halfn_r },
    .{ .name = "vloada_halfn", .value = 179, .operands = &opencl_std_ext_operands_vloada_halfn },
    .{ .name = "vstorea_halfn", .value = 180, .operands = &opencl_std_ext_operands_vstorea_halfn },
    .{ .name = "vstorea_halfn_r", .value = 181, .operands = &opencl_std_ext_operands_vstorea_halfn_r },
    .{ .name = "shuffle", .value = 182, .operands = &opencl_std_ext_operands_shuffle },
    .{ .name = "shuffle2", .value = 183, .operands = &opencl_std_ext_operands_shuffle2 },
    .{ .name = "printf", .value = 184, .operands = &opencl_std_ext_operands_printf },
    .{ .name = "prefetch", .value = 185, .operands = &opencl_std_ext_operands_prefetch },
    .{ .name = "bitselect", .value = 186, .operands = &opencl_std_ext_operands_bitselect },
    .{ .name = "select", .value = 187, .operands = &opencl_std_ext_operands_select },
    .{ .name = "u_abs", .value = 201, .operands = &opencl_std_ext_operands_u_abs },
    .{ .name = "u_abs_diff", .value = 202, .operands = &opencl_std_ext_operands_u_abs_diff },
    .{ .name = "u_mul_hi", .value = 203, .operands = &opencl_std_ext_operands_u_mul_hi },
    .{ .name = "u_mad_hi", .value = 204, .operands = &opencl_std_ext_operands_u_mad_hi },
};

const opencl_debug_info_100_ext_operands_debug_info_none = [_]OperandInfo{};
const opencl_debug_info_100_ext_operands_debug_compilation_unit = [_]OperandInfo{
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .source_language, .quantifier = .one },
};
const opencl_debug_info_100_ext_operands_debug_type_basic = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .opencl_debug_info_100_debug_base_type_attribute_encoding, .quantifier = .one },
};
const opencl_debug_info_100_ext_operands_debug_type_pointer = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .storage_class, .quantifier = .one },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .quantifier = .one },
};
const opencl_debug_info_100_ext_operands_debug_type_qualifier = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .opencl_debug_info_100_debug_type_qualifier, .quantifier = .one },
};
const opencl_debug_info_100_ext_operands_debug_type_array = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const opencl_debug_info_100_ext_operands_debug_type_vector = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const opencl_debug_info_100_ext_operands_debug_typedef = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_debug_info_100_ext_operands_debug_type_function = [_]OperandInfo{
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const opencl_debug_info_100_ext_operands_debug_type_enum = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .quantifier = .one },
    .{ .kind = .pair_id_ref_id_ref, .quantifier = .variable },
};
const opencl_debug_info_100_ext_operands_debug_type_composite = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .opencl_debug_info_100_debug_composite_type, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const opencl_debug_info_100_ext_operands_debug_type_member = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const opencl_debug_info_100_ext_operands_debug_type_inheritance = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .quantifier = .one },
};
const opencl_debug_info_100_ext_operands_debug_type_ptr_to_member = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_debug_info_100_ext_operands_debug_type_template = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const opencl_debug_info_100_ext_operands_debug_type_template_parameter = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const opencl_debug_info_100_ext_operands_debug_type_template_template_parameter = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const opencl_debug_info_100_ext_operands_debug_type_template_parameter_pack = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const opencl_debug_info_100_ext_operands_debug_global_variable = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const opencl_debug_info_100_ext_operands_debug_function_declaration = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .quantifier = .one },
};
const opencl_debug_info_100_ext_operands_debug_function = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const opencl_debug_info_100_ext_operands_debug_lexical_block = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const opencl_debug_info_100_ext_operands_debug_lexical_block_discriminator = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_debug_info_100_ext_operands_debug_scope = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const opencl_debug_info_100_ext_operands_debug_no_scope = [_]OperandInfo{};
const opencl_debug_info_100_ext_operands_debug_inlined_at = [_]OperandInfo{
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const opencl_debug_info_100_ext_operands_debug_local_variable = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .opencl_debug_info_100_debug_info_flags, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .optional },
};
const opencl_debug_info_100_ext_operands_debug_inlined_variable = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_debug_info_100_ext_operands_debug_declare = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_debug_info_100_ext_operands_debug_value = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const opencl_debug_info_100_ext_operands_debug_operation = [_]OperandInfo{
    .{ .kind = .opencl_debug_info_100_debug_operation, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .variable },
};
const opencl_debug_info_100_ext_operands_debug_expression = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .variable },
};
const opencl_debug_info_100_ext_operands_debug_macro_def = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const opencl_debug_info_100_ext_operands_debug_macro_undef = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_debug_info_100_ext_operands_debug_imported_entity = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .opencl_debug_info_100_debug_imported_entity, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const opencl_debug_info_100_ext_operands_debug_source = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const opencl_debug_info_100_ext_operands_debug_module_intel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};

pub const opencl_debug_info_100_extinsts = [_]ExtInstInfo{
    .{ .name = "DebugInfoNone", .value = 0, .operands = &opencl_debug_info_100_ext_operands_debug_info_none },
    .{ .name = "DebugCompilationUnit", .value = 1, .operands = &opencl_debug_info_100_ext_operands_debug_compilation_unit },
    .{ .name = "DebugTypeBasic", .value = 2, .operands = &opencl_debug_info_100_ext_operands_debug_type_basic },
    .{ .name = "DebugTypePointer", .value = 3, .operands = &opencl_debug_info_100_ext_operands_debug_type_pointer },
    .{ .name = "DebugTypeQualifier", .value = 4, .operands = &opencl_debug_info_100_ext_operands_debug_type_qualifier },
    .{ .name = "DebugTypeArray", .value = 5, .operands = &opencl_debug_info_100_ext_operands_debug_type_array },
    .{ .name = "DebugTypeVector", .value = 6, .operands = &opencl_debug_info_100_ext_operands_debug_type_vector },
    .{ .name = "DebugTypedef", .value = 7, .operands = &opencl_debug_info_100_ext_operands_debug_typedef },
    .{ .name = "DebugTypeFunction", .value = 8, .operands = &opencl_debug_info_100_ext_operands_debug_type_function },
    .{ .name = "DebugTypeEnum", .value = 9, .operands = &opencl_debug_info_100_ext_operands_debug_type_enum },
    .{ .name = "DebugTypeComposite", .value = 10, .operands = &opencl_debug_info_100_ext_operands_debug_type_composite },
    .{ .name = "DebugTypeMember", .value = 11, .operands = &opencl_debug_info_100_ext_operands_debug_type_member },
    .{ .name = "DebugTypeInheritance", .value = 12, .operands = &opencl_debug_info_100_ext_operands_debug_type_inheritance },
    .{ .name = "DebugTypePtrToMember", .value = 13, .operands = &opencl_debug_info_100_ext_operands_debug_type_ptr_to_member },
    .{ .name = "DebugTypeTemplate", .value = 14, .operands = &opencl_debug_info_100_ext_operands_debug_type_template },
    .{ .name = "DebugTypeTemplateParameter", .value = 15, .operands = &opencl_debug_info_100_ext_operands_debug_type_template_parameter },
    .{ .name = "DebugTypeTemplateTemplateParameter", .value = 16, .operands = &opencl_debug_info_100_ext_operands_debug_type_template_template_parameter },
    .{ .name = "DebugTypeTemplateParameterPack", .value = 17, .operands = &opencl_debug_info_100_ext_operands_debug_type_template_parameter_pack },
    .{ .name = "DebugGlobalVariable", .value = 18, .operands = &opencl_debug_info_100_ext_operands_debug_global_variable },
    .{ .name = "DebugFunctionDeclaration", .value = 19, .operands = &opencl_debug_info_100_ext_operands_debug_function_declaration },
    .{ .name = "DebugFunction", .value = 20, .operands = &opencl_debug_info_100_ext_operands_debug_function },
    .{ .name = "DebugLexicalBlock", .value = 21, .operands = &opencl_debug_info_100_ext_operands_debug_lexical_block },
    .{ .name = "DebugLexicalBlockDiscriminator", .value = 22, .operands = &opencl_debug_info_100_ext_operands_debug_lexical_block_discriminator },
    .{ .name = "DebugScope", .value = 23, .operands = &opencl_debug_info_100_ext_operands_debug_scope },
    .{ .name = "DebugNoScope", .value = 24, .operands = &opencl_debug_info_100_ext_operands_debug_no_scope },
    .{ .name = "DebugInlinedAt", .value = 25, .operands = &opencl_debug_info_100_ext_operands_debug_inlined_at },
    .{ .name = "DebugLocalVariable", .value = 26, .operands = &opencl_debug_info_100_ext_operands_debug_local_variable },
    .{ .name = "DebugInlinedVariable", .value = 27, .operands = &opencl_debug_info_100_ext_operands_debug_inlined_variable },
    .{ .name = "DebugDeclare", .value = 28, .operands = &opencl_debug_info_100_ext_operands_debug_declare },
    .{ .name = "DebugValue", .value = 29, .operands = &opencl_debug_info_100_ext_operands_debug_value },
    .{ .name = "DebugOperation", .value = 30, .operands = &opencl_debug_info_100_ext_operands_debug_operation },
    .{ .name = "DebugExpression", .value = 31, .operands = &opencl_debug_info_100_ext_operands_debug_expression },
    .{ .name = "DebugMacroDef", .value = 32, .operands = &opencl_debug_info_100_ext_operands_debug_macro_def },
    .{ .name = "DebugMacroUndef", .value = 33, .operands = &opencl_debug_info_100_ext_operands_debug_macro_undef },
    .{ .name = "DebugImportedEntity", .value = 34, .operands = &opencl_debug_info_100_ext_operands_debug_imported_entity },
    .{ .name = "DebugSource", .value = 35, .operands = &opencl_debug_info_100_ext_operands_debug_source },
    .{ .name = "DebugModuleINTEL", .value = 36, .operands = &opencl_debug_info_100_ext_operands_debug_module_intel },
};

const nonsemantic_shader_debug_info_100_ext_operands_debug_info_none = [_]OperandInfo{};
const nonsemantic_shader_debug_info_100_ext_operands_debug_compilation_unit = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_type_basic = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_type_pointer = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_type_qualifier = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_type_array = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_type_vector = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_typedef = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_type_function = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_type_enum = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .pair_id_ref_id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_type_composite = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_type_member = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_type_inheritance = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_type_ptr_to_member = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_type_template = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_type_template_parameter = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_type_template_template_parameter = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_type_template_parameter_pack = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_global_variable = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_function_declaration = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_function = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_lexical_block = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_lexical_block_discriminator = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_scope = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_no_scope = [_]OperandInfo{};
const nonsemantic_shader_debug_info_100_ext_operands_debug_inlined_at = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_local_variable = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_inlined_variable = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_declare = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_value = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_operation = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_expression = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_macro_def = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_macro_undef = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_imported_entity = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_source = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_function_definition = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_source_continued = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_line = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_no_line = [_]OperandInfo{};
const nonsemantic_shader_debug_info_100_ext_operands_debug_build_identifier = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_storage_path = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_entry_point = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_100_ext_operands_debug_type_matrix = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};

pub const nonsemantic_shader_debug_info_100_extinsts = [_]ExtInstInfo{
    .{ .name = "DebugInfoNone", .value = 0, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_info_none },
    .{ .name = "DebugCompilationUnit", .value = 1, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_compilation_unit },
    .{ .name = "DebugTypeBasic", .value = 2, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_type_basic },
    .{ .name = "DebugTypePointer", .value = 3, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_type_pointer },
    .{ .name = "DebugTypeQualifier", .value = 4, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_type_qualifier },
    .{ .name = "DebugTypeArray", .value = 5, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_type_array },
    .{ .name = "DebugTypeVector", .value = 6, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_type_vector },
    .{ .name = "DebugTypedef", .value = 7, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_typedef },
    .{ .name = "DebugTypeFunction", .value = 8, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_type_function },
    .{ .name = "DebugTypeEnum", .value = 9, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_type_enum },
    .{ .name = "DebugTypeComposite", .value = 10, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_type_composite },
    .{ .name = "DebugTypeMember", .value = 11, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_type_member },
    .{ .name = "DebugTypeInheritance", .value = 12, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_type_inheritance },
    .{ .name = "DebugTypePtrToMember", .value = 13, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_type_ptr_to_member },
    .{ .name = "DebugTypeTemplate", .value = 14, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_type_template },
    .{ .name = "DebugTypeTemplateParameter", .value = 15, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_type_template_parameter },
    .{ .name = "DebugTypeTemplateTemplateParameter", .value = 16, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_type_template_template_parameter },
    .{ .name = "DebugTypeTemplateParameterPack", .value = 17, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_type_template_parameter_pack },
    .{ .name = "DebugGlobalVariable", .value = 18, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_global_variable },
    .{ .name = "DebugFunctionDeclaration", .value = 19, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_function_declaration },
    .{ .name = "DebugFunction", .value = 20, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_function },
    .{ .name = "DebugLexicalBlock", .value = 21, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_lexical_block },
    .{ .name = "DebugLexicalBlockDiscriminator", .value = 22, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_lexical_block_discriminator },
    .{ .name = "DebugScope", .value = 23, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_scope },
    .{ .name = "DebugNoScope", .value = 24, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_no_scope },
    .{ .name = "DebugInlinedAt", .value = 25, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_inlined_at },
    .{ .name = "DebugLocalVariable", .value = 26, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_local_variable },
    .{ .name = "DebugInlinedVariable", .value = 27, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_inlined_variable },
    .{ .name = "DebugDeclare", .value = 28, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_declare },
    .{ .name = "DebugValue", .value = 29, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_value },
    .{ .name = "DebugOperation", .value = 30, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_operation },
    .{ .name = "DebugExpression", .value = 31, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_expression },
    .{ .name = "DebugMacroDef", .value = 32, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_macro_def },
    .{ .name = "DebugMacroUndef", .value = 33, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_macro_undef },
    .{ .name = "DebugImportedEntity", .value = 34, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_imported_entity },
    .{ .name = "DebugSource", .value = 35, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_source },
    .{ .name = "DebugFunctionDefinition", .value = 101, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_function_definition },
    .{ .name = "DebugSourceContinued", .value = 102, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_source_continued },
    .{ .name = "DebugLine", .value = 103, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_line },
    .{ .name = "DebugNoLine", .value = 104, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_no_line },
    .{ .name = "DebugBuildIdentifier", .value = 105, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_build_identifier },
    .{ .name = "DebugStoragePath", .value = 106, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_storage_path },
    .{ .name = "DebugEntryPoint", .value = 107, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_entry_point },
    .{ .name = "DebugTypeMatrix", .value = 108, .operands = &nonsemantic_shader_debug_info_100_ext_operands_debug_type_matrix },
};

const nonsemantic_shader_debug_info_ext_operands_debug_info_none = [_]OperandInfo{};
const nonsemantic_shader_debug_info_ext_operands_debug_compilation_unit = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_basic = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_pointer = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_qualifier = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_array = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_vector = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_typedef = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_function = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_enum = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .pair_id_ref_id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_composite = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_member = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_inheritance = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_ptr_to_member = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_template = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_template_parameter = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_template_template_parameter = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_template_parameter_pack = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_ext_operands_debug_global_variable = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_ext_operands_debug_function_declaration = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_function = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_ext_operands_debug_lexical_block = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_ext_operands_debug_lexical_block_discriminator = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_scope = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_ext_operands_debug_no_scope = [_]OperandInfo{};
const nonsemantic_shader_debug_info_ext_operands_debug_inlined_at = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_ext_operands_debug_local_variable = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_ext_operands_debug_inlined_variable = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_declare = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_ext_operands_debug_value = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_ext_operands_debug_operation = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_ext_operands_debug_expression = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_shader_debug_info_ext_operands_debug_macro_def = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_ext_operands_debug_macro_undef = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_imported_entity = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_source = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_shader_debug_info_ext_operands_debug_function_definition = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_source_continued = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_line = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_no_line = [_]OperandInfo{};
const nonsemantic_shader_debug_info_ext_operands_debug_build_identifier = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_storage_path = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_entry_point = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_matrix = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_vector_id_ext = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_shader_debug_info_ext_operands_debug_type_cooperative_matrix_khr = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};

pub const nonsemantic_shader_debug_info_extinsts = [_]ExtInstInfo{
    .{ .name = "DebugInfoNone", .value = 0, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_info_none },
    .{ .name = "DebugCompilationUnit", .value = 1, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_compilation_unit },
    .{ .name = "DebugTypeBasic", .value = 2, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_basic },
    .{ .name = "DebugTypePointer", .value = 3, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_pointer },
    .{ .name = "DebugTypeQualifier", .value = 4, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_qualifier },
    .{ .name = "DebugTypeArray", .value = 5, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_array },
    .{ .name = "DebugTypeVector", .value = 6, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_vector },
    .{ .name = "DebugTypedef", .value = 7, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_typedef },
    .{ .name = "DebugTypeFunction", .value = 8, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_function },
    .{ .name = "DebugTypeEnum", .value = 9, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_enum },
    .{ .name = "DebugTypeComposite", .value = 10, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_composite },
    .{ .name = "DebugTypeMember", .value = 11, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_member },
    .{ .name = "DebugTypeInheritance", .value = 12, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_inheritance },
    .{ .name = "DebugTypePtrToMember", .value = 13, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_ptr_to_member },
    .{ .name = "DebugTypeTemplate", .value = 14, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_template },
    .{ .name = "DebugTypeTemplateParameter", .value = 15, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_template_parameter },
    .{ .name = "DebugTypeTemplateTemplateParameter", .value = 16, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_template_template_parameter },
    .{ .name = "DebugTypeTemplateParameterPack", .value = 17, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_template_parameter_pack },
    .{ .name = "DebugGlobalVariable", .value = 18, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_global_variable },
    .{ .name = "DebugFunctionDeclaration", .value = 19, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_function_declaration },
    .{ .name = "DebugFunction", .value = 20, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_function },
    .{ .name = "DebugLexicalBlock", .value = 21, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_lexical_block },
    .{ .name = "DebugLexicalBlockDiscriminator", .value = 22, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_lexical_block_discriminator },
    .{ .name = "DebugScope", .value = 23, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_scope },
    .{ .name = "DebugNoScope", .value = 24, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_no_scope },
    .{ .name = "DebugInlinedAt", .value = 25, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_inlined_at },
    .{ .name = "DebugLocalVariable", .value = 26, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_local_variable },
    .{ .name = "DebugInlinedVariable", .value = 27, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_inlined_variable },
    .{ .name = "DebugDeclare", .value = 28, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_declare },
    .{ .name = "DebugValue", .value = 29, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_value },
    .{ .name = "DebugOperation", .value = 30, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_operation },
    .{ .name = "DebugExpression", .value = 31, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_expression },
    .{ .name = "DebugMacroDef", .value = 32, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_macro_def },
    .{ .name = "DebugMacroUndef", .value = 33, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_macro_undef },
    .{ .name = "DebugImportedEntity", .value = 34, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_imported_entity },
    .{ .name = "DebugSource", .value = 35, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_source },
    .{ .name = "DebugFunctionDefinition", .value = 101, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_function_definition },
    .{ .name = "DebugSourceContinued", .value = 102, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_source_continued },
    .{ .name = "DebugLine", .value = 103, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_line },
    .{ .name = "DebugNoLine", .value = 104, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_no_line },
    .{ .name = "DebugBuildIdentifier", .value = 105, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_build_identifier },
    .{ .name = "DebugStoragePath", .value = 106, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_storage_path },
    .{ .name = "DebugEntryPoint", .value = 107, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_entry_point },
    .{ .name = "DebugTypeMatrix", .value = 108, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_matrix },
    .{ .name = "DebugTypeVectorIdEXT", .value = 109, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_vector_id_ext },
    .{ .name = "DebugTypeCooperativeMatrixKHR", .value = 110, .operands = &nonsemantic_shader_debug_info_ext_operands_debug_type_cooperative_matrix_khr },
};

const debug_info_ext_operands_debug_info_none = [_]OperandInfo{};
const debug_info_ext_operands_debug_compilation_unit = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const debug_info_ext_operands_debug_type_basic = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .debug_info_debug_base_type_attribute_encoding, .quantifier = .one },
};
const debug_info_ext_operands_debug_type_pointer = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .storage_class, .quantifier = .one },
    .{ .kind = .debug_info_debug_info_flags, .quantifier = .one },
};
const debug_info_ext_operands_debug_type_qualifier = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .debug_info_debug_type_qualifier, .quantifier = .one },
};
const debug_info_ext_operands_debug_type_array = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const debug_info_ext_operands_debug_type_vector = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const debug_info_ext_operands_debug_typedef = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const debug_info_ext_operands_debug_type_function = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const debug_info_ext_operands_debug_type_enum = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .debug_info_debug_info_flags, .quantifier = .one },
    .{ .kind = .pair_id_ref_id_ref, .quantifier = .variable },
};
const debug_info_ext_operands_debug_type_composite = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .debug_info_debug_composite_type, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .debug_info_debug_info_flags, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const debug_info_ext_operands_debug_type_member = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .debug_info_debug_info_flags, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const debug_info_ext_operands_debug_type_inheritance = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .debug_info_debug_info_flags, .quantifier = .one },
};
const debug_info_ext_operands_debug_type_ptr_to_member = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const debug_info_ext_operands_debug_type_template = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const debug_info_ext_operands_debug_type_template_parameter = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const debug_info_ext_operands_debug_type_template_template_parameter = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
};
const debug_info_ext_operands_debug_type_template_parameter_pack = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const debug_info_ext_operands_debug_global_variable = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .debug_info_debug_info_flags, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const debug_info_ext_operands_debug_function_declaration = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .debug_info_debug_info_flags, .quantifier = .one },
};
const debug_info_ext_operands_debug_function = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .debug_info_debug_info_flags, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const debug_info_ext_operands_debug_lexical_block = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const debug_info_ext_operands_debug_lexical_block_discriminator = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const debug_info_ext_operands_debug_scope = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const debug_info_ext_operands_debug_no_scope = [_]OperandInfo{};
const debug_info_ext_operands_debug_inlined_at = [_]OperandInfo{
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const debug_info_ext_operands_debug_local_variable = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .optional },
};
const debug_info_ext_operands_debug_inlined_variable = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const debug_info_ext_operands_debug_declare = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const debug_info_ext_operands_debug_value = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const debug_info_ext_operands_debug_operation = [_]OperandInfo{
    .{ .kind = .debug_info_debug_operation, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .variable },
};
const debug_info_ext_operands_debug_expression = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .variable },
};
const debug_info_ext_operands_debug_macro_def = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const debug_info_ext_operands_debug_macro_undef = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};

pub const debug_info_extinsts = [_]ExtInstInfo{
    .{ .name = "DebugInfoNone", .value = 0, .operands = &debug_info_ext_operands_debug_info_none },
    .{ .name = "DebugCompilationUnit", .value = 1, .operands = &debug_info_ext_operands_debug_compilation_unit },
    .{ .name = "DebugTypeBasic", .value = 2, .operands = &debug_info_ext_operands_debug_type_basic },
    .{ .name = "DebugTypePointer", .value = 3, .operands = &debug_info_ext_operands_debug_type_pointer },
    .{ .name = "DebugTypeQualifier", .value = 4, .operands = &debug_info_ext_operands_debug_type_qualifier },
    .{ .name = "DebugTypeArray", .value = 5, .operands = &debug_info_ext_operands_debug_type_array },
    .{ .name = "DebugTypeVector", .value = 6, .operands = &debug_info_ext_operands_debug_type_vector },
    .{ .name = "DebugTypedef", .value = 7, .operands = &debug_info_ext_operands_debug_typedef },
    .{ .name = "DebugTypeFunction", .value = 8, .operands = &debug_info_ext_operands_debug_type_function },
    .{ .name = "DebugTypeEnum", .value = 9, .operands = &debug_info_ext_operands_debug_type_enum },
    .{ .name = "DebugTypeComposite", .value = 10, .operands = &debug_info_ext_operands_debug_type_composite },
    .{ .name = "DebugTypeMember", .value = 11, .operands = &debug_info_ext_operands_debug_type_member },
    .{ .name = "DebugTypeInheritance", .value = 12, .operands = &debug_info_ext_operands_debug_type_inheritance },
    .{ .name = "DebugTypePtrToMember", .value = 13, .operands = &debug_info_ext_operands_debug_type_ptr_to_member },
    .{ .name = "DebugTypeTemplate", .value = 14, .operands = &debug_info_ext_operands_debug_type_template },
    .{ .name = "DebugTypeTemplateParameter", .value = 15, .operands = &debug_info_ext_operands_debug_type_template_parameter },
    .{ .name = "DebugTypeTemplateTemplateParameter", .value = 16, .operands = &debug_info_ext_operands_debug_type_template_template_parameter },
    .{ .name = "DebugTypeTemplateParameterPack", .value = 17, .operands = &debug_info_ext_operands_debug_type_template_parameter_pack },
    .{ .name = "DebugGlobalVariable", .value = 18, .operands = &debug_info_ext_operands_debug_global_variable },
    .{ .name = "DebugFunctionDeclaration", .value = 19, .operands = &debug_info_ext_operands_debug_function_declaration },
    .{ .name = "DebugFunction", .value = 20, .operands = &debug_info_ext_operands_debug_function },
    .{ .name = "DebugLexicalBlock", .value = 21, .operands = &debug_info_ext_operands_debug_lexical_block },
    .{ .name = "DebugLexicalBlockDiscriminator", .value = 22, .operands = &debug_info_ext_operands_debug_lexical_block_discriminator },
    .{ .name = "DebugScope", .value = 23, .operands = &debug_info_ext_operands_debug_scope },
    .{ .name = "DebugNoScope", .value = 24, .operands = &debug_info_ext_operands_debug_no_scope },
    .{ .name = "DebugInlinedAt", .value = 25, .operands = &debug_info_ext_operands_debug_inlined_at },
    .{ .name = "DebugLocalVariable", .value = 26, .operands = &debug_info_ext_operands_debug_local_variable },
    .{ .name = "DebugInlinedVariable", .value = 27, .operands = &debug_info_ext_operands_debug_inlined_variable },
    .{ .name = "DebugDeclare", .value = 28, .operands = &debug_info_ext_operands_debug_declare },
    .{ .name = "DebugValue", .value = 29, .operands = &debug_info_ext_operands_debug_value },
    .{ .name = "DebugOperation", .value = 30, .operands = &debug_info_ext_operands_debug_operation },
    .{ .name = "DebugExpression", .value = 31, .operands = &debug_info_ext_operands_debug_expression },
    .{ .name = "DebugMacroDef", .value = 32, .operands = &debug_info_ext_operands_debug_macro_def },
    .{ .name = "DebugMacroUndef", .value = 33, .operands = &debug_info_ext_operands_debug_macro_undef },
};

const nonsemantic_debug_printf_ext_operands_debug_printf = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};

pub const nonsemantic_debug_printf_extinsts = [_]ExtInstInfo{
    .{ .name = "DebugPrintf", .value = 1, .operands = &nonsemantic_debug_printf_ext_operands_debug_printf },
};

const amd_trinary_minmax_ext_operands_f_min3_amd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const amd_trinary_minmax_ext_operands_u_min3_amd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const amd_trinary_minmax_ext_operands_s_min3_amd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const amd_trinary_minmax_ext_operands_f_max3_amd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const amd_trinary_minmax_ext_operands_u_max3_amd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const amd_trinary_minmax_ext_operands_s_max3_amd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const amd_trinary_minmax_ext_operands_f_mid3_amd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const amd_trinary_minmax_ext_operands_u_mid3_amd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const amd_trinary_minmax_ext_operands_s_mid3_amd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};

pub const amd_trinary_minmax_extinsts = [_]ExtInstInfo{
    .{ .name = "FMin3AMD", .value = 1, .operands = &amd_trinary_minmax_ext_operands_f_min3_amd },
    .{ .name = "UMin3AMD", .value = 2, .operands = &amd_trinary_minmax_ext_operands_u_min3_amd },
    .{ .name = "SMin3AMD", .value = 3, .operands = &amd_trinary_minmax_ext_operands_s_min3_amd },
    .{ .name = "FMax3AMD", .value = 4, .operands = &amd_trinary_minmax_ext_operands_f_max3_amd },
    .{ .name = "UMax3AMD", .value = 5, .operands = &amd_trinary_minmax_ext_operands_u_max3_amd },
    .{ .name = "SMax3AMD", .value = 6, .operands = &amd_trinary_minmax_ext_operands_s_max3_amd },
    .{ .name = "FMid3AMD", .value = 7, .operands = &amd_trinary_minmax_ext_operands_f_mid3_amd },
    .{ .name = "UMid3AMD", .value = 8, .operands = &amd_trinary_minmax_ext_operands_u_mid3_amd },
    .{ .name = "SMid3AMD", .value = 9, .operands = &amd_trinary_minmax_ext_operands_s_mid3_amd },
};

const amd_explicit_vertex_parameter_ext_operands_interpolate_at_vertex_amd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};

pub const amd_explicit_vertex_parameter_extinsts = [_]ExtInstInfo{
    .{ .name = "InterpolateAtVertexAMD", .value = 1, .operands = &amd_explicit_vertex_parameter_ext_operands_interpolate_at_vertex_amd },
};

const amd_gcn_shader_ext_operands_cube_face_index_amd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const amd_gcn_shader_ext_operands_cube_face_coord_amd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const amd_gcn_shader_ext_operands_time_amd = [_]OperandInfo{};

pub const amd_gcn_shader_extinsts = [_]ExtInstInfo{
    .{ .name = "CubeFaceIndexAMD", .value = 1, .operands = &amd_gcn_shader_ext_operands_cube_face_index_amd },
    .{ .name = "CubeFaceCoordAMD", .value = 2, .operands = &amd_gcn_shader_ext_operands_cube_face_coord_amd },
    .{ .name = "TimeAMD", .value = 3, .operands = &amd_gcn_shader_ext_operands_time_amd },
};

const amd_shader_ballot_ext_operands_swizzle_invocations_amd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const amd_shader_ballot_ext_operands_swizzle_invocations_masked_amd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const amd_shader_ballot_ext_operands_write_invocation_amd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const amd_shader_ballot_ext_operands_mbcnt_amd = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};

pub const amd_shader_ballot_extinsts = [_]ExtInstInfo{
    .{ .name = "SwizzleInvocationsAMD", .value = 1, .operands = &amd_shader_ballot_ext_operands_swizzle_invocations_amd },
    .{ .name = "SwizzleInvocationsMaskedAMD", .value = 2, .operands = &amd_shader_ballot_ext_operands_swizzle_invocations_masked_amd },
    .{ .name = "WriteInvocationAMD", .value = 3, .operands = &amd_shader_ballot_ext_operands_write_invocation_amd },
    .{ .name = "MbcntAMD", .value = 4, .operands = &amd_shader_ballot_ext_operands_mbcnt_amd },
};

const nonsemantic_clspv_reflection_ext_operands_kernel = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_clspv_reflection_ext_operands_argument_info = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .id_ref, .quantifier = .optional },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_clspv_reflection_ext_operands_argument_storage_buffer = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_clspv_reflection_ext_operands_argument_uniform = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_clspv_reflection_ext_operands_argument_pod_storage_buffer = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_clspv_reflection_ext_operands_argument_pod_uniform = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_clspv_reflection_ext_operands_argument_pod_push_constant = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_clspv_reflection_ext_operands_argument_sampled_image = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_clspv_reflection_ext_operands_argument_storage_image = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_clspv_reflection_ext_operands_argument_sampler = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_clspv_reflection_ext_operands_argument_workgroup = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_clspv_reflection_ext_operands_spec_constant_workgroup_size = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_spec_constant_global_offset = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_spec_constant_work_dim = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_push_constant_global_offset = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_push_constant_enqueued_local_size = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_push_constant_global_size = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_push_constant_region_offset = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_push_constant_num_workgroups = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_push_constant_region_group_offset = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_constant_data_storage_buffer = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_constant_data_uniform = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_literal_sampler = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_property_required_workgroup_size = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_spec_constant_subgroup_max_size = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_argument_pointer_push_constant = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_clspv_reflection_ext_operands_argument_pointer_uniform = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_clspv_reflection_ext_operands_program_scope_variables_storage_buffer = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_program_scope_variable_pointer_relocation = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_image_argument_info_channel_order_push_constant = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_image_argument_info_channel_data_type_push_constant = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_image_argument_info_channel_order_uniform = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_image_argument_info_channel_data_type_uniform = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_argument_storage_texel_buffer = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_clspv_reflection_ext_operands_argument_uniform_texel_buffer = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};
const nonsemantic_clspv_reflection_ext_operands_constant_data_pointer_push_constant = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_program_scope_variable_pointer_push_constant = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_printf_info = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_clspv_reflection_ext_operands_printf_buffer_storage_buffer = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_printf_buffer_pointer_push_constant = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_normalized_sampler_mask_push_constant = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_clspv_reflection_ext_operands_workgroup_variable_size = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};

pub const nonsemantic_clspv_reflection_extinsts = [_]ExtInstInfo{
    .{ .name = "Kernel", .value = 1, .operands = &nonsemantic_clspv_reflection_ext_operands_kernel },
    .{ .name = "ArgumentInfo", .value = 2, .operands = &nonsemantic_clspv_reflection_ext_operands_argument_info },
    .{ .name = "ArgumentStorageBuffer", .value = 3, .operands = &nonsemantic_clspv_reflection_ext_operands_argument_storage_buffer },
    .{ .name = "ArgumentUniform", .value = 4, .operands = &nonsemantic_clspv_reflection_ext_operands_argument_uniform },
    .{ .name = "ArgumentPodStorageBuffer", .value = 5, .operands = &nonsemantic_clspv_reflection_ext_operands_argument_pod_storage_buffer },
    .{ .name = "ArgumentPodUniform", .value = 6, .operands = &nonsemantic_clspv_reflection_ext_operands_argument_pod_uniform },
    .{ .name = "ArgumentPodPushConstant", .value = 7, .operands = &nonsemantic_clspv_reflection_ext_operands_argument_pod_push_constant },
    .{ .name = "ArgumentSampledImage", .value = 8, .operands = &nonsemantic_clspv_reflection_ext_operands_argument_sampled_image },
    .{ .name = "ArgumentStorageImage", .value = 9, .operands = &nonsemantic_clspv_reflection_ext_operands_argument_storage_image },
    .{ .name = "ArgumentSampler", .value = 10, .operands = &nonsemantic_clspv_reflection_ext_operands_argument_sampler },
    .{ .name = "ArgumentWorkgroup", .value = 11, .operands = &nonsemantic_clspv_reflection_ext_operands_argument_workgroup },
    .{ .name = "SpecConstantWorkgroupSize", .value = 12, .operands = &nonsemantic_clspv_reflection_ext_operands_spec_constant_workgroup_size },
    .{ .name = "SpecConstantGlobalOffset", .value = 13, .operands = &nonsemantic_clspv_reflection_ext_operands_spec_constant_global_offset },
    .{ .name = "SpecConstantWorkDim", .value = 14, .operands = &nonsemantic_clspv_reflection_ext_operands_spec_constant_work_dim },
    .{ .name = "PushConstantGlobalOffset", .value = 15, .operands = &nonsemantic_clspv_reflection_ext_operands_push_constant_global_offset },
    .{ .name = "PushConstantEnqueuedLocalSize", .value = 16, .operands = &nonsemantic_clspv_reflection_ext_operands_push_constant_enqueued_local_size },
    .{ .name = "PushConstantGlobalSize", .value = 17, .operands = &nonsemantic_clspv_reflection_ext_operands_push_constant_global_size },
    .{ .name = "PushConstantRegionOffset", .value = 18, .operands = &nonsemantic_clspv_reflection_ext_operands_push_constant_region_offset },
    .{ .name = "PushConstantNumWorkgroups", .value = 19, .operands = &nonsemantic_clspv_reflection_ext_operands_push_constant_num_workgroups },
    .{ .name = "PushConstantRegionGroupOffset", .value = 20, .operands = &nonsemantic_clspv_reflection_ext_operands_push_constant_region_group_offset },
    .{ .name = "ConstantDataStorageBuffer", .value = 21, .operands = &nonsemantic_clspv_reflection_ext_operands_constant_data_storage_buffer },
    .{ .name = "ConstantDataUniform", .value = 22, .operands = &nonsemantic_clspv_reflection_ext_operands_constant_data_uniform },
    .{ .name = "LiteralSampler", .value = 23, .operands = &nonsemantic_clspv_reflection_ext_operands_literal_sampler },
    .{ .name = "PropertyRequiredWorkgroupSize", .value = 24, .operands = &nonsemantic_clspv_reflection_ext_operands_property_required_workgroup_size },
    .{ .name = "SpecConstantSubgroupMaxSize", .value = 25, .operands = &nonsemantic_clspv_reflection_ext_operands_spec_constant_subgroup_max_size },
    .{ .name = "ArgumentPointerPushConstant", .value = 26, .operands = &nonsemantic_clspv_reflection_ext_operands_argument_pointer_push_constant },
    .{ .name = "ArgumentPointerUniform", .value = 27, .operands = &nonsemantic_clspv_reflection_ext_operands_argument_pointer_uniform },
    .{ .name = "ProgramScopeVariablesStorageBuffer", .value = 28, .operands = &nonsemantic_clspv_reflection_ext_operands_program_scope_variables_storage_buffer },
    .{ .name = "ProgramScopeVariablePointerRelocation", .value = 29, .operands = &nonsemantic_clspv_reflection_ext_operands_program_scope_variable_pointer_relocation },
    .{ .name = "ImageArgumentInfoChannelOrderPushConstant", .value = 30, .operands = &nonsemantic_clspv_reflection_ext_operands_image_argument_info_channel_order_push_constant },
    .{ .name = "ImageArgumentInfoChannelDataTypePushConstant", .value = 31, .operands = &nonsemantic_clspv_reflection_ext_operands_image_argument_info_channel_data_type_push_constant },
    .{ .name = "ImageArgumentInfoChannelOrderUniform", .value = 32, .operands = &nonsemantic_clspv_reflection_ext_operands_image_argument_info_channel_order_uniform },
    .{ .name = "ImageArgumentInfoChannelDataTypeUniform", .value = 33, .operands = &nonsemantic_clspv_reflection_ext_operands_image_argument_info_channel_data_type_uniform },
    .{ .name = "ArgumentStorageTexelBuffer", .value = 34, .operands = &nonsemantic_clspv_reflection_ext_operands_argument_storage_texel_buffer },
    .{ .name = "ArgumentUniformTexelBuffer", .value = 35, .operands = &nonsemantic_clspv_reflection_ext_operands_argument_uniform_texel_buffer },
    .{ .name = "ConstantDataPointerPushConstant", .value = 36, .operands = &nonsemantic_clspv_reflection_ext_operands_constant_data_pointer_push_constant },
    .{ .name = "ProgramScopeVariablePointerPushConstant", .value = 37, .operands = &nonsemantic_clspv_reflection_ext_operands_program_scope_variable_pointer_push_constant },
    .{ .name = "PrintfInfo", .value = 38, .operands = &nonsemantic_clspv_reflection_ext_operands_printf_info },
    .{ .name = "PrintfBufferStorageBuffer", .value = 39, .operands = &nonsemantic_clspv_reflection_ext_operands_printf_buffer_storage_buffer },
    .{ .name = "PrintfBufferPointerPushConstant", .value = 40, .operands = &nonsemantic_clspv_reflection_ext_operands_printf_buffer_pointer_push_constant },
    .{ .name = "NormalizedSamplerMaskPushConstant", .value = 41, .operands = &nonsemantic_clspv_reflection_ext_operands_normalized_sampler_mask_push_constant },
    .{ .name = "WorkgroupVariableSize", .value = 42, .operands = &nonsemantic_clspv_reflection_ext_operands_workgroup_variable_size },
};

const nonsemantic_graph_debug_info_ext_operands_debug_graph = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_graph_debug_info_ext_operands_debug_operation = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const nonsemantic_graph_debug_info_ext_operands_debug_tensor = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .optional },
};

pub const nonsemantic_graph_debug_info_extinsts = [_]ExtInstInfo{
    .{ .name = "DebugGraph", .value = 1, .operands = &nonsemantic_graph_debug_info_ext_operands_debug_graph },
    .{ .name = "DebugOperation", .value = 2, .operands = &nonsemantic_graph_debug_info_ext_operands_debug_operation },
    .{ .name = "DebugTensor", .value = 3, .operands = &nonsemantic_graph_debug_info_ext_operands_debug_tensor },
};

const nonsemantic_vksp_reflection_ext_operands_configuration = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_vksp_reflection_ext_operands_start_counter = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_vksp_reflection_ext_operands_stop_counter = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_vksp_reflection_ext_operands_push_constants = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_vksp_reflection_ext_operands_specialization_map_entry = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_vksp_reflection_ext_operands_descriptor_set_buffer = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_vksp_reflection_ext_operands_descriptor_set_image = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const nonsemantic_vksp_reflection_ext_operands_descriptor_set_sampler = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};

pub const nonsemantic_vksp_reflection_extinsts = [_]ExtInstInfo{
    .{ .name = "Configuration", .value = 1, .operands = &nonsemantic_vksp_reflection_ext_operands_configuration },
    .{ .name = "StartCounter", .value = 2, .operands = &nonsemantic_vksp_reflection_ext_operands_start_counter },
    .{ .name = "StopCounter", .value = 3, .operands = &nonsemantic_vksp_reflection_ext_operands_stop_counter },
    .{ .name = "PushConstants", .value = 4, .operands = &nonsemantic_vksp_reflection_ext_operands_push_constants },
    .{ .name = "SpecializationMapEntry", .value = 5, .operands = &nonsemantic_vksp_reflection_ext_operands_specialization_map_entry },
    .{ .name = "DescriptorSetBuffer", .value = 6, .operands = &nonsemantic_vksp_reflection_ext_operands_descriptor_set_buffer },
    .{ .name = "DescriptorSetImage", .value = 7, .operands = &nonsemantic_vksp_reflection_ext_operands_descriptor_set_image },
    .{ .name = "DescriptorSetSampler", .value = 8, .operands = &nonsemantic_vksp_reflection_ext_operands_descriptor_set_sampler },
};

const nonsemantic_debug_break_ext_operands_debug_break = [_]OperandInfo{};

pub const nonsemantic_debug_break_extinsts = [_]ExtInstInfo{
    .{ .name = "DebugBreak", .value = 1, .operands = &nonsemantic_debug_break_ext_operands_debug_break },
};

const arm_motion_engine_100_ext_operands_min_sad = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const arm_motion_engine_100_ext_operands_min_sad_cost = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const arm_motion_engine_100_ext_operands_raw_sad = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};

pub const arm_motion_engine_100_extinsts = [_]ExtInstInfo{
    .{ .name = "MIN_SAD", .value = 0, .operands = &arm_motion_engine_100_ext_operands_min_sad },
    .{ .name = "MIN_SAD_COST", .value = 1, .operands = &arm_motion_engine_100_ext_operands_min_sad_cost },
    .{ .name = "RAW_SAD", .value = 2, .operands = &arm_motion_engine_100_ext_operands_raw_sad },
};

const arm_experimental_ml_operations_ext_operands_call = [_]OperandInfo{
    .{ .kind = .literal_integer, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};

pub const arm_experimental_ml_operations_extinsts = [_]ExtInstInfo{
    .{ .name = "CALL", .value = 0, .operands = &arm_experimental_ml_operations_ext_operands_call },
};

const tosa_001000_1_ext_operands_argmax = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_avg_pool2_d = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_conv2_d = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_conv3_d = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_depthwise_conv2_d = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_fft2_d = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_matmul = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_max_pool2_d = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_rfft2_d = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_transpose_conv2_d = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_clamp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_erf = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_sigmoid = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_tanh = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_add = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_arithmetic_right_shift = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_bitwise_and = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_bitwise_or = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_bitwise_xor = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_intdiv = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_logical_and = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_logical_left_shift = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_logical_right_shift = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_logical_or = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_logical_xor = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_maximum = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_minimum = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_mul = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_pow = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_sub = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_table = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_abs = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_bitwise_not = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_ceil = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_clz = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_cos = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_exp = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_floor = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_log = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_logical_not = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_negate = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_reciprocal = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_rsqrt = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_sin = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_select = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_equal = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_greater = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_greater_equal = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_reduce_all = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_reduce_any = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_reduce_max = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_reduce_min = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_reduce_product = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_reduce_sum = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_concat = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .variable },
};
const tosa_001000_1_ext_operands_pad = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_reshape = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_reverse = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_slice = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_tile = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_transpose = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_gather = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_scatter = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_resize = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_cast = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
};
const tosa_001000_1_ext_operands_rescale = [_]OperandInfo{
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
    .{ .kind = .id_ref, .quantifier = .one },
};

pub const tosa_001000_1_extinsts = [_]ExtInstInfo{
    .{ .name = "ARGMAX", .value = 0, .operands = &tosa_001000_1_ext_operands_argmax },
    .{ .name = "AVG_POOL2D", .value = 1, .operands = &tosa_001000_1_ext_operands_avg_pool2_d },
    .{ .name = "CONV2D", .value = 2, .operands = &tosa_001000_1_ext_operands_conv2_d },
    .{ .name = "CONV3D", .value = 3, .operands = &tosa_001000_1_ext_operands_conv3_d },
    .{ .name = "DEPTHWISE_CONV2D", .value = 4, .operands = &tosa_001000_1_ext_operands_depthwise_conv2_d },
    .{ .name = "FFT2D", .value = 5, .operands = &tosa_001000_1_ext_operands_fft2_d },
    .{ .name = "MATMUL", .value = 6, .operands = &tosa_001000_1_ext_operands_matmul },
    .{ .name = "MAX_POOL2D", .value = 7, .operands = &tosa_001000_1_ext_operands_max_pool2_d },
    .{ .name = "RFFT2D", .value = 8, .operands = &tosa_001000_1_ext_operands_rfft2_d },
    .{ .name = "TRANSPOSE_CONV2D", .value = 9, .operands = &tosa_001000_1_ext_operands_transpose_conv2_d },
    .{ .name = "CLAMP", .value = 10, .operands = &tosa_001000_1_ext_operands_clamp },
    .{ .name = "ERF", .value = 11, .operands = &tosa_001000_1_ext_operands_erf },
    .{ .name = "SIGMOID", .value = 12, .operands = &tosa_001000_1_ext_operands_sigmoid },
    .{ .name = "TANH", .value = 13, .operands = &tosa_001000_1_ext_operands_tanh },
    .{ .name = "ADD", .value = 14, .operands = &tosa_001000_1_ext_operands_add },
    .{ .name = "ARITHMETIC_RIGHT_SHIFT", .value = 15, .operands = &tosa_001000_1_ext_operands_arithmetic_right_shift },
    .{ .name = "BITWISE_AND", .value = 16, .operands = &tosa_001000_1_ext_operands_bitwise_and },
    .{ .name = "BITWISE_OR", .value = 17, .operands = &tosa_001000_1_ext_operands_bitwise_or },
    .{ .name = "BITWISE_XOR", .value = 18, .operands = &tosa_001000_1_ext_operands_bitwise_xor },
    .{ .name = "INTDIV", .value = 19, .operands = &tosa_001000_1_ext_operands_intdiv },
    .{ .name = "LOGICAL_AND", .value = 20, .operands = &tosa_001000_1_ext_operands_logical_and },
    .{ .name = "LOGICAL_LEFT_SHIFT", .value = 21, .operands = &tosa_001000_1_ext_operands_logical_left_shift },
    .{ .name = "LOGICAL_RIGHT_SHIFT", .value = 22, .operands = &tosa_001000_1_ext_operands_logical_right_shift },
    .{ .name = "LOGICAL_OR", .value = 23, .operands = &tosa_001000_1_ext_operands_logical_or },
    .{ .name = "LOGICAL_XOR", .value = 24, .operands = &tosa_001000_1_ext_operands_logical_xor },
    .{ .name = "MAXIMUM", .value = 25, .operands = &tosa_001000_1_ext_operands_maximum },
    .{ .name = "MINIMUM", .value = 26, .operands = &tosa_001000_1_ext_operands_minimum },
    .{ .name = "MUL", .value = 27, .operands = &tosa_001000_1_ext_operands_mul },
    .{ .name = "POW", .value = 28, .operands = &tosa_001000_1_ext_operands_pow },
    .{ .name = "SUB", .value = 29, .operands = &tosa_001000_1_ext_operands_sub },
    .{ .name = "TABLE", .value = 30, .operands = &tosa_001000_1_ext_operands_table },
    .{ .name = "ABS", .value = 31, .operands = &tosa_001000_1_ext_operands_abs },
    .{ .name = "BITWISE_NOT", .value = 32, .operands = &tosa_001000_1_ext_operands_bitwise_not },
    .{ .name = "CEIL", .value = 33, .operands = &tosa_001000_1_ext_operands_ceil },
    .{ .name = "CLZ", .value = 34, .operands = &tosa_001000_1_ext_operands_clz },
    .{ .name = "COS", .value = 35, .operands = &tosa_001000_1_ext_operands_cos },
    .{ .name = "EXP", .value = 36, .operands = &tosa_001000_1_ext_operands_exp },
    .{ .name = "FLOOR", .value = 37, .operands = &tosa_001000_1_ext_operands_floor },
    .{ .name = "LOG", .value = 38, .operands = &tosa_001000_1_ext_operands_log },
    .{ .name = "LOGICAL_NOT", .value = 39, .operands = &tosa_001000_1_ext_operands_logical_not },
    .{ .name = "NEGATE", .value = 40, .operands = &tosa_001000_1_ext_operands_negate },
    .{ .name = "RECIPROCAL", .value = 41, .operands = &tosa_001000_1_ext_operands_reciprocal },
    .{ .name = "RSQRT", .value = 42, .operands = &tosa_001000_1_ext_operands_rsqrt },
    .{ .name = "SIN", .value = 43, .operands = &tosa_001000_1_ext_operands_sin },
    .{ .name = "SELECT", .value = 44, .operands = &tosa_001000_1_ext_operands_select },
    .{ .name = "EQUAL", .value = 45, .operands = &tosa_001000_1_ext_operands_equal },
    .{ .name = "GREATER", .value = 46, .operands = &tosa_001000_1_ext_operands_greater },
    .{ .name = "GREATER_EQUAL", .value = 47, .operands = &tosa_001000_1_ext_operands_greater_equal },
    .{ .name = "REDUCE_ALL", .value = 48, .operands = &tosa_001000_1_ext_operands_reduce_all },
    .{ .name = "REDUCE_ANY", .value = 49, .operands = &tosa_001000_1_ext_operands_reduce_any },
    .{ .name = "REDUCE_MAX", .value = 50, .operands = &tosa_001000_1_ext_operands_reduce_max },
    .{ .name = "REDUCE_MIN", .value = 51, .operands = &tosa_001000_1_ext_operands_reduce_min },
    .{ .name = "REDUCE_PRODUCT", .value = 52, .operands = &tosa_001000_1_ext_operands_reduce_product },
    .{ .name = "REDUCE_SUM", .value = 53, .operands = &tosa_001000_1_ext_operands_reduce_sum },
    .{ .name = "CONCAT", .value = 54, .operands = &tosa_001000_1_ext_operands_concat },
    .{ .name = "PAD", .value = 55, .operands = &tosa_001000_1_ext_operands_pad },
    .{ .name = "RESHAPE", .value = 56, .operands = &tosa_001000_1_ext_operands_reshape },
    .{ .name = "REVERSE", .value = 57, .operands = &tosa_001000_1_ext_operands_reverse },
    .{ .name = "SLICE", .value = 58, .operands = &tosa_001000_1_ext_operands_slice },
    .{ .name = "TILE", .value = 59, .operands = &tosa_001000_1_ext_operands_tile },
    .{ .name = "TRANSPOSE", .value = 60, .operands = &tosa_001000_1_ext_operands_transpose },
    .{ .name = "GATHER", .value = 61, .operands = &tosa_001000_1_ext_operands_gather },
    .{ .name = "SCATTER", .value = 62, .operands = &tosa_001000_1_ext_operands_scatter },
    .{ .name = "RESIZE", .value = 63, .operands = &tosa_001000_1_ext_operands_resize },
    .{ .name = "CAST", .value = 64, .operands = &tosa_001000_1_ext_operands_cast },
    .{ .name = "RESCALE", .value = 65, .operands = &tosa_001000_1_ext_operands_rescale },
};

pub fn operandCategory(kind: OperandKind) OperandCategory {
    return switch (kind) {
        .access_qualifier => .value_enum,
        .addressing_model => .value_enum,
        .built_in => .value_enum,
        .capability => .value_enum,
        .component_type => .value_enum,
        .cooperative_matrix_layout => .value_enum,
        .cooperative_matrix_operands => .bit_enum,
        .cooperative_matrix_reduce => .bit_enum,
        .cooperative_matrix_use => .value_enum,
        .cooperative_vector_matrix_layout => .value_enum,
        .decoration => .value_enum,
        .dim => .value_enum,
        .execution_mode => .value_enum,
        .execution_model => .value_enum,
        .fp_denorm_mode => .value_enum,
        .fp_encoding => .value_enum,
        .fp_fast_math_mode => .bit_enum,
        .fp_operation_mode => .value_enum,
        .fp_rounding_mode => .value_enum,
        .fragment_shading_rate => .bit_enum,
        .function_control => .bit_enum,
        .function_parameter_attribute => .value_enum,
        .gather_modes => .value_enum,
        .group_operation => .value_enum,
        .host_access_qualifier => .value_enum,
        .id_memory_semantics => .id,
        .id_ref => .id,
        .id_result => .id,
        .id_result_type => .id,
        .id_scope => .id,
        .image_channel_data_type => .value_enum,
        .image_channel_order => .value_enum,
        .image_format => .value_enum,
        .image_operands => .bit_enum,
        .initialization_mode_qualifier => .value_enum,
        .kernel_enqueue_flags => .value_enum,
        .kernel_profiling_info => .bit_enum,
        .linkage_type => .value_enum,
        .literal_context_dependent_number => .literal,
        .literal_ext_inst_integer => .literal,
        .literal_float => .literal,
        .literal_integer => .literal,
        .literal_spec_constant_op_integer => .literal,
        .literal_string => .literal,
        .load_cache_control => .value_enum,
        .loop_control => .bit_enum,
        .matrix_multiply_accumulate_operands => .bit_enum,
        .memory_access => .bit_enum,
        .memory_model => .value_enum,
        .memory_semantics => .bit_enum,
        .named_maximum_number_of_registers => .value_enum,
        .overflow_modes => .value_enum,
        .packed_vector_format => .value_enum,
        .pair_id_ref_id_ref => .composite,
        .pair_id_ref_literal_integer => .composite,
        .pair_literal_integer_id_ref => .composite,
        .quantization_modes => .value_enum,
        .raw_access_chain_operands => .bit_enum,
        .ray_flags => .bit_enum,
        .ray_query_candidate_intersection_type => .value_enum,
        .ray_query_committed_intersection_type => .value_enum,
        .ray_query_intersection => .value_enum,
        .sampler_addressing_mode => .value_enum,
        .sampler_filter_mode => .value_enum,
        .scope => .value_enum,
        .selection_control => .bit_enum,
        .source_language => .value_enum,
        .storage_class => .value_enum,
        .store_cache_control => .value_enum,
        .tensor_addressing_operands => .bit_enum,
        .tensor_clamp_mode => .value_enum,
        .tensor_operands => .bit_enum,
        .debug_info_debug_base_type_attribute_encoding => .value_enum,
        .debug_info_debug_composite_type => .value_enum,
        .debug_info_debug_info_flags => .bit_enum,
        .debug_info_debug_operation => .value_enum,
        .debug_info_debug_type_qualifier => .value_enum,
        .nonsemantic_clspv_reflection_kernel_property_flags => .bit_enum,
        .nonsemantic_shader_debug_info_100_build_identifier_flags => .bit_enum,
        .nonsemantic_shader_debug_info_100_debug_base_type_attribute_encoding => .value_enum,
        .nonsemantic_shader_debug_info_100_debug_composite_type => .value_enum,
        .nonsemantic_shader_debug_info_100_debug_imported_entity => .value_enum,
        .nonsemantic_shader_debug_info_100_debug_info_flags => .bit_enum,
        .nonsemantic_shader_debug_info_100_debug_operation => .value_enum,
        .nonsemantic_shader_debug_info_100_debug_type_qualifier => .value_enum,
        .nonsemantic_shader_debug_info_build_identifier_flags => .bit_enum,
        .nonsemantic_shader_debug_info_debug_base_type_attribute_encoding => .value_enum,
        .nonsemantic_shader_debug_info_debug_composite_type => .value_enum,
        .nonsemantic_shader_debug_info_debug_imported_entity => .value_enum,
        .nonsemantic_shader_debug_info_debug_info_flags => .bit_enum,
        .nonsemantic_shader_debug_info_debug_operation => .value_enum,
        .nonsemantic_shader_debug_info_debug_type_qualifier => .value_enum,
        .opencl_debug_info_100_debug_base_type_attribute_encoding => .value_enum,
        .opencl_debug_info_100_debug_composite_type => .value_enum,
        .opencl_debug_info_100_debug_imported_entity => .value_enum,
        .opencl_debug_info_100_debug_info_flags => .bit_enum,
        .opencl_debug_info_100_debug_operation => .value_enum,
        .opencl_debug_info_100_debug_type_qualifier => .value_enum,
    };
}

pub fn lookupOpcode(name: []const u8) ?OpcodeInfo {
    for (opcodes) |info| {
        if (asciiEql(info.name, name)) return info;
    }
    return null;
}

pub fn lookupEnumerant(kind: OperandKind, name: []const u8) ?EnumerantInfo {
    for (enumerants) |info| {
        if (info.kind == kind and asciiEql(info.name, name)) return info;
    }
    return null;
}

pub fn lookupSpecConstantOpcode(name: []const u8) ?OpcodeInfo {
    for (spec_constant_opcodes) |info| {
        if (asciiEql(info.name, name)) return info;
    }
    return null;
}

pub fn lookupSpecConstantOpcodeValue(value: Word) ?OpcodeInfo {
    for (spec_constant_opcodes) |info| {
        if (info.opcode == value) return info;
    }
    return null;
}

pub fn lookupExtInstSet(name: []const u8) ?ExtInstSet {
    for (ext_inst_sets) |info| {
        if (asciiEql(info.name, name)) return info.set;
        if (info.prefix and name.len >= info.name.len and asciiEql(info.name, name[0..info.name.len])) return info.set;
    }
    return null;
}

pub fn lookupExtInst(set: ExtInstSet, name: []const u8) ?ExtInstInfo {
    const instructions: []const ExtInstInfo = switch (set) {
        .glsl_std_450 => &glsl_std_450_extinsts,
        .opencl_std => &opencl_std_extinsts,
        .opencl_debug_info_100 => &opencl_debug_info_100_extinsts,
        .nonsemantic_shader_debug_info_100 => &nonsemantic_shader_debug_info_100_extinsts,
        .nonsemantic_shader_debug_info => &nonsemantic_shader_debug_info_extinsts,
        .debug_info => &debug_info_extinsts,
        .nonsemantic_debug_printf => &nonsemantic_debug_printf_extinsts,
        .amd_trinary_minmax => &amd_trinary_minmax_extinsts,
        .amd_explicit_vertex_parameter => &amd_explicit_vertex_parameter_extinsts,
        .amd_gcn_shader => &amd_gcn_shader_extinsts,
        .amd_shader_ballot => &amd_shader_ballot_extinsts,
        .nonsemantic_clspv_reflection => &nonsemantic_clspv_reflection_extinsts,
        .nonsemantic_graph_debug_info => &nonsemantic_graph_debug_info_extinsts,
        .nonsemantic_vksp_reflection => &nonsemantic_vksp_reflection_extinsts,
        .nonsemantic_debug_break => &nonsemantic_debug_break_extinsts,
        .arm_motion_engine_100 => &arm_motion_engine_100_extinsts,
        .arm_experimental_ml_operations => &arm_experimental_ml_operations_extinsts,
        .tosa_001000_1 => &tosa_001000_1_extinsts,
    };
    for (instructions) |info| {
        if (asciiEql(info.name, name)) return info;
    }
    return null;
}

pub fn lookupGlslStd450ExtInst(name: []const u8) ?ExtInstInfo {
    return lookupExtInst(.glsl_std_450, name);
}

fn asciiEql(lhs: []const u8, rhs: []const u8) bool {
    if (lhs.len != rhs.len) return false;
    for (lhs, rhs) |a, b| {
        if (a != b) return false;
    }
    return true;
}

test "SPV text table smoke" {
    const testing = @import("std").testing;
    try testing.expect(lookupOpcode("OpCapability") != null);
    try testing.expect(lookupEnumerant(.capability, "Shader") != null);
    try testing.expectEqual(ExtInstSet.opencl_std, lookupExtInstSet("OpenCL.std").?);
    try testing.expect(lookupExtInst(.opencl_std, "acos") != null);
    try testing.expect(lookupExtInst(.opencl_debug_info_100, "DebugInfoNone") != null);
}
