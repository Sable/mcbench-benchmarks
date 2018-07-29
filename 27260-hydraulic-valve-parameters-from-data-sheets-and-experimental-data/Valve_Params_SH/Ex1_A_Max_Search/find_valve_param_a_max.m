% Script to find directional valve parameter a_max
% Copyright 2010 MathWorks, Inc.

% This script file invokes optimization process to find the orifice
% area at maximum opening for 4-way directional valve when the valve is
% modeled using the first parameterization option (linear relationship
% between control signal and orifice area).

% init_opening - vaalve initial openings [mm]
% A_leak - leakage area  [m^2]
% Q_r - vector of required flow rate at 11 valve displacements
% x0 - initial value for the only variable parameter: orifice maximum area

init_opening = -1;     % mm
A_leak = 1e-9;         % m^2

% Vector of required flow rates. Read out from plot on page 8 in 
% Eaton/Vickers Porportional Directional Valves catalog for KBFDG5V-10 valve
% Actual flow rates are determined at fixed instances of time by exporting
% flow rate measured at the external loop of the valve to the MATLAB
% workspace

Q_r = [0 0 52 150 248 346 450 540 625 670 700];

% Set initial value of the orifice maximum area
x0 = 4.8;           % [cm^2]

% Optimization
[x,fval,exitflag,output] = ...
    fminsearch(@obj_find_valve_param_a_max,x0, ...
    optimset('Tolx',1e-6,'Display','iter'),Q_r);

%bdclose all