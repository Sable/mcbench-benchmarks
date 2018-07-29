% this function convert the input to a correspounding kVA.

function OutVal = SP_2kva(InVal)

global KWTransformersTypes TransformersTypes
Tag = find(KWTransformersTypes == InVal);
OutVal = TransformersTypes(1,Tag);
