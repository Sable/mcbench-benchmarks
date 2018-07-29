function y = compfunc(x)

% composite orbit objective function

% required by composit.m

% input

%  x = array of current dependent variables

% output

%  y = function value array evaluated at x

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global j2 j3 mu req omega xldot argper xqp

y = zeros(3, 1);

% "unload" current orbital elements

sma = x(1);
ecc = x(2);
inc = x(3);

sp = sin(inc);

mm = sqrt(mu / sma ^ 3);

slr = sma * (1.0 - ecc * ecc);

cinc = cos(inc);

% compute perturbations

raandot = -1.5 * j2 * mm * (req / slr) ^ 2 * cinc;

apdot = 0.75 * j2 * mm * (req / slr) ^ 2 * (5.0 * cinc ^ 2 - 1);

madot = mm + 0.75 * j2 * mm * (req / sma) ^ 2 * (3.0 * cinc ^ 2 - 1) ...
    / (1.0 - ecc * ecc) ^ 1.5;

% sun-synchronous inclination equation

y(1) = cinc + 2 * xldot * sma ^ 3.5 * (1 - ecc * ecc) ^ 2 ...
    / (3.0 * j2 * req * req * sqrt(mu));

% repeating groundtrack equation

y(2) = (1.0 / xqp) / (omega - raandot) - (1.0 / (apdot + madot));

% frozen orbit equation

mm = sqrt(mu / sma ^ 3);

sp2 = sp * sp;

cp = cos(inc);
cp2 = cp * cp;

slr = sma * (1.0 - ecc * ecc);

tmp1 = 1.5 * j2 * req ^ 2 * mm * (2.0 - 2.5 * sp2) / (slr * slr);
tmp2 = -1.5 * j3 * req ^ 3 * sin(argper) * mm / (slr ^ 3 * ecc * sp);
tmp3 = (1.25 * sp2 - 1.0) * sp2 + ecc * ecc * (1.0 - (35.0 / 4.0) * sp2 * cp2);

y(3) = tmp1 + tmp2 * tmp3;
