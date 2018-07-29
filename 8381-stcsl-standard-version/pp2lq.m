function [param]=pp2chp(input)
% [param]=pp2chp(input)
% LQ controller for 2nd order processes.
% This function computes parameters of the controller (r0, r1, q0, q1, p0, p1).
% The dynamic behavoiour of the closed-loop is defined by LQ criterion
% Output of the controller is calculated follows:
%
%            r0 + r1*z^-1               q0 + q1*z^-1              
% U(z^-1) = -------------- * W(z^-1) - -------------- * Y(z^-1)
%            p0 + p1*z^-1               p0 + p1*z^-1
%
% Transfer function of the controlled system is:
%
%               b1*z^-1 + b2*z^-2
% Gs(z^-1) = -----------------------
%             1 + a1*z^-1 + a2*z^-2
%
% Input: 
%   input(1:4) ... [a1 b1 a2 b2]
%   input(5) ... type of reference signal (1-step, 2-ramp, 3-sin)
%   input(6) ... frequency [Hz] (used if reference signal is sin wave)
%   input(7) ... sample time (used if reference signal is sin wave)
%   input(8) ... penalisation of u (constant fi in LQ criterion)
% Output: param ... controller parameters  [r0; r1; q0; q1; p0; p1];

a1 = input(1);
b1 = input(2);
a2 = input(3);
b2 = input(4);
rs_type = input(5);
rs_freq = input(6);
T0 = input(7);
fi = input(8);

% LQ: AP+BQ = D where D determined by spectral factorization
% A(z^-1)*fi*A(z) + B(Z^-1)*B(z) = D(z^-1)*delta*D(z)
%          M(z^-1)*M(z)          = D(z^-1)*delta*D(z)
m0 = fi*(1+a1^2+a2^2) + b1^2 + b2^2;
m1 = fi*a1*(1+a2) + b1*b2;
m2 = fi*a2;

la = m0/2 - m2 + sqrt( (m0/2+m2)^2 - m1^2 );
delta = (la + sqrt(la^2-4*m2^2)) / 2;
d2 = m2 / delta;
d1 = m1 / (delta+m2);
d0 = 1;
d3 = 0;

% FBFW controller: Y=BR/(AP+BQ)*W
% conditions: 1) AP+BQ=D
%             2) BR+FS=D  where W=H/F and S is any polynomial
% 1st condition:
%  A =  1 + a1*z^-1 + a2*z^-2   B =      b1*z^-1 + b2*z^-2
%  P = p0 + p1*z^-1             Q = q0 + q1*z^-1
% system of linear equations:
% [ 1  0   0  0]   [p0]   [d0]
% [a1  1  b1  0]   [p1]   [d1]
% [a2 a1  b2 b1] * [q0] = [d2]
% [ 0  a2  0 b2]   [q1]   [d3]
p0 = d0;
p1 = (d0*b2^2*a1-d0*b2*b1*a2-b2^2*d1+b1*b2*d2-b1^2*d3)/(-b2^2+a1*b1*b2-a2*b1^2);
q0 = -(d0*a1^2*b2-d0*a1*b1*a2-d0*a2*b2-d1*a1*b2+d1*b1*a2+b2*d2-b1*d3)/(-b2^2+a1*b1*b2-a2*b1^2);
q1 = -(d0*a2*a1*b2-d0*a2^2*b1-a2*b2*d1+b1*a2*d2+d3*b2-d3*b1*a1)/(-b2^2+a1*b1*b2-a2*b1^2);

% 2nd condition:
switch (rs_type)
case 1,     %step:
    % B = b1*z^-1 + b2*z^-2   F =  1 - z^-1
    % R = r0                  S = s0 + s1*z^-1 + s2*z^-2
    % [ 0    1    0   0]   [r0]   [d0]
    % [b1   -1    1   0]   [s0]   [d1]
    % [b2    0   -1   1] * [s1] = [d2]
    % [ 0    0    0  -1]   [s2]   [d3]
    r0 = (d0+d1+d2+d3)/(b1+b2);
    r1 = 0;
case 2,     %ramp
    % B =      b1*z^-1 + b2*z^-2   F =  1 -  2*z^-1 + z^-2
    % R = r0 + r1*z^-1             S = s0 + s1*z^-1
    % [ 0   0   1   0]   [r0]   [d0]
    % [b1   0  -2   1]   [r1]   [d1]
    % [b2  b1   1  -2] * [s0] = [d2]
    % [ 0  b2   0   1]   [s1]   [d3]
    r0 = (2*d0*b1+3*d0*b2+d1*b1+2*d1*b2+b2*d2-b1*d3)/(b1+b2)^2;
    r1 = -(d0*b1+2*d0*b2+d1*b2-b1*d2-2*b1*d3-d3*b2)/(b1+b2)^2;
case 3,     %sin(om*t/T0)
    om = 2*pi*rs_freq*T0;
    % B =      b1*z^-1 + b2*z^-2   F = 1 -  2*cos(om)*z^-1 + z^-2
    % R = r0 + r1*z^-1             S = s0 + s1*z^-1
    % [ 0   0           1           0]   [r0]   [d0]
    % [b1   0  -2*cos(om)           1]   [r1]   [d1]
    % [b2  b1           1  -2*cos(om)] * [s0] = [d2]
    % [ 0  b2           0           1]   [s1]   [d3]
    r0 = (2*d0*b1*cos(om)+2*d0*b2*cos(2*om)+d0*b2+d1*b1+2*d1*b2*cos(om)+b2*d2-b1*d3)/(b1^2+2*b1*b2*cos(om)+b2^2);
    r1 = (-d0*b1-2*d0*b2*cos(om)-b2*d1+b1*d2+2*d3*b1*cos(om)+d3*b2)/(b1^2+2*b1*b2*cos(om)+b2^2);
end;

param=[r0; r1; q0; q1; p0; p1];
