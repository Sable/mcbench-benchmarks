function [param]=pp2c2dof(input)
% [param]=pp2c2dof(input)
% Pole placement controller for 2nd order processes.
% This function computes parameters of the controller.
% The dynamic behaviour of the closed-loop is similar to 
% second order continuous system with characteristic polynomial 
% s^2 + 2*xi*omega*s + omega^2.
% Output of the controller is calculated follows:
%
%                       r0                            q0 + q1*z^-1 + q2*z^-2              
% U(z^-1) = -------------------------- * W(z^-1) - -------------------------- * Y(z^-1)
%           (1 - z^-1) * (1 + p1*z^-1)             (1 - z^-1) * (1 + p1*z^-1)
%
% Transfer function of the controlled system is:
%
%               b1*z^-1 + b2*z^-2
% Gs(z^-1) = -----------------------
%             1 + a1*z^-1 + a2*z^-2
%
% Input: 
%   input(1:4) ... [a1 b1 a2 b2]
%   input(5) ... sample time T0
%   input(6) ... damping factor xi
%   input(7) ... natural frequency omega
% Output: param ... controller parameters  [r0; q0; q1; q2; p0; p1];

a1 = input(1);
b1 = input(2);
a2 = input(3);
b2 = input(4);
T0 = input(5);
xi = input(6);
om = input(7);

d2=exp(-2*xi*om*T0);
if (xi <= 1)
   d1=-2*exp(-xi*om*T0)*cos(om*T0*(sqrt(1-xi*xi)));
else
   d1=-2*exp(-xi*om*T0)*cosh(om*T0*(sqrt(xi*xi-1)));
end

% FBFW controller: Y=BR/(APK+BQ)*W
% conditions: 1) APK+BQ=D
%             2) BR+FS=D  where W=H/F and S is any polynomial
% 1st condition:
%  A = 1 + a1*z^-1 + a2*z^-2   B =      b1*z^-1 + b2*z^-2
%  P = 1 + p1*z^-1             Q = q0 + q1*z^-1 + q2*z^-2
%  K = 1 - z^-1
% system of linear equations:
% [b1  0   0   1  ]   [q0]   [ d1+1-a1]
% [b2  b1  0 a1-1 ]   [q1]   [d2+a1-a2]
% [ 0  b2 b1 a2-a1] * [q2] = [   a2   ]
% [ 0  0  b2  -a2 ]   [p1]   [   0    ]
q0 = -(b1^2*a2*d1+b1^2*a2-b1^2*a2*a1+b1*b2*a2*d1-b1*b2*a2*a1-b1*b2*a1*d1-b1*b2*a1 ...
    +b1*b2*a1^2-b2^2*a1*d1-b2^2*a1+b2^2*a1^2+b2^2*d1+b2^2+b2^2*d2-b2^2*a2)/(b2+b1)/(-b1^2*a2+b1*b2*a1-b2^2);
q1 = (b1*b2*a2*d1-2*b1*b2*a2*a1+b2^2*a2*d1-b2^2*a2*a1-b2^2*a1*d1-b2^2*a1+b2^2*a1^2-b1^2*a2*d2...
    -b1^2*a2*a1+b1^2*a2^2-b1*b2*a2*d2+b1*b2*a2^2+b1*b2*a1*d2+b1*b2*a1^2)/(b2+b1)/(-b1^2*a2+b1*b2*a1-b2^2);
q2 = a2*(-b2^2*d1-b2^2+b2^2*a1+b1*b2*d2+b1*b2*a1-b1*b2*a2-b1^2*a2)/(b2+b1)/(-b1^2*a2+b1*b2*a1-b2^2);
p1 = b2*(-b2^2*d1-b2^2+b2^2*a1+b1*b2*d2+b1*b2*a1-b1*b2*a2-b1^2*a2)/(b2+b1)/(-b1^2*a2+b1*b2*a1-b2^2);

% 2nd condition - step signal:  F =  1 - z^-1
r0 = (1+d1+d2)/(b1+b2);

%parameters for scfbfw (no explicit compensator)
param=[r0; q0; q1; q2; 1; p1-1; -p1];
