function F  = obj_find_valve_param_table_area_vs_disp_4way(x,Q_r)
% Objective function to find out the required area vs. spool displacement
% relationship.
% Copyright 2010 MathWorks, Inc.

% x - vector of variable parameters. The vector is compiled of ten area
% values a_1 ... a_10, which are the cross-sectional areas of the valve
% orifice at 10 successive spool position s_1 ... s_10. The positions are
% set by shifting the spool from zero to its maximum opening at constant
% speed.

% Q_r - vector of required flow rates. Read out from plot on page 8 in 
% Eaton/Vickers Porportional Directional Valves catalog for KBFDG5V-10 valve
% Actual flow rates are determined at fixed instances of time by exporting
% flow rate measured at the external loop of the valve to the MATLAB
% workspace

% Assigning respective values of the variable parameters to valve
% parameters via the workspace
assignin('base','a_1', x(1));
assignin('base','a_2', x(2));
assignin('base','a_3', x(3));
assignin('base','a_4', x(4));
assignin('base','a_5', x(5));
assignin('base','a_6', x(6));
assignin('base','a_7', x(7));
assignin('base','a_8', x(8));
assignin('base','a_9', x(9));
assignin('base','a_10', x(10));

% If necessary, reset parameterizaton to second option (table)
model = 'valve_testrig_flow_char_4way';
load_system(model);
blkpth = find_system(bdroot,'ClassName','valve_dir_4_way');
set_param(char(blkpth),'mdl_type','2');
sim(model);

k = [1 1 1 0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2];          % Weight multipliers

% Computing objective function
F = 0;
for j = 1:11
    F = F + k(j) * (yout(j) - Q_r(j))^2;
end
end

% EOF