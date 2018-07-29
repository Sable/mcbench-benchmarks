function [u, fs, du] = power_to_line_voltage(p, fs, u_line, f_line)
% power_to_line_voltage - Generate line voltage signal from power samples
%
% [u, fs] = power_to_line_voltage(p, fs, u_line, f_line)
%
% Generate a line voltage signal using the given load power vector. The
% output of this function can be used as input to flicker_sim.
% Note that only the resisitive part of the reference network (see [1]) is
% modeled, i.e. it is assumed that the power factor cos(phi) of the system to
% be examined is 1. If this is not the case, the function has to be
% adapted.
%
% Requires MATLAB with Signal Procesing Toolbox installed or Octave.
% For more information refer to [2].
%
% Inputs:
%   p:       load power in Watts (vector)
%   fs:      sampling frequency of p in Hz
%   u_line:  line voltage in Volts (effective value)
%   f_line:  line frequency in Hz
%
% Outputs:
%   u:       line voltage in Volts (vector)
%   fs:      sampling frequency of u in Hz
%   du:      line voltage drop in Volts (vector)
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

%% Check inputs

if (nargin ~= 4)
  error('Invalid number of arguments');
end
if (~isvector(p))
  error('Input argument "p" must be a vector');
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

%% Computations

% upsample power vector (do not use interpolation but duplicate samples)
upsample_factor = ceil(FS_OUT / fs);
p = repmat(p(:)', upsample_factor, 1);
p = p(:)';
fs = upsample_factor * fs;

% compute voltage drop over network impedance
du = R_NET * p / u_line;

% generate line signal
t = [0 : length(du) - 1] / fs;
u = (u_line - du) .* sqrt(2) .* sin(2 * pi * f_line * t);
du = -du .* sqrt(2) .* sin(2 * pi * f_line * t);
