% this function return the transformer's (input argument) loss
function FValue=SP_tlosscost1(InValue)

global KWTransformersTypes OpenCircuitLosses
Tag = find(KWTransformersTypes == InValue);
FValue = OpenCircuitLosses(1,Tag);
