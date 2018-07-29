function example_heater
% example_heater - Example for Flickermeter Simulator
%
% In this example a system with 4 heating elements is examined. The control
% signals of these heating elements have been recorded with a digital
% storage oscilloscope. The signals are loaded from .mat files and are used
% to reconstruct the corresponding impaired line voltage signal, which is then
% used as input to the flickermeter simulator.
%
% Requires MATLAB with Signal Procesing Toolbox installed or Octave.
% For more information refer to [1].
%===============================================================================
% References:
% [1] http://www.solcept.ch/en/embedded-tools/flickersim.html
%===============================================================================
%  (c) Copyright 2009 Solcept AG
%  Distributed under the Boost Software License, Version 1.0. (See accompanying
%  file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
%===============================================================================

clear variables

%% Configuration

U_LINE = 230;  % line voltage in Volts
F_LINE = 50;   % line frequency in Hz

%% Load stimuli

load('heater_1.mat');
power_1 = is_on * pow;
load('heater_2.mat');
power_2 = is_on * pow;
load('heater_3.mat');
power_3 = is_on * pow;
load('heater_4.mat');
power_4 = is_on * pow;

p = power_1 + power_2 + power_3 + power_4;

%% Computations

% convert power switching sequence to impaired line voltage signal
% (upsamples the signal to the required sampling frequency)
[u, fs] = power_to_line_voltage(p, fs, U_LINE, F_LINE);

% run flicker simulation
Pst = flicker_sim(u, fs, F_LINE)

%% Plots

figure
clf
t = [0 : length(power_1) - 1] / fs;
subplot(4, 1, 1)
plot(t, power_1, 'b', 'linewidth', 2)
grid on
title(sprintf('Example: System with 4 Heating Elements\nPst = %.2f', Pst))
xlabel('Time [sec]')
ylabel('Power [W]')
subplot(4, 1, 2)
plot(t, power_2, 'r', 'linewidth', 2)
grid on
xlabel('Time [sec]')
ylabel('Power [W]')
subplot(4, 1, 3)
plot(t, power_3, 'g', 'linewidth', 2)
grid on
xlabel('Time [sec]')
ylabel('Power [W]')
subplot(4, 1, 4)
plot(t, power_4, 'k', 'linewidth', 2)
grid on
xlabel('Time [sec]')
ylabel('Power [W]')
