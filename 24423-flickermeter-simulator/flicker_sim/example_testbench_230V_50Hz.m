function example_testbench_230V_50Hz
% example_testbench_230V_50Hz - Flickermeter Simulator Performance Test
%
% Performs the performance tests according [1], section 5 and 6.1 for a
% 230V/ 50 Hz system.
%
% Requires MATLAB with Signal Procesing Toolbox installed or Octave.
% For more information refer to [2].
%===============================================================================
% References:
% [1] IEC 61000-4-15, Electromagnetic compatibility (EMC), Testing and
%     measurement techniques, Flickermeter, Edition 1.1, 2003-02
% [2] http://www.solcept.ch/en/embedded-tools/flickersim.html
%===============================================================================
%  (c) Copyright 2009 Solcept AG
%  Distributed under the Boost Software License, Version 1.0. (See accompanying
%  file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
%===============================================================================

clear variables

%% Configuration

F_LINE               =   50;  % line frequency in Hz
FS                   = 4000;  % sampling frequency in Hz
OBSERVATION_INTERVAL =  600;  % duration of simulation in sec
ERROR_LIMIT          =    5;  % maximum deviation of Pst in percent

IS_OCTAVE = exist('OCTAVE_VERSION') ~= 0;

%% Definition of test cases (according [1], section 5)

% voltage changes per minute
rate = [    1,     2,     7,    39,   110,  1620,  4000];
% magnitude of relative voltage changes in percent
d    = [2.724, 2.211, 1.459, 0.906, 0.725, 0.402, 2.400];
% sclaing factors to be tested 
scale_factors = [0.1, 0.5, 1, 2, 3, 5];

%% Run Tests
fprintf('\nStarting Flicker Model Test\n\n');

all_tests_passed = 1;
t = 0 : 1 / FS : OBSERVATION_INTERVAL;

for (s = scale_factors)
  fprintf('Testing with scaling factor: %.1f\n', s);
  for (idx = 1 : length(rate))
    f_mod = rate(idx) / (2 * 60);
    a_mod = s * d(idx) / 100;

    % create test signal (according [1], Annex B)
    u = sin(2 * pi * F_LINE * t) .* (1 + a_mod * 1 / 2 * sign(sin(2 * pi * f_mod * t)));

    P_st(idx) = flicker_sim(u, FS, F_LINE);
    err(idx) = (P_st(idx) / s - 1) * 100;
    
    fprintf('F_LINE = %2d Hz, r = %4d (%5.2f Hz), d = %6.3f %%:  P_st = %1.3f, err = %4.1f %%\n', ...
      F_LINE, rate(idx), f_mod, a_mod * 100, P_st(idx), err(idx))
    if (IS_OCTAVE)
      fflush(stdout);
    end
  end

  max_err = max(abs(err));
  if (max_err <= ERROR_LIMIT)
    fprintf('Test passed (max. error: %.1f %%)\n\n', max_err);
  else
    fprintf('Test failed (max. error: %.1f %%)\n\n', max_err);
    all_tests_passed = 0;
  end
end

if (all_tests_passed)
  fprintf('ALL TESTS PASSED\n');
end
