function F  = obj_actuator_freq_resp_param(x,amplitude_40, frequency_40, amplitude_100, frequency_100)
% Computes objective function for determination of basic parameters of
% the proportional valve actuator that match the required frequency
% response. The frequency response of a nonlinear system is obtained by 
% using frestimate.  The required and actual frequency responses are
% compared. 
% Copyright 2010 MathWorks, Inc.

% Manufacturer's characterstic
%RefFR_100_Frq =     [7 10 20 30 40 43 50 54];
%RefFR_100_Phs = -1*[25 35 59 75 87 90 96 100];
%RefFR_40_Frq =     [7 10 20 30 40 50 57 70];
%RefFR_40_Phs = -1*[21 30 50 63 75 85 90 100];

model = 'actuator_freq_resp';
load_system(model);

assignin('base','act_gain', x(1));
assignin('base','time_const', x(2));
assignin('base','act_saturation', x(3));

% Computing phase angle at current values of variable parameters

% Determine inputs and outputs
ios = getlinio(model);

% Generate input at test frequencies
in100 = frest.Sinestream(...
   'Frequency',frequency_100, ...
   'Amplitude', amplitude_100*ones(size(frequency_100)), ...
   'SimulationOrder', 'Sequential', ... 
   'FreqUnits', 'Hz');

in40 = frest.Sinestream(...
   'Frequency',frequency_40, ...
   'Amplitude', amplitude_40*ones(size(frequency_40)), ...
   'SimulationOrder', 'Sequential', ... 
   'FreqUnits', 'Hz');

% Test model, determine phase
sys100 = frestimate(model,ios,in100);
R100 = sys100.ResponseData(:);
Lag = angle(R100)/pi*180; 
phase_100_20 = Lag(1); phase_100_43 = Lag(2);

% Test model, determine phase
sys40 = frestimate(model,ios,in40);
R40 = sys40.ResponseData(:);
Lag = angle(R40)/pi*180; 
phase_40_20 = Lag(1); phase_40_57 = Lag(2);

% Calculate difference from manufacturer's characteristic
F = (phase_100_20 + 59)^2 + (phase_100_43 + 90)^2 + ...
    (phase_40_20 + 50)^2 + (phase_40_57 + 90)^2; 

end

