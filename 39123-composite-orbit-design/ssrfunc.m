function y = ssrfunc(x)

% sun-synchronous repeating ground track
% orbit objective function

% required by ssrepeat.m

% input

%  x = array of current dependent variables

% output

%  y = function value array evaluated at x

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global j2 mu req omega xldot

global ecc xqp

y = zeros(2, 1);

% "unload" current solution

sma = x(1);
inc = x(2);

% determine current values of nonlinear system

mm = sqrt(mu / sma ^ 3);

slr = sma * (1.0 - ecc * ecc);

cinc = cos(inc);

% compute perturbations

raandot = -1.5 * j2 * mm * (req / slr) ^ 2 * cinc;

apdot = 0.75 * j2 * mm * (req / slr) ^ 2 * (5.0 * cinc ^ 2 - 1);

madot = mm + 0.75 * j2 * mm * (req / sma) ^ 2 * (3.0 * cinc ^ 2 - 1) ...
    / (1.0 - ecc * ecc) ^ 1.5;

% sun-synchronous inclination equation

y(1) = cinc + 2.0 * xldot * sma ^ 3.5 * (1 - ecc * ecc) ^ 2 ...
    / (3 * j2 * req * req * sqrt(mu));

% repeating groundtrack equation

y(2) = (1.0 / xqp) / (omega - raandot) - (1.0 / (apdot + madot));

