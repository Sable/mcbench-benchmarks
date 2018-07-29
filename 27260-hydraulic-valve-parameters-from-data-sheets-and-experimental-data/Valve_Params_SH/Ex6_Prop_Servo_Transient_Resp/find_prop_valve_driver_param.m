% Script file to find servo-valve actuator parameters
% Copyright 2010 MathWorks, Inc.

% This script file invokes optimization process to find out parameters
% of the Proportional and Servo-Valve Actuator that match specified
% transient responses. Two transient responses are specified: (1) at
% 100% input signal and (2) at 20% input signal. The first transient
% response is set through the Lookup table block while the second one
% is specified by the collection of Simulink blocks

% Required transient response
req_response_time = 0:0.004:0.1;
req_response_signal = ...
   [0         0.2250    0.7771    1.5274    2.3980    3.3415    4.3292 ...
    5.3438    6.3747    7.4155    8.4623    9.4906   10.2824   10.6682 ...
   10.6791   10.4592   10.1727    9.9414    9.8207    9.8074    9.8635 ...
    9.9431   10.0103   10.0476   10.0544   10.0403];
   
% Variable parameters
% gain           - x(1)
% time_constant - x(2)
% saturation    - x(3)

% Set initial values
x0 = [200 0.01 5];

% Optimization
[x,fval,exitflag,output] = ...
    fminsearch(@obj_find_prop_valve_driver_param, x0, ...
    optimset('Tolx',1e-3,'Display','iter'));

