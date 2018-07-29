function [param]=pp3chp(input)
% [param]=pp3chp(input)
% Pole placement controller for 3rd order processes.
% This function computes parameters of the controller (r0, r1, q0, q1, q2, p0, p1, p2).
% The dynamic behavoiour of the closed-loop is defined by coefficients of 
% characteristic polynomial D = d0 + d1*z^-1 + d2*z^-2 + d3*z^-3.
% Output of the controller is calculated follows:
%
%            r0 + r1*z^-1                         q0 + q1*z^-1 + q2*z^-2
% U(z^-1) = ------------------------ * W(z^-1) - ------------------------ * Y(z^-1)
%            p0 + p1*z^-1 + p2*z^-2               p0 + p1*z^-1 + p2*z^-2
%
% Transfer function of the controlled system is:
%
%               b1*z^-1 + b2*z^-2 + b3*z^-3
% Gs(z^-1) = ---------------------------------
%             1 + a1*z^-1 + a2*z^-2 + a3*z^-3
%
% Input: 
%   input(1:6) ... [a1 b1 a2 b2 a3 b3]
%   input(7) ... type of reference signal (1-step, 2-ramp, 3-sin)
%   input(8) ... frequency [Hz] (used if reference signal is sin wave)
%   input(9) ... sample time (used if reference signal is sin wave)
%   input(10:15) ... [d0 d1 d2 d3] coefficients of characteristic polynomial
%                    d0 is required, d1, d2 and d3 are voluntary 
% Output: param ... controller parameters  [r0; r1; q0; q1; q2; p0; p1; p2];

a1 = input(1);
b1 = input(2);
a2 = input(3);
b2 = input(4);
a3 = input(5);
b3 = input(6);
rs_type = input(7);
rs_freq = input(8);
T0 = input(9);
d0 = input(10);
d1 = 0;
d2 = 0;
d3 = 0;
d4 = 0;
d5 = 0;
if length(input) > 10,
    d1 = input(11);
    if length(input) > 11,
        d2 = input(12);
        if length(input) > 12,
            d3 = input(13);
            if length(input) > 13,
                d2 = input(14);
                if length(input) > 14,
                    d3 = input(15);
                end;
            end;
        end;
    end;
end;

% FBFW controller: Y=BR/(AP+BQ)*W
% conditions: 1) AP+BQ=D
%             2) BR+FS=D  where W=H/F and S is any polynomial
% 1st condition:
%  A =  1 + a1*z^-1 + a2*z^-2 + a3*z^-3   B =      b1*z^-1 + b2*z^-2 + b3*z^-3
%  P = p0 + p1*z^-1 + p2*z^-2             Q = q0 + q1*z^-1 + q2*z^-2
% system of linear equations:
% [ 1   0   0   0   0   0]   [p0]   [d0]
% [a1   1   0  b1   0   0]   [p1]   [d1]
% [a2  a1   1  b2  b1   0]   [p2]   [d2]
% [a3  a2  a1  b3  b2  b1] * [q0] = [d3]
% [ 0  a3  a2   0  b3  b2]   [q1]   [d4]
% [ 0   0  a3   0   0  b3]   [q2]   [d5]
p0 = d0;
p1 = (-2*d0*a3*b2*b3*a1*b1-b1*d2*b3*a2*b2+2*d1*b1*a3*b2*b3-d0*b1*a3*a2*b2^2+d0*b3*b2*a2^2*b1-d0*b3*a2*a1*b2^2 ...
    +d1*b3^3-d1*a3*b2^3-d0*a1*b3^3+b1^2*d3*b3*a2-b1^2*d3*a3*b2+b1*d2*a3*b2^2-b1^2*d2*b3*a3+b1*d2*b3^2*a1 ...
    +d1*b2^2*b3*a2-d1*b3^2*a2*b1-d1*b2*b3^2*a1+d0*b1^2*a3^2*b2-b1^3*d5*a2+d0*a3*a1*b2^3-b1*d5*b2^2+b1^2*d5*b3 ...
    +d0*b1*b3^2*a3+b1^3*d4*a3+d0*b3^2*a1^2*b2-b1*d3*b3^2+b1^2*d5*a1*b2-b1^2*d4*b3*a1+b1*d4*b3*b2)/ ...
    (-a3*b2^3+b2^2*a3*a1*b1+b2^2*b3*a2-b1^2*a3*a2*b2+3*b1*a3*b2*b3-b2*b3^2*a1-b2*b3*a2*a1*b1+a3^2*b1^3 ...
    -2*a3*a1*b1^2*b3+b3^2*a1^2*b1+b3^3+b1^2*a2^2*b3-2*b3^2*a2*b1);
p2 = (-b3^3*d0*a2-d5*b2^3-d5*b1^2*a2*b2+d5*a1*b1*b2^2-d5*b1^2*a1*b3+2*d5*b3*b1*b2-b3*d4*a1*b1*b2 ...
    +b3*d4*b1^2*a2-b3*d3*b1^2*a3+b3^2*d3*a1*b1-b3^2*d2*a2*b1-b3*d1*a3*b2^2+b3^2*d1*a3*b1+b3^2*d1*a2*b2 ...
    +b3*d2*b1*a3*b2+b3*d0*a3^2*b1^2+b3^3*d2-b3*d0*a3*b2*a2*b1+b3*d0*b2^2*a1*a3+b3^2*d0*a2^2*b1-2*b3^2*d0*a3*a1*b1 ...
    -b3^2*d0*b2*a2*a1+b3^2*d0*a3*b2-b3^2*d4*b1-b3^2*d3*b2-b3^3*d1*a1+b3^3*d0*a1^2+d5*b1^3*a3+b3*d4*b2^2)/ ...
    (-a3*b2^3+b2^2*a3*a1*b1+b2^2*b3*a2-b1^2*a3*a2*b2+3*b1*a3*b2*b3-b2*b3^2*a1-b2*b3*a2*a1*b1+a3^2*b1^3 ...
    -2*a3*a1*b1^2*b3+b3^2*a1^2*b1+b3^3+b1^2*a2^2*b3-2*b3^2*a2*b1);
q0 = (-d0*a3*b3^2-d0*b3^2*a1^3-d0*a3^2*b1*b2-d0*a3^2*b1^2*a1-d5*a1*b1*b2-d3*b3*a2*b1+d4*b3*a1*b1+d3*b1*a3*b2 ...
    -d4*b3*b2+d2*b3*a2*b2+d2*b3*a3*b1-d2*a3*b2^2-d1*a3*b2*a2*b1-d2*b3^2*a1+d1*b2^2*a1*a3+d1*a3^2*b1^2+d1*a3*b2*b3 ...
    -2*d1*a3*a1*b1*b3-d1*b3*b2*a2*a1+d1*b3*a2^2*b1+d0*b2*a1*a2*b1*a3-d0*b3*a1*b1*a2^2+d1*b3^2*a1^2+d0*b2^2*a3*a2 ...
    -d0*b2^2*a1^2*a3-d1*b3^2*a2+2*d0*a3*b3*a1^2*b1-d4*b1^2*a3+d0*b3*b2*a2*a1^2-d5*b1*b3-d0*a3*a1*b3*b2 ...
    +2*d0*b3^2*a2*a1-d0*b3*b2*a2^2+d5*b1^2*a2+d3*b3^2+d5*b2^2)/ ...
    (-a3*b2^3+b2^2*a3*a1*b1+b2^2*b3*a2-b1^2*a3*a2*b2+3*b1*a3*b2*b3-b2*b3^2*a1-b2*b3*a2*a1*b1+a3^2*b1^3 ...
    -2*a3*a1*b1^2*b3+b3^2*a1^2*b1+b3^3+b1^2*a2^2*b3-2*b3^2*a2*b1);
q1 = (d4*b3^2+d0*a3*b3^2*a1+d0*b3^2*a2^2-d1*a3*b3^2+d0*a3^2*b2^2-d5*b1^2*a3+d5*a1*b1^2*a2-d5*a1^2*b1*b2 ...
    +d4*b3*a1^2*b1-d4*b3*a1*b2-d4*b3*a2*b1-d4*a3*a1*b1^2+d4*b1*a3*b2+d3*b3*a2*b2+d3*b3*a3*b1+d5*a1*b2^2 ...
    -d3*b3*a2*a1*b1+d3*b2*a3*a1*b1-d2*a3*b2*a2*b1+d2*b3*a2^2*b1-d2*a3*a1*b1*b3+d2*a3*b2*b3-d1*a3^2*b1*b2 ...
    +d1*b2^2*a3*a2-d5*b3*b2-d1*b3*b2*a2^2-d2*b3^2*a2+d1*b3^2*a2*a1-d0*a3^2*b1^2*a2+2*d0*a3*b3*a2*a1*b1 ...
    +d0*b2*a3*a2^2*b1-d0*b3*a2^3*b1-d0*b2^2*a2*a1*a3-d0*a3^2*b1*b3-d3*a3*b2^2+d0*b3*b2*a2^2*a1-2*d0*b3*a3*a2*b2 ...
    +d2*a3^2*b1^2-d0*b3^2*a2*a1^2)/ ...
    (-a3*b2^3+b2^2*a3*a1*b1+b2^2*b3*a2-b1^2*a3*a2*b2+3*b1*a3*b2*b3-b2*b3^2*a1-b2*b3*a2*a1*b1+a3^2*b1^3 ...
    -2*a3*a1*b1^2*b3+b3^2*a1^2*b1+b3^3+b1^2*a2^2*b3-2*b3^2*a2*b1);
q2 = (d5*b1*a3*b2-d5*b2*a2*a1*b1+d4*a3*a1*b1*b2-d3*a3*b3*a1*b1+d2*a3*b3*a2*b1-d1*a3*b3*a2*b2+d0*a3^2*b2*a2*b1 ...
    -d0*a3*b3*a2^2*b1+2*d0*a3^2*a1*b1*b3+d0*a3*b3*b2*a2*a1+d5*b3^2+d3*a3^2*b1^2-d2*a3*b3^2+d1*a3^2*b2^2 ...
    -d0*a3^3*b1^2+d5*b1^2*a2^2+d5*a2*b2^2-d4*a3*b2^2-d2*a3^2*b1*b2-d1*a3^2*b3*b1+d1*a3*b3^2*a1-d0*a3^2*b2^2*a1 ...
    -d0*a3^2*b2*b3-d0*a3*b3^2*a1^2+d0*a3*b3^2*a2-2*d5*b3*a2*b1+d5*b3*a1^2*b1-d5*a3*a1*b1^2-d5*b3*a1*b2 ...
    -d4*a3*b1^2*a2+d4*a3*b1*b3+d3*a3*b3*b2)/ ...
    (-a3*b2^3+b2^2*a3*a1*b1+b2^2*b3*a2-b1^2*a3*a2*b2+3*b1*a3*b2*b3-b2*b3^2*a1-b2*b3*a2*a1*b1+a3^2*b1^3 ...
    -2*a3*a1*b1^2*b3+b3^2*a1^2*b1+b3^3+b1^2*a2^2*b3-2*b3^2*a2*b1);

% 2nd condition:
switch (rs_type)
case 1,     %step:
    %  B = b1*z^-1 + b2*z^-2 + b2*z^-3   F =  1 - z^-1
    %  R = r0                            S = s0 + s1*z^-1 + s2*z^-2 + s3*z^-3 + s4*z^-4
    % [ 0   1    0   0   0   0]   [r0]   [d0]
    % [b1  -1    1   0   0   0]   [s0]   [d1]
    % [b2   0   -1   1   0   0] * [s1] = [d2]
    % [b3   0    0  -1   1   0]   [s2]   [d3]
    % [ 0   0    0   0  -1   1] * [s3] = [d4]
    % [ 0   0    0   0   0  -1]   [s4]   [d5]
    r0 = (d0+d1+d2+d3+d4+d5)/(b1+b3+b2);
    r1 = 0;
case 2,     %ramp
    %  B =      b1*z^-1 + b2*z^-2 + b3*z^-3   F =  1 - 2*z^-1 + z^-2');
    %  R = r0 + r1*z^-1                       S = s0 + s1*z^-1 + s2*z^-2 + s3*z^-3');
    % [ 0   0   1   0   0   0]   [r0]   [d0]
    % [b1   0  -2   1   0   0]   [r1]   [d1]
    % [b2  b1   1  -2   1   0] * [s0] = [d2]
    % [b3  b2   0   1  -2   1]   [s1]   [d3]
    % [ 0  b3   0   0   1  -2]   [s2]   [d4]
    % [ 0   0   0   0   0   1]   [s3]   [d5]
    r0 = (4*d0*b3+3*d0*b2+2*d0*b1+3*d1*b3+d1*b1+2*d1*b2+2*d2*b3+d2*b2-d3*b1+b3*d3-2*d4*b1-d4*b2+d5*b3 ...
        -2*d5*b2-5*d5*b1)/(b1+b2+b3)^2;
    r1 = (-3*d0*b3-d0*b1-2*d0*b2-2*d1*b3-d1*b2+d2*b1-d2*b3+2*d3*b1+d3*b2+d4*b3+2*d4*b2+3*d4*b1+2*d5*b3 ...
        +5*d5*b2+8*d5*b1)/(b1+b2+b3)^2;
case 3,     %sin(om*t/T0)
    om = 2*pi*rs_freq*T0;
    %  B =      b1*z^-1 + b2*z^-2 + b3*z^-3   F =  1 - 2*cos(om)*z^-1 + z^-2');
    %  R = r0 + r1*z^-1                       S = s0 + s1*z^-1 + s2*z^-2 + s3*z^-3');
    % [ 0   0           1           0           0           0]   [r0]   [d0]
    % [b1   0  -2*cos(om)           1           0           0]   [r1]   [d1]
    % [b2  b1           1  -2*cos(om)           1           0] * [s0] = [d2]
    % [b3  b2           0           1  -2*cos(om)           1]   [s1]   [d3]
    % [ 0  b3           0           0           1  -2*cos(om)]   [s2]   [d4]
    % [ 0   0           0           0           0           1]   [s3]   [d5]
    r0 = (2*d0*b1*cos(om)+4*d0*b2*cos(om)^2-d0*b2+8*d0*b3*cos(om)^3-4*d0*b3*cos(om)+d1*b1+2*d1*b2*cos(om) ...
        +4*d1*b3*cos(om)^2-b3*d1+d2*b2+2*d2*b3*cos(om)-d3*b1+b3*d3-2*d4*b1*cos(om)-d4*b2-4*d5*b1*cos(om)^2 ...
        -d5*b1-2*d5*b2*cos(om)+d5*b3)/(b1^2+2*b1*b2*cos(om)+4*b1*b3*cos(om)^2-2*b1*b3+b2^2+2*b2*b3*cos(om)+b3^2);
    r1 = -(d0*b1+2*d0*b2*cos(om)+4*d0*b3*cos(om)^2-d0*b3+d1*b2+2*d1*b3*cos(om)-d2*b1+d2*b3-2*d3*b1*cos(om)-d3*b2 ...
        -4*d4*b1*cos(om)^2+d4*b1-2*d4*b2*cos(om)-d4*b3-8*d5*b1*cos(om)^3-4*d5*b2*cos(om)^2-d5*b2-2*d5*b3*cos(om))/ ...
        (b1^2+2*b1*b2*cos(om)+4*b1*b3*cos(om)^2-2*b1*b3+b2^2+2*b2*b3*cos(om)+b3^2);
end;

param=[r0; r1; q0; q1; q2; p0; p1; p2];
