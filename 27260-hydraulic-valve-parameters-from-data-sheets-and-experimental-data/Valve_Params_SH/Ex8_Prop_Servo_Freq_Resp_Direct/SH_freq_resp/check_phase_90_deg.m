function F  = ...
    check_phase_90_deg(x, amplitude_40, frequency_40, amplitude_100,...
    frequency_100)
% The frequency responses of a nonlinear system are obtained by using.
% frestimate from Simulink Control Design to estimate the frequency
% response.  The difference of the phase from 90 degrees is reported to the
% MATLAB Command window.
% Copyright 2010 MathWorks, Inc.

model = 'actuator_freq_resp';
load_system(model);

assignin('base','act_gain', x(1));
assignin('base','time_const', x(2));
assignin('base','act_saturation', x(3));

% Computing phase angle at current values of variable parameters
ios = getlinio(model);
in = frest.Sinestream(...
    'Frequency',[frequency_40, frequency_100], ...
    'Amplitude', [amplitude_40, amplitude_100], ...
    'SimulationOrder', 'Sequential', ... %Set to OneAtATime to restart simulation for each frequency
    'FreqUnits', 'Hz');

sys = frestimate(model,ios,in);
R = sys.ResponseData(:);
Lag = angle(R)/pi*180;
phase_100 = Lag(1);
phase_40 = Lag(2);
error_40 = (phase_40 + 90)/90 * 100;
error_100 = (phase_100 +90)/90 * 100;

disp(['******************************************************************']);
disp(['     System Characteristics after Direct Measurement at Obtained Parameters']);
disp(['     Phase shift at ',num2str(frequency_40),'Hz',' and 40% input:']);
disp(['Target:  ',' -90 deg', ...
    '  Found:  ',num2str(phase_40),' deg', ...
    '   Error :   ',num2str(error_40),'%']);
disp(['     Phase shift at ',num2str(frequency_100),'Hz',' and 100% input']);
disp(['Target:  ',' -90 deg', ...
    '  Found:   ',num2str(phase_100),' deg', ...
    '   Error:   ',num2str(error_100),'%']);
disp(['******************************************************************']);

end
