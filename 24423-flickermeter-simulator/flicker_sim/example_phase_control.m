function example_phase_control
% example_phase_control - Example for Flickermeter Simulator
%
% In this example the impact of different load switching methods is examined.
% The impaired line voltage signal is generated for the following
% scenarios:
% - hard swichting
% - soft switching using phase control with linear angle sweep
% - soft switching using phase control with non-linear angle sweep
% In all cases the same load is used and periodically switched on and off.
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
FS    = 1000;  % sampling frequency in Hz
POWER = 1000;  % load in W

RAMP_LENGTH        = 1;  % in sec
SWITCHING_INTERVAL = 3;  % in sec
NUMOF_CYCLES       = 10; % number of swicthing cycles to simulate

CONST_LENGTH = SWITCHING_INTERVAL - RAMP_LENGTH;

%% Preparations

% one switching cycle consists of an OFF level phase, a rising ramp, an ON
% level phase and a falling ramp
cycle_ctrl = [...
  zeros(1, CONST_LENGTH * FS), ...
  linspace(0, 1, RAMP_LENGTH * FS), ...
  ones(1, CONST_LENGTH * FS), ...
  linspace(1, 0, RAMP_LENGTH * FS)];
ctrl = repmat(cycle_ctrl, 1, NUMOF_CYCLES);

figure(1)
clf

%% Hard switching

p = (ctrl > 0.5) * POWER;
[u, fs, du] = power_to_line_voltage(p, FS, U_LINE, F_LINE);

Pst = flicker_sim(u, fs, F_LINE);

subplot(3, 1, 1);
t = [0 : length(du) - 1] / fs;
plot(t, du, 'b', 'linewidth', 1)
hold on
t = [0 : length(p) - 1] / FS;
plot(t, double(p > 0), 'r', 'linewidth', 3)
set(gca, 'xlim', [0, 2 * SWITCHING_INTERVAL]);
grid on
title(sprintf('Example: No Power Pulse Shaping (Hard Switching)\nPst = %.2f', Pst))
xlabel('Time [sec]')
ylabel('Red: Power Level, Blue: Voltage drop [V]')

%% Phase control (linear angle mode)

[u, fs, du, rel_pow] = power_to_phase_control_line_voltage(ctrl, POWER, FS, U_LINE, F_LINE, 'lin_angle');

Pst = flicker_sim(u, fs, F_LINE);

subplot(3, 1, 2);
t = [0 : length(du) - 1] / fs;
plot(t, du, 'b', 'linewidth', 1)
hold on
plot(t, rel_pow, 'r', 'linewidth', 3)
grid on
set(gca, 'xlim', [0, 2 * SWITCHING_INTERVAL]);
title(sprintf('Example: Power Pulse Shaping using Phase Control (Linear Angle)\nPst = %.2f', Pst))
xlabel('Time [sec]')
ylabel('Red: Power Level, Blue: Voltage drop [V]')

%% Phase control (linear power mode)

[u, fs, du, rel_pow] = power_to_phase_control_line_voltage(ctrl, POWER, FS, U_LINE, F_LINE, 'lin_power');

Pst = flicker_sim(u, fs, F_LINE);

subplot(3, 1, 3);
t = [0 : length(du) - 1] / fs;
plot(t, du, 'b', 'linewidth', 1)
hold on
plot(t, rel_pow, 'r', 'linewidth', 3)
grid on
set(gca, 'xlim', [0, 2 * SWITCHING_INTERVAL]);
title(sprintf('Example: Power Pulse Shaping using Phase Control (Linear Power)\nPst = %.2f', Pst))
xlabel('Time [sec]')
ylabel('Red: Power Level, Blue: Voltage drop [V]')
