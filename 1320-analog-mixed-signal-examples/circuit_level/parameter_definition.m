% DC to Dc Buck Converter Parameters
% Dick Benson
% Copyright 2013 The MathWorks, Inc.

FET_Ron=.004;    % FET 
FET_Snub= 1000;

L1=250e-9;       % Inductor
L1_R = 0.01;

Cout=1000e-6;    % Filter Cap
Cout_R = 0.0012;

Rload=1.0;       % Load Resistance


Vinput=12;       % Vin to converter

Fswitch=500e3;   % PWM switching frequency 
Comp_Tau=100e-9; % PWM Comparitor time constant

Fs_ADC=2.5e6;    % Sampling rate of discrete time controller