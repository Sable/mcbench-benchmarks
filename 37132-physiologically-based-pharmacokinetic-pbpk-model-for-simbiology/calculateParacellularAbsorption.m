function paracellularAbsorption = calculateParacellularAbsorption(DrugLogP, DrugMolecularWeight)
% calculate the paracellular absorption rate using the heuristics presented
% in Eq. 2 in: 
% Peters, S. A. (2008). Evaluation of a generic physiologically based pharmacokinetic model for lineshape analysis. Clinical pharmacokinetics, 47(4), 261-75.
% Copyright 2012 The MathWorks, Inc.

paracellularAbsorption = 0;
if DrugLogP > 0.7, 
    paracellularAbsorption = 0; 
elseif DrugLogP < 0.1 && (DrugMolecularWeight > 200 && DrugMolecularWeight < 360), 
    paracellularAbsorption = 0.1;
elseif DrugMolecularWeight < 200,  
    paracellularAbsorption = -0.0045*DrugMolecularWeight+1;
end

%paracellularAbsorption = paracellularAbsorption*5;