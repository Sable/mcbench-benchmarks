function fx = hohmfunc (x)

% inclination objective function

% required by hohmann.m

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global hn1 hn2 hn3 dinc

dinc1 = x;

hn = hn2 * hn2;

a = hn1 * sin(dinc1) / sqrt(1.0 + hn1 * hn1 - 2.0 * hn1 * cos(dinc1));
   
b = hn * hn3 * (sin(dinc) * cos(dinc1) - cos(dinc) * sin(dinc1));
   
% calculate objective function value

fx = a - b / sqrt(hn * hn3 * hn3 + hn - 2.0 * hn * hn3 * cos(dinc - dinc1));



