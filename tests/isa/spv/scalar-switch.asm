spv.use()
OpCapability Shader
OpCapability Int64
OpCapability Float16
OpCapability Float64
OpCapability BFloat16TypeKHR
OpExtension "SPV_KHR_bfloat16"
OpMemoryModel Logical GLSL450
OpEntryPoint GLCompute %main "main"
OpExecutionMode %main LocalSize 1 1 1
%void = OpTypeVoid
%fn = OpTypeFunction %void
%u64 = OpTypeInt 64 0
%half = OpTypeFloat 16
%single = OpTypeFloat 32
%double = OpTypeFloat 64
%bfloat = OpTypeFloat 16 BFloat16KHR
%selector = OpConstant %u64 0x123456789abcdef0
%half_value = OpConstant %half 1.0009
%bfloat_value = OpConstant %bfloat 1
%single_nan = OpConstant %single 0x1.8p+128
%double_nan = OpConstant %double 0x1.8p+1024
%main = OpFunction %void None %fn
%entry = OpLabel
OpSelectionMerge %merge None
OpSwitch %selector %default 0x123456789abcdef0 %case
%case = OpLabel
OpBranch %merge
%default = OpLabel
OpBranch %merge
%merge = OpLabel
OpReturn
OpFunctionEnd
