% Script file to calculate frequency response characteristic
% Copyright 2010 MathWorks, Inc.

% This script file computes frequency response characteristic by applying
% Fast Fourier Transform to the pulse transient response of linear system. 
% To assess accuracy of computation, the obtained phase characteristic is 
% compared with its analytical counterpart and the error as a 
% function of frequency is plotted.

model = 'pulse_response_linear_test_rig';
load_system(model);

assignin('base','gain', 500);
assignin('base','time_const', 0.01);

sim(model);

y = yout(:,1);                  % Pulse transient characteristic
fs = 1000;                      % Sampling frequency
n = length(y);                  % Window length = Transform length
y_fft = fft(y,n);               % Discrete Fourier Transform
f0 = (0:n/2-1)*(fs/n);          % Shifted frequency range, positive range
y_0 = fftshift(y_fft);          % Shifted DFT at 20% input

% Phase characteristic for positive frequencies after unwrap
phase = unwrap(angle(y_0(513:end)));

% Computing analytical phase characteristic for the second order lag
w_n = sqrt(gain/time_const)/2/pi;       % Undamped frequency, Hz
delta = sqrt(1/(time_const*gain))/2;    % Damping coefficient

for j = 1:length(phase);
       
    if f0(j) <= w_n
        phase_an(j) = - atan(2*delta * f0(j)/w_n/(1-f0(j)^2/w_n^2));
    else 
        phase_an(j) = - pi - atan(2*delta * f0(j)/w_n/(1-f0(j)^2/w_n^2));
    end
   
end


figure(1)
semilogx(f0,phase*180/pi,'LineWidth',3,'LineStyle','--')
hold on
semilogx(f0,phase_an*180/pi,'r','LineWidth',2), grid on;
hold off
title('Frequency Characteristic Comparison','FontSize',16,'FontWeight','Bold');
xlabel('Frequency, Hz','FontSize',14);
ylabel('Phase angle (degrees)','FontSize',14);
legend({'Approximate' 'Analytical'},'FontSize',12);

figure(2)
semilogx(f0,(phase-phase_an')*180/pi,'LineWidth',3,'Color','k'), grid on
title('Error of Frequency Characteristic Approximation','FontSize',16,'FontWeight','Bold');
xlabel('Frequency, Hz','FontSize',14);
ylabel('Phase angle error (degrees)','FontSize',14);

% Computing frequency at 90 deg phase shift by interpolation of phase
% characteristics
frq_90 = interp1(phase,f0,-pi/2);       % [Hz]
% Computing frequency at 90 deg phase shift by applying analytical formula
frq_90_lin = sqrt(gain/time_const) /2 /pi;



% EOF