%% Type S thermocouple characteristics over -50 to approx 1000 C  from NIST
% Dick Benson
% Copyright 2005-2013 The MathWorks, Inc.
% clear all 
% Correction polynonial from NIST
Pfwd=[ +2.71443176145e-021, -1.25068871393e-017, +2.55744251786e-014, -3.31465196389e-011, +3.22028823036e-008, -2.32477968689e-005, +1.25934289740e-002, +5.40313308631e+000, +0.00000000000e+000 ]*1e-3;
Temp = -50:2:200;  % evaluate polynomial over this temp range
Tc_mV = polyval(Pfwd,Temp);
plot(Temp,Tc_mV); xlabel('Temp in C'); ylabel('millivolts');

%% NIST inverse polynomial for correction
Pinv=[2.79786260 -2.34181944e1 8.23027880e1 -1.59085941e2 1.88821343e2 -1.52248592e2 1.02237430e2  -8.00504062e1 1.84949460e2  0];
Tc_comp = polyval(Pinv,Tc_mV);
plot(Temp,Tc_comp);xlabel('Temp in C'); ylabel('millivolts');


%% Find a new correction polynomial using basic fitting in MATLAB 
% THIS IS A MANUAL OPERATION !! 
% Temp  = a0 + a1*Tc_mV + a2*Tc_mV^2 + a3* Tc_mV^3 .....   
plot(Tc_mV,Temp);       % use basic fitting in plot and save to fit
                        % CHOOSE 9th order to be consistent with NIST
%%
Pinv_new=fit.coeff;
Tc_comp = polyval(Pinv_new,Tc_mV);
plot(Temp,Tc_comp);xlabel('Temp in C'); ylabel('Measured Temp');

%% plot error after correction 
plot(Temp,(Temp-Tc_comp)); xlabel('Temp in C'); ylabel('Error in C')
% save type_2_polynomials  Pinv Pinv_new Pfwd
