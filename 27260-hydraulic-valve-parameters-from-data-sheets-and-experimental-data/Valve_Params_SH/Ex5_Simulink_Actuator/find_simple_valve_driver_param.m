% Script file to find parameters for simplified valve actuator model
% Copyright 2010 MathWorks, Inc.

% This script file invokes optimization process to find out a suitable
% approximation to the characteristic of the 2-Position Valve Actuator with
% a simple, Simulink-based model of the actuator

% Required characteristics
t_on = 0.2;         % [s]
stroke = 0.005;     % [m]
gain = stroke/12;   % 12 is a command signal

% Two actuator parameters, time constant and delay time are determined
% during optimization

% Set initial values for variable parameters
x0 = [0.1 0.2/3];

% Perform optimization
[x,fval,exitflag,output] = ...
    fminsearch(@obj_find_simple_valve_driver_param,x0, ...
    optimset('Tolx',1e-6,'Display','iter'));