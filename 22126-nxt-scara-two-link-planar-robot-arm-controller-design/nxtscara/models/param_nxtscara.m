% Load NXT SCARA Parameters

param_plant				% Plant Parameters
param_controller		% Controller Parameters
param_sim				% Simulation and Virtual Reality Parameters

% Reference Parameters (Circle)
cp_ptp = cal_cp_ptp('Circle', ts1, l1, l2);
param_ref
