% Script to find directional valve orifice area parameter values (table)
% Copyright 2010 MathWorks, Inc.

% This script file invokes optimization process to find the relationship
% between the orifice area and valve displacement for 4-way valve whose
% flow rate characteristic is specified by the table with 11 displacement-flow
% rate pairs. The valve is modeled with the second parameterization option
% (table relationship between control signal and orifice area).
% Two optimization functions can be used. fmionserarch is available in
% standard MATLAB, while fminunc is available only in Optimization Toolbox

% Variable parameters
% x0 - vector initial values for orifice areas
% Q_r - vector of required flow rate at 11 valve displacements

init_opening = 0; 
A_leak = 1e-9;
a_max = 5.9648; 

% Vector of required flow rates. Read out from plot on page 8 in 
% Eaton/Vickers Porportional Directional Valves catalog for KBFDG5V-10 valve
% Actual flow rates are determined at fixed instances of time by exporting
% flow rate measured at the external loop of the valve to MATLAB workspace.

Q_r = [0 0 52 150 248 346 450 540 625 670 700];         % [l/min]

% Set initial values
x0 = [0 0.5 1 2 3 4 5 6 7 8 9];           % [cm^2]


% Optimization with fminunc 
[x,fval,exitflag,output] = ...
    fminunc(@obj_find_valve_param_table_area_vs_disp_4way,x0, ...
    optimset('Tolx',1e-3,'Display','iter','LargeScale','off'),Q_r);
%

%{
% Optimization with fminsearch
[x,fval,exitflag,output] = ...
    fminsearch(@obj_find_valve_param_table_area_vs_disp_4way,x0, ...
    optimset('Tolx',1e-3,'Display','iter'),Q_r);
%}
