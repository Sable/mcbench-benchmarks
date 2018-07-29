function [param]=mv2(input)
% [param] = mv2(input)
% Minimum variance controller for processes of 2nd order.
% This function computes parameters of the controller (r0, q0, q1, q2, p1, p2).
% Output of the controller is calculated follows:
%
% u(k) = 1/q * ( a1*y(k-1) + a2*y(k-2) - b1*u(k-1) - b2*u(k-2) + w(k) ) + u(k-1)
%
%
%                  r0                            q0 + q1*z^-1 + q2*z^-2              
% U(z^-1) = ----------------------- * W(z^-1) - ------------------------ * Y(z^-1)
%            1 + p1*z^-1 + p2*z^-2                1 + p1*z^-1 + p2*z^-2
%
% where q0=0
%
% Transfer function of the controlled system is:
%
%               b1*z^-1 + b2*z^-2
% Gs(z^-1) = -----------------------
%             1 + a1*z^-1 + a2*z^-2
%
% Input: input ... input parameters
%                  input(1) ... a1
%                  input(2) ... b1
%                  input(3) ... a2
%                  input(4) ... b2
%                  input(5) ... penalisation factor q
% Output: param ... controller parameters   
%                   param(1) ... r0
%                   param(2) ... q0
%                   param(3) ... q1
%                   param(4) ... q2
%                   param(5) ... p1
%                   param(6) ... p2

a1 = input(1);
b1 = input(2);
a2 = input(3);
b2 = input(4);
q = input(5);

% check inputs
if (q == 0)
   disp('mv2.m: Input parameter q (penalisation factor) must not be equal 0');
   disp('       parameter value has been changed to 1e-6');
   q = 1e-6;
end

r0 = 1/q;
q0 = -1/q * a1;
q1 = -1/q * a2;
q2 = 0;
p1 = 1/q * b1 - 1;
p2 = 1/q * b2;

param=[r0; q0; q1; q2; p1; p2];
