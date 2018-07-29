% Script to find directional valve orifice area parameter values (table)
% 3-Way Valve
% Copyright 2010 MathWorks, Inc.

% This script file invokes optimization process to find out the relationship
% between the orifice area and valve displacement for 3-way valve whose
% flow rate characteristic is specified by the table with 11 displacement-flow
% rate pairs. The valve is simulated with the second parameterization
% option.  Two optimization functions can be used. fmionserarch is available in
% standard MATLAB, while fminunc is available only in Optimization Toolbox

% Maximum flow rate at 10 bar pressure drop across the valve. Obtained from
% table 2 of the ATOS Proportional Throttle Cartridges type LIQZO-L63,
% page F340.
Q_max = 1750;               % [lpm]

% Required flow. Obtained from plot in note 6 of the ATOS Proportional
% Throttle Cartridges type LIQZO-L, page F340.
Q_r = [0 5 10 20 32 43 55 67 79 90 100] * Q_max/100;

% Set initial values for variable parameters
x0 = [0.4 0.8 1.5 2.5 3.2 4.5 6 7.5 9 10];           % [cm^2]

% Perform optimization
%{
[x,fval,exitflag,output] = ...
    fminsearch(@obj_find_valve_param_table_3way,x0, ...
    optimset('Tolx',1e-6,'Display','iter'),Q_r);
%}


[x,fval,exitflag,output] = ...
    fminunc(@obj_find_valve_param_table_3way,x0, ...
    optimset('Tolx',1e-6,'Display','iter','LargeScale','off'),Q_r);

