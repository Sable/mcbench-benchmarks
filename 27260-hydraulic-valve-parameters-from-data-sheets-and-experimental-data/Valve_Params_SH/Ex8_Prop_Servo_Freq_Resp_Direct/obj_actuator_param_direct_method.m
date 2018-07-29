function F  = obj_actuator_param_direct_method(x, frequency_20,frequency_100)
% Computes objective function for determination of basic parameters of
% the proportional valve actuator that match the requirted frequency
% response. The required and actual frequency responses are compared by
% the frequency at which phase shift in -90 deg takes place. The frequency 
% response of a nonlinear system is obtained by processing the pulse 
% transient characteristic with the FFT algorythm. 
% Copyright 2010 MathWorks, Inc.

% frequency_20   - frequency (Hz) at phase shift in -pi/2 at 20% input signal
% frequency_100  - frequency (Hz) at phase shift in -pi/2 at 100% input signal


model = 'actuator_freq_testrig_direct_method';
load_system(model);

assignin('base','act_gain', x(1));
assignin('base','time_const', x(2));
assignin('base','act_saturation', x(3));

sim(model);

% Computing phase angle at current values of variable parameters

% Phase angle at specified frequency and input signal in 100%
phase_100 = phase_computation(yout(:,[1,2]), tout, frequency_100,4);
% Phase angle at specified frequency and input signal in 20%
phase_20 = phase_computation(yout(:,[3,4]), tout, frequency_20,6);

    
F = (phase_100 + 90)^2 + (phase_20 + 90)^2; 

end

function [phase] = phase_computation(yout, tout, freq_at_90,N)
% Function computes phase angle by processing sinusoids stored in yout

% yout(:,1)- input; yout(:,2) - output
% tout - simulation step time
% freq_at_90 - frequency at which phase angle equals -90 deg
% N - number of periods to settle the transients

% Measurement time. Time in N periods is assumed to be enough to settle
% down the transients. The input signal at this time is equal zero

t_s = 1/freq_at_90 * N;             % Measurement start time
t_end = t_s + 1/freq_at_90;         % Measurement end time
    
% yout index at measurement time
for j = 1:length(tout)- 1
    if t_s >= tout(j) && t_s < tout(j+1)
        k_start = j;                % First array index after start time
        t_corr_1 = tout(j) - t_s;    % Correction due to discretization
    end
    if t_end >= tout(j) && t_end < tout(j+1)
        k_end = j-1;                  % Last array index within period
    end
end
% Computing time the output signal crosses zero
for j = k_start : k_end
    if yout(j,2) <= 0 && yout(j+1,2) > 0
        t_tab_cross = tout(j);   % First value in the table after crossing
        % Approximating real crossing time
        t_corr_2 = -yout(j,2) / (yout(j+1,2) - yout(j,2)) * ...
            (tout(j+1) - tout(j));
    end
end
% Crossing time for the output signal
t_cross = t_tab_cross + t_corr_1 + t_corr_2;
% Computing phase angle
phase = -(t_cross - t_s) / (1/freq_at_90) * 360;

end



% EOF