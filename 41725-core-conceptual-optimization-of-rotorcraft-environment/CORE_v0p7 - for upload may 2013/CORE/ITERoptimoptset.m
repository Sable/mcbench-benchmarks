function [Problem,Constraints,Objectives] = ITERoptimoptset(Spec)

LBX0UB = [Spec.MyDesignTypVals,Spec.MyDesignTypVals,Spec.MyDesignTypVals];
Xnames=Spec.MyDesignXnames;


active_decX = false(length(Xnames),1);
active_decX(1:5) = true;

% defaults assume (from hist AC;~ min, median, max):
LBX0UBbase= [   12  40  70  ;% Disc Loading (kg/m2)
    .15     .25     .4  ;% Power to Weight (kW/kg)
    .03     .075    .15 ;% Solidity
    200     220     238 ;% Tip Speed (m/s)
    .08     .17     .275;% Fuel Fraction
    2       5       7   ;% Blades
    -20     -8      0   ;% Twist  (deg)
    0       0       .4  ;% Thrust to Weight
    0       0       2   ;% Sp. Wing Area (m2/tonne)
    6       7       9   ];% Wing AR

nBuiltInVars = size(LBX0UBbase,1);
LBX0UB(1:nBuiltInVars,1) = LBX0UBbase(:,1);
LBX0UB(1:nBuiltInVars,3) = LBX0UBbase(:,3);

X0 = LBX0UB(:,2);
LB = LBX0UB(:,1);
UB = LBX0UB(:,3);

%%
totalncons = Spec.nPPrequirements + Spec.nnonl;
active_constraints = true(totalncons,1);
extra_margins = zeros(totalncons,1);
useBEA = false(Spec.nPPrequirements,1);

nObj = Spec.nObj;
single_objective_weightings = ones(nObj,1);
ObjLabels = Spec.Objlabels;

for ii = 1:nObj
    if strncmpi('Obj_max',func2str(Spec.Objfuncs{ii}),7)
        single_objective_weightings(ii) = -1;
    end
end

nCons = totalncons;

conLabels = [Spec.PPlabels;Spec.nonllabels];

Problem.x0 =    X0;
Problem.Aineq = [];
Problem.bineq = [];
Problem.Aeq =   [];
Problem.beq =   [];
Problem.lb =    LB;
Problem.ub =    UB;
Problem.XLabels = Xnames;
Problem.activeX = active_decX;

Constraints.nCons = nCons;
Constraints.conLabels = conLabels;
Constraints.active_cons = active_constraints;
Constraints.useBEA = useBEA;
Constraints.margins = extra_margins;

Objectives.weightings = single_objective_weightings;
Objectives.nObj = nObj;
Objectives.ObjLabels = ObjLabels;