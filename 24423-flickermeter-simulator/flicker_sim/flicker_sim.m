function [P_st, s] = flicker_sim(u, fs, f_line)
% flicker_sim - Flickermeter Simulator according IEC 61000-4-15
%
% [P_st, s, cpf] = flicker_sim(u, fs, f_line)
%
% This function implements a flickermeter according [1] and [2]. 
% Requires MATLAB with Signal Procesing Toolbox installed or Octave.
% For more information refer to [3].
%
% Inputs:
%   u:      vector of voltage samples
%   fs:     sampling frequency of u in Hz (should be >= 2000)
%   f_line: line frequency in Hz (must be 50 or 60 Hz)
%
% Outputs:
%   P_st:   short term flicker
%   s:      instantaneous flicker severity
%===============================================================================
% References:
% [1] IEC 61000-4-15, Electromagnetic compatibility (EMC), Testing and
%     measurement techniques, Flickermeter, Edition 1.1, 2003-02
% [2] Wilhelm Mombauer: "Messung von Spannungsschwankungen und Flickern mit
%     dem IEC-Flickermeter", ISBN 3-8007-2525-8, VDE-Verlag 
% [3] http://www.solcept.ch/en/embedded-tools/flickersim.html
%===============================================================================
%  (c) Copyright 2009 Solcept AG
%  Distributed under the Boost Software License, Version 1.0. (See accompanying
%  file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
%===============================================================================

%% Configuration

SHOW_TIME_SIGNALS           = 0; % enable to plot internal signals of flickermeter
SHOW_CUMULATIVE_PROBABILITY = 0; % enable to plot the statistical evaluation of the instantaneous flicker severity
SHOW_FILTER_RESPONSES       = 0; % enable to plot the filter responses of all internal filter stages (for model verification)

IS_OCTAVE = exist('OCTAVE_VERSION') ~= 0;

%% Check inputs

if (nargin ~= 3)
  error('Invalid number of arguments');
end

if (~isvector(u))
  error('First input argument must be a vector');
end
% convert to row vector if needed
u = reshape(u, 1, length(u));

if ((f_line ~= 50) && (f_line ~= 60))
  error('Line frequency must be 50 or 60 Hz');
end

if (fs < 2000)
  warning('Sampling frequency should be >= 2000 Hz');
end

%% Block 1: Input voltage adaptor

% remove DC component
u = u - mean(u);

% normalize input (scale with peak-amplitude value)
u_rms = sqrt(mean(u.^2));
u = u / (u_rms * sqrt(2));

%% Block 2: Quadratic demodulator

u_0 = u .^ 2;

%% Block 3: Bandpass and weighting filter

% bandpass filter

HIGHPASS_ORDER  = 1;
HIGHPASS_CUTOFF = 0.05;

LOWPASS_ORDER = 6;
if (f_line == 50)
  LOWPASS_CUTOFF = 35;
end
if (f_line == 60)
  LOWPASS_CUTOFF = 42;
end

% subtract DC component to limit filter transients at start of simulation
u_0_ac = u_0 - mean(u_0);

[b_hp, a_hp] = butter(HIGHPASS_ORDER, HIGHPASS_CUTOFF / (fs / 2), 'high');
u_hp = filter(b_hp, a_hp, u_0_ac);

% smooth start of signal to avoid filter transient at start of simulation
smooth_limit = min(round(fs / 10), length(u_hp));
u_hp(1 : smooth_limit) = u_hp(1 : smooth_limit) .* linspace(0, 1, smooth_limit);

[b_bw, a_bw] = butter(LOWPASS_ORDER, LOWPASS_CUTOFF / (fs / 2), 'low');
u_bw = filter(b_bw, a_bw, u_hp);

% weighting filter

if (f_line == 50)
  K = 1.74802;
  LAMBDA = 2 * pi * 4.05981;
  OMEGA1 = 2 * pi * 9.15494;
  OMEGA2 = 2 * pi * 2.27979;
  OMEGA3 = 2 * pi * 1.22535;
  OMEGA4 = 2 * pi * 21.9;
end
if (f_line == 60)
  K = 1.6357;
  LAMBDA = 2 * pi * 4.167375;
  OMEGA1 = 2 * pi * 9.077169;
  OMEGA2 = 2 * pi * 2.939902;
  OMEGA3 = 2 * pi * 1.394468;
  OMEGA4 = 2 * pi * 17.31512;
end

num1 = [K * OMEGA1, 0];
den1 = [1, 2 * LAMBDA, OMEGA1.^2];
num2 = [1 / OMEGA2, 1];
den2 = [1 / (OMEGA3 * OMEGA4), 1 / OMEGA3 + 1 / OMEGA4, 1];
if (IS_OCTAVE)
  [b_w, a_w] = bilinear(conv(num1, num2), conv(den1, den2), 1 / fs);
else
  [b_w, a_w] = bilinear(conv(num1, num2), conv(den1, den2), fs);
end

u_w = filter(b_w, a_w, u_bw);

%% Block 4: Squaring and smoothing

LOWPASS_2_ORDER  = 1;
LOWPASS_2_CUTOFF = 1 / (2 * pi * 300e-3);  % time constant 300 msec
SCALING_FACTOR   = 1238400;  % scaling of output to perceptibility scale  (according [2])

u_q = u_w .^ 2;

[b_lp, a_lp] = butter(LOWPASS_2_ORDER, LOWPASS_2_CUTOFF / (fs / 2), 'low');
s = SCALING_FACTOR * filter(b_lp, a_lp, u_q);

%% Block 5: Statistical evaluation

NUMOF_CLASSES = 10000;

[bin_cnt, cpf.magnitude] = hist(s, NUMOF_CLASSES);
cpf.cum_probability = 100 * (1 - cumsum(bin_cnt) / sum(bin_cnt));

p_50s = mean([get_percentile(cpf, 30), get_percentile(cpf, 50), get_percentile(cpf, 80)]);
p_10s = mean([get_percentile(cpf, 6), get_percentile(cpf, 8), ...
  get_percentile(cpf, 10), get_percentile(cpf, 13), get_percentile(cpf, 17)]);
p_3s = mean([get_percentile(cpf, 2.2), get_percentile(cpf, 3), get_percentile(cpf, 4)]);
p_1s = mean([get_percentile(cpf, 0.7), get_percentile(cpf, 1), get_percentile(cpf, 1.5)]);
p_0_1 = get_percentile(cpf, 0.1);

P_st = sqrt(0.0314 * p_0_1 + 0.0525 * p_1s + 0.0657 * p_3s + ...
  0.28 * p_10s + 0.08 * p_50s);

%% Optional graphical output

% time signals
if (SHOW_TIME_SIGNALS)
  t = 0 : 1 / fs : (length(u) - 1) / fs;
  filter_len = round(10 / 1000 * fs);
  u_0_m = filter(ones(1, filter_len) / filter_len * 2, 1, u_0);

  figure
  clf
  subplot(2, 2, 1)
  hold on
  plot(t, u, 'b');
  plot(t, u_0, 'm');
  plot(t, u_hp, 'r');
  plot(t, u_0_m, 'c');
  hold off
  legend('u', 'u_0', 'u_h_p');
  grid on
  subplot(2, 2, 2)
  hold on
  plot(t, u_bw, 'b');
  plot(t, u_w, 'm');
  legend('u_b_w', 'u_w');
  hold off
  grid on
  subplot(2, 2, 3)
  plot(t, u_q, 'b');
  legend('u_q');
  grid on
  subplot(2, 2, 4)
  plot(t, s, 'b');
  legend('s');
  grid on
end

% cumulative probability function
if (SHOW_CUMULATIVE_PROBABILITY)
  figure
  clf
  plot(cpf.magnitude, cpf.cum_probability);
  grid
end

% frequency responses of filters
if (SHOW_FILTER_RESPONSES)
  [h_hp, f] = freqz(b_hp, a_hp, 4096, fs);
  [h_bw, f] = freqz(b_bw, a_bw, 4096, fs);
  [h_w, f] = freqz(b_w, a_w, 4096, fs);
  [h_lp, f] = freqz(b_lp, a_lp, 4096, fs);

  figure
  clf
  subplot(2, 1, 1)
  hold on
  plot(f, abs(h_hp), 'b')
  plot(f, abs(h_bw), 'r')
  plot(f, abs(h_w), 'g')
  plot(f, abs(h_lp), 'm')
  hold off
  grid
  axis([0, 35, 0, 1]);

  subplot(2, 1, 2)
  hold on
  plot(f, 180 / pi * unwrap(angle(h_hp)), 'b')
  plot(f, 180 / pi * unwrap(angle(h_bw)), 'r')
  plot(f, 180 / pi * unwrap(angle(h_w)), 'g')
  plot(f, 180 / pi * unwrap(angle(h_lp)), 'm')
  hold off
  grid
  axis([0, 35, -200, 300]);
end

end  % end of function flicker_sim


%% Subfunction: get_percentile
function val = get_percentile(cpf, limit)
  [dummy, idx] = min(abs(cpf.cum_probability - limit));
  val = cpf.magnitude(idx);
end
