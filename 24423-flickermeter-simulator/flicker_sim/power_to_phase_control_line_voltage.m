function [u, fs, du, rel_pow] = power_to_phase_control_line_voltage(ctrl, p, fs, u_line, f_line, option)
% power_to_phase_control_line_voltage - Generate phase controlled line voltage signal
%
% [u, fs, du, rel_pow] = 
%     power_to_phase_control_line_voltage(ctrl, p, fs, u_line, f_line, option)
%
% Generate a line voltage signal using the given load power and load control
% signal vector. The output of this function can be used as input to
% flicker_sim.
% Note that only the resisitive part of the reference network (see [1]) is
% modeled, i.e. it is assumed that the power factor cos(phi) of the system to
% be examined is 1. If this is not the case, the function has to be
% adapted.
%
% Requires MATLAB with Signal Procesing Toolbox installed or Octave.
% For more information refer to [1].
%
% Inputs:
%   ctrl:    relative power (0..1) (vector)
%   p:       load power in Watts
%   fs:      sampling frequency of ctrl in Hz
%   u_line:  line voltage in Volts (effective value)
%   f_line:  line frequency in Hz
%   option:  'lin_angle' or 'lin_power'
%
% Outputs:
%   u:       line voltage in Volts (vector)
%   fs:      sampling frequency of u in Hz
%   du:      line voltage drop in Volts (vector)
%   rel_pow: instantaneous relative power (0..1) (vector)
%===============================================================================
% References:
% [1] IEC 61000-3-3, Limits – Limitation of voltage changes, voltage
%     fluctuations and flicker in public low-voltage supply systems, for
%     equipment with rated current =16 A per phase and not subject to
%     conditional connection, Edition 2.0, 2008-06
% [2] http://www.solcept.ch/en/embedded-tools/flickersim.html
%===============================================================================
%  (c) Copyright 2009 Solcept AG
%  Distributed under the Boost Software License, Version 1.0. (See accompanying
%  file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
%===============================================================================

%% Configuration

R_NET  = 0.4;   % impedance of reference network in Ohms (resistive part only)
FS_OUT = 2000;  % output sampling frequency

LEVEL_TO_ANGLE_TAB = [...
  180, 159, 154, 150, 146, 144, 141, 139, 137, 135, 133, 132, 130, 129, 127, 126, 124, 123, 122, 121, ...
  119, 118, 117, 116, 115, 114, 113, 112, 111, 110, 109, 108, 107, 106, 105, 104, 103, 102, 101, 100, ...
   99,  98,  97,  96,  95,  95,  94,  93,  92,  91,  90,  89,  88,  87,  86,  85,  85,  84,  83,  82, ...
   81,  80,  79,  78,  77,  76,  75,  74,  73,  72,  71,  70,  69,  68,  67,  66,  65,  64,  63,  62, ...
   61,  59,  58,  57,  56,  54,  53,  51,  50,  48,  47,  45,  43,  41,  39,  36,  34,  30,  26,  21, ...
    0  ] / 180 * pi;

%% Check inputs

if (nargin ~= 6)
  error('Invalid number of arguments');
end
if (~isvector(ctrl))
  error('Input argument "ctrl" must be a vector');
end
if ((max(ctrl) > 1) || (min(ctrl) < 0))
  error('Input argument "ctrl" must be a within 0..1');
end
if (~isscalar(p))
  error('Input argument "p" must be a scalar');
end
if (~isscalar(fs))
  error('Input argument "fs" must be a scalar');
end
if (~isscalar(u_line))
  error('Input argument "u_line" must be a scalar');
end
if (~isscalar(f_line))
  error('Iinput argument "f_line" must be a scalar');
end
if (~ischar(option))
  error('Input argument "option" must be a string');
end

%% Computations

% upsample power vector (do not use interpolation but duplicate samples)
upsample_factor = ceil(FS_OUT / fs);
ctrl = repmat(ctrl(:)', upsample_factor, 1);
ctrl = ctrl(:)';
fs = upsample_factor * fs;

t = [0 : length(ctrl) - 1] / fs;
ph = 2 * pi * f_line * t;
ph = mod(ph, 2 * pi);

if (strcmp(option, 'lin_angle'))
  ph_limit = pi * (1 - ctrl);
end
if (strcmp(option, 'lin_power'))
  ph_limit = LEVEL_TO_ANGLE_TAB(round(ctrl * 100) + 1);
end
rel_pow = 1 - 1 / pi * ph_limit + 1 / (2 *pi) * sin(2 * ph_limit);

gate_1 = ph > ph_limit;
gate_2 = (ph < pi) | (ph > pi + ph_limit);

% compute voltage drop over network impedance
du = R_NET * p / u_line;
 
% generate line signal
u = sin(ph) .* (u_line - du .* gate_1 .* gate_2);
du = sin(ph) .* (-du .* gate_1 .* gate_2);
