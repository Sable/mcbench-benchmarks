% Script file to determine valve actuator parameters using FFTs
% Copyright 2010 MathWorks, Inc.

% This script file is designed to find three  parameters of the valve
% actuator: Gain, Time Constant, and Saturation, by computing frequency
% response of the actuator by applying the Fast Fourier Transform to the
% pulse transient response of the system. The script analyzes two pulse
% responses of the valve actuator. One corresponds to a 100% rated signal,
% while the other is a 20% of rated signal. The script invokes the
% optimization procedure which is set to find match between the required
% and actual frequency characteristics. The characteristics are compared by
% frequency at which phase shift in -90 deg takes place. After the
% optimization is completed, the check of the obtained parameters is
% performed either with the FFT or direct measurement method.

% Specifying required frequency at which -90 deg phase shift occurs
frequency_20 = 25;      % Frequency (Hz) at -90 deg shift angle and 20% input
frequency_100 = 10;     % Frequency (Hz) at -90 deg shift angle and 100% input

% Set initial value. x0 =[gain, time_const, saturation]
x0 = [300, 0.01, 0.8];

% Optimization
[x,fval,exitflag,output] = ...
    fminsearch(@obj_actuator_param_pulse_FFT_method,x0, ...
    optimset('Tolx',1e-6,'Display','iter'),frequency_20,frequency_100);

% Determine accuracy using FFT
check_frequency_response(x, frequency_20, frequency_100,'FFT');

%% Determine accuracy using direct method (time domain)
check_frequency_response(x, frequency_20, frequency_100, 'Direct');