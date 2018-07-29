% Calculates Tissue Partition Coefficients for acidic, basic, neutral and
% zwitterion Drugs. Equations taken from:
%   Rodgers, T., Leahy, D., & Rowland, M. (2005). 
%   Physiologically based pharmacokinetic modeling 1: predicting the tissue distribution of moderate-to-strong bases. 
%   Journal of pharmaceutical sciences, 94(6), 1259-76. doi:10.1002/jps.20322
% and:
%   Rodgers, T., & Rowland, M. (2006). 
%   Physiologically Based Pharmacokinetic Modelling 2 : Predicting the Tissue Distribution of Acids , Very Weak Bases , Neutrals and Zwitterions. 
%   Journal of pharmaceutical sciences, 95(6), 1238-1257. doi:10.1002/jps

% TissuetoPlasmaProteinRatio - Tissue to Plasma ratio for albumin in the
% case of neutral drugs and lipoproteins in the case of weak bases and acids 
% Copyright 2012 The MathWorks, Inc.

function [TissuePartitionCoefficient] = calculateTissuePartition(...
    DrugIsBase, DrugIsAcid, DrugIsNeutral,...% switch drug types
    DrugpKa, DrugpKb, DrugLogP, DrugBloodPlasmaRatio, DrugFractionUnbound,... % Drug parameters
    pHBC, pHIW, pHP, fracEW, fracIW, fracIWBC, fracNLBC, fracNPBC, fracNL, fracNP, fracNLP, fracNPP, CAcidicPhospholipidsT, CAcidicPhospholipidsBC, Hematocrit, TissuetoPlasmaProteinRatio... % organism/Tissue parameters
    ) 

DrugP = 10^DrugLogP;

KpuBC = (Hematocrit - 1 + DrugBloodPlasmaRatio)/(DrugFractionUnbound * Hematocrit);

KaBC = (KpuBC - ((1 + 10^(DrugpKa - pHBC))/(1+10^(DrugpKa - pHP)) * fracIWBC) - ...
        ((DrugP * fracNLBC + (0.3 *DrugP + 0.7) * fracNPBC)/(1+10^(DrugpKa-pHP)))) *...
        ((1+10^(DrugpKa-pHP))/(CAcidicPhospholipidsBC * 10^(DrugpKa - pHBC)));  % Drug Association Rate with acidic phospholipids in red blood cells (Eq. 20 in:
% Rodgers, T., Leahy, D., & Rowland, M. (2005). 
% Physiologically based pharmacokinetic modeling 1: predicting the tissue distribution of moderate-to-strong bases. 
% Journal of pharmaceutical sciences, 94(6), 1259-76. doi:10.1002/jps.20322


% distinguish ionisation type
if DrugIsNeutral
    facX = 1; facY = 1;
elseif DrugIsBase && DrugIsAcid % zwitterions, where pKa is given for the acidic part and pKb is given for the basic part
    facX = 1 + 10^(14-DrugpKb - pHIW) + 10^(pHIW - DrugpKa);
    facY = 1 + 10^(14-DrugpKb - pHP) + 10^(pHP - DrugpKa);
elseif DrugIsAcid
    facX = 1 + 10^(pHIW - DrugpKa);
    facY = 1 + 10^(pHP - DrugpKa);
elseif DrugIsBase && ~DrugIsAcid
    facX = 1 + 10^(DrugpKa - pHIW);
    facY = 1 + 10^(DrugpKa - pHP);
end
%
if DrugIsBase && DrugIsAcid && DrugpKa >= 7 % group 1 zwitterions 
    
    TissuePartitionCoefficient = fracEW + ((facX * fracIW)/(facY))...
                                 + (DrugP * fracNL + (0.3 + DrugP + 0.7) * fracNP)/facY...
                                 + (KaBC * CAcidicPhospholipidsT * 10^(14-DrugpKb -pHIW) + 10^(pHIW - DrugpKa))/facY;
    
elseif DrugIsBase && DrugpKa >=7 % moderate to strong bases
    
    TissuePartitionCoefficient = fracEW + (facX/facY * fracIW)...
                                        + ((KaBC * CAcidicPhospholipidsT * 10^(DrugpKa - pHIW))/facY)...
                                        + ((DrugP * fracNL + ((0.3*DrugP + 0.7) * fracNP))/facY);
                                        
elseif (DrugIsNeutral || DrugIsAcid) || (DrugIsBase && DrugpKa < 7) % acids, weak bases, neutral drugs, group 2 zwitterions
    
    TissuePartitionCoefficient = fracEW + (facX/facY * fracIW) + (DrugP * fracNL + (0.3*DrugP + 0.7) * fracNP)/facY...
                                 + ((1/DrugFractionUnbound - 1 - ((DrugP * fracNLP + (0.3*DrugP + 0.7) * fracNPP)/facY))) * TissuetoPlasmaProteinRatio;
    
end
