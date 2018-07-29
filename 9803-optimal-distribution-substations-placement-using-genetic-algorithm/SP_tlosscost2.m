% this function return the transformer's (input argument) loss
function FValue=SP_tlosscost1(InValue)

global KWTransformersTypes ShortCircuitLosses
Tag = find(KWTransformersTypes == InValue);
FValue = ShortCircuitLosses(1,Tag);
