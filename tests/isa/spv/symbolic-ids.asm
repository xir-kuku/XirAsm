// Symbolic SPIR-V IDs: `%name` instead of `%number`.
//
// Two things are being checked at once:
//
//   1. a name is numbered from its FIRST APPEARANCE, not from where it is
//      defined, so `%main` is 1 because OpEntryPoint names it before its
//      OpFunction line;
//   2. a literal ID keeps the number it was written with, and the names step
//      over it: `%2` stays 2, so `%fnty` takes 3 and `%lbl` takes 4.
//
// The numbers this module encodes to are therefore main=1, void=2, fnty=3,
// lbl=4, with bound 5.
spv.use();

OpCapability Shader
OpMemoryModel Logical GLSL450
OpEntryPoint GLCompute %main "main"
OpExecutionMode %main LocalSize 1 1 1
%2 = OpTypeVoid
%fnty = OpTypeFunction %2
%main = OpFunction %2 None %fnty
%lbl = OpLabel
OpReturn
OpFunctionEnd
