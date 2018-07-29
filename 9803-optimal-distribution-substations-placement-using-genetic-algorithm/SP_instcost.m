% this function dedicates the primary installation cost
% for any distribution substation in $
function subscost = SP_instcost(substation)

global KWTransformersTypes InstallCosts
Tag = find(KWTransformersTypes == substation);
subscost = InstallCosts(1,Tag);
d=0;
