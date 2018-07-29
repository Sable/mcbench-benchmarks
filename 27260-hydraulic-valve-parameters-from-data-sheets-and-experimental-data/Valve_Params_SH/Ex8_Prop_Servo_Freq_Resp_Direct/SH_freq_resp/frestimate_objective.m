% Script to test actuator at current parameter values using frestimate
% Copyright 2010 MathWorks, Inc.

mdl = 'actuator_freq_resp';

amplitude_100 = 0.2;
frequency_100 = 43;
amplitude_40  = amplitude_100*0.4;
frequency_40  = 55;      


ios = getlinio(mdl);
in_2pts = frest.Sinestream(...
   'Frequency',[20, 20.1, 43, 57], ...
   'Amplitude', [amplitude_100, amplitude_40, amplitude_100, amplitude_40], ...
   'SimulationOrder', 'Sequential', ... %Set to OneAtATime to restart simuation for each frequency
   'FreqUnits', 'Hz');

sys = frestimate(mdl,ios,in_2pts);
R = sys.ResponseData(:);
Lag = angle(R)/pi*180;
%disp('');
%disp(['Desired Phase: -59 -50 -90 -90']);
%disp(['Actual Phase:  ' sprintf('%3.0f %3.0f %3.0f %3.0f',Lag(1),Lag(2),Lag(3),Lag(4))]);

   