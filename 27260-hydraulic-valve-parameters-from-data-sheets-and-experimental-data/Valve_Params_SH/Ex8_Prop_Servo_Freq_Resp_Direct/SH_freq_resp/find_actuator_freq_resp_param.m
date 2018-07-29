% Script to find valve actuator parameters that match frequency response
% using frestimate.
% Copyright 2010 MathWorks, Inc.

% This script file is designed to find three parameters of the
% valve actuator: Gain, Time Constant, and Saturation, by 
% measuring its frequency response to sinusoidal signal at two frequencies.
% The script analyzes the valve actuator at 100% and 40% of maximum input
% signal. The script invokes the optimization procedure which is set to 
% find match between the required and actual frequency characteristics. 
%
% After the optimization is completed, the phase of the frequency response
% from simulation is compared to the required characteristic.

amplitude_100 = 0.2;
frequency_100 = [20 43];
amplitude_40  = amplitude_100*0.4;
frequency_40  = [20 57];      

% Set initial value. x0 =[gain, time_const, saturation]
x0 = [50 5e-2 2];

% Matrices and vectors defining constraints (none)
A=[]; b=[]; Aeq = []; beq = []; nonlcon = [];

% Vectors defining parameter bounds
lb = [10 2e-5 1];
ub = [200 1e-1 8];

[x,fval,exitflag,output] = ...
    fmincon(@obj_actuator_freq_resp_param,x0,A,b,Aeq,beq,lb,ub,nonlcon, ...
    optimset('Tolx',1e-3,'Display','iter','Algorithm','Interior-point'),amplitude_40, frequency_40, amplitude_100, frequency_100);

check_phase_plots
