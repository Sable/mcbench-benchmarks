function F  = ...
    obj_actuator_param_pulse_FFT_method(x,frequency_20,frequency_100)
% Computes objective function for determination of basic parameters of
% the proportional valve actuator that match the requirted frequency
% response. The required and actual frequency responses are compared by
% the frequency at which phase shift in -90 deg takes place. The frequency 
% response of a nonlinear system is obtained by processing the pulse 
% transient characteristic with the FFT algorythm. 
% Copyright 2010 MathWorks, Inc.

% frequency_20   - frequency (Hz) at phase shift in -pi/2 at 20% input signal
% frequency_100  - frequency (Hz) at phase shift in -pi/2 at 100% input signal

model = 'actuator_freq_testrig_pulse_FFT_method';
load_system(model);

assignin('base','act_gain', x(1));
assignin('base','time_const', x(2));
assignin('base','act_saturation', x(3));

sim(model);

y_20 = yout(:,2);               % Pulse transient characteristic at 20% input
y_100 = yout(:,1);              % Pulse transient characteristic at 100% input
fs = 1000;                      % Sampling frequency
n = length(y_20);               % Window length = Transform length
y_20_fft = fft(y_20,n);         % Discrete Fourier Transform
y_100_fft = fft(y_100,n);       % Discrete Fourier Transform
f0 = (0:n/2-1)*(fs/n);          % Shifted frequency range, positive range
y_20_0 = fftshift(y_20_fft);    % Shifted DFT at 20% input
y_100_0 = fftshift(y_100_fft);  % Shifted DFT at 100% input
% Phase characteristic at 20% input for positive frequencies after unwrap
phase_20 = unwrap(angle(y_20_0(257:end))); 
% Phase characteristic at 100% input for positive frequencies after unwrap
phase_100 = unwrap(angle(y_100_0(257:end)));

% Computing frequency at 90 deg phase shift by interpolation of phase
% characteristics
frq_20 = interp1(phase_20,f0,-pi/2);
frq_100 = interp1(phase_100,f0,-pi/2);

% Objective function as a sum of squared differences between the specified
% and computed frequencies at phase shift angle in -pi/2
F = (frequency_20 - frq_20)^2 + (frequency_100 - frq_100)^2; 

end

% EOF