% Script to find valve actuator parameters that match frequency response
% using the direct method (time domain).
% Copyright 2010 MathWorks, Inc.

% This script file is designed to find three parameters of the
% valve actuator: Gain, Time Constant, and Saturation, by directly 
% measuring its frequency response to sinusoidal signal at frequency
% at which the phase shift of the real actuator equals -90 deg.
% The script analyzes the valve actuator at two input signals: 100% and
% The script invokes the optimization procedure which is set to find match
% between the required and actual frequency characteristics. The  
% characteristics are compared by the phase shift values at specified 
% frequencies.
% After the optimization is completed, the check of the
% obtained parameters is performed with the same direct measurement method.

% Specifying required frequencies at which -90 deg phase shift occurs
frequency_20 = 25;      % Frequency (Hz) at -90 deg shift angle and 20% input
frequency_100 = 10;     % Frequency (Hz) at -90 deg shift angle and 100% input

% Set initial value. x0 =[gain, time_const, saturation]
x0 = [300, 0.01, 0.8];

[x,fval,exitflag,output] = ...
    fminsearch(@obj_actuator_param_direct_method,x0, ...
    optimset('Tolx',1e-3,'Display','iter'),frequency_20,frequency_100);

check_frequency_response(x,frequency_20,frequency_100,'Direct');
