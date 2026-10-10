spv.use()
const main: u64 = 29
const void: u64 = 30
const fnty: u64 = 31
const entry: u64 = 32

OpCapability Shader
OpMemoryModel Logical GLSL450
OpEntryPoint GLCompute %main "main"
OpExecutionMode %main LocalSize 1 1 1
OpName %main "here()"
OpName %main "label_addr(\"entry\")"
%void = OpTypeVoid
%fnty = OpTypeFunction %void
%main = OpFunction %void None %fnty
%entry = OpLabel
OpReturn
OpFunctionEnd
