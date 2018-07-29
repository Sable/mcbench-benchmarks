function [AUMestimate,AC] = weightestimate_decVar(AC)
% Write this weight estimation function to estimate the all up mass (TOGW)
% based on all physical parameters of the aircraft, including propulsion
% AND WEIGHTS. The key field to return is the new AUMestimate. However, if
% you want, add fields in the AC structure for use in project-specific
% functions (i.e. AC.W.Wcrew, AC.W.Wrotors, AC.Rotor.weightdistribution)

AUMestimate = AC.Vars.AUM*1000; %AUM in AC.Vars in tonne. convert to kg
