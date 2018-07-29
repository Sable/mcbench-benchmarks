function [param]=pp2b_1(input)
% [param]=pp2b_1(input)
% PID B-1 pole placement controller for 2nd order processes.
% This function computes parameters of the controller (r0, q0, q1, q2, p1, p2).
% The dynamic behavoiour of the closed-loop is similar to 
% second order continuous system with characteristic polynomial 
% s^2 + 2*xi*omega*s + omega^2.
% Output of the controller is calculated follows:
%
%                  r0                            q0 + q1*z^-1 + q2*z^-2              
% U(z^-1) = ----------------------- * W(z^-1) - ------------------------ * Y(z^-1)
%            1 + p1*z^-1 + p2*z^-2                1 + p1*z^-1 + p2*z^-2
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
%                  input(5) ... sample time T0
%                  input(6) ... damping factor xi
%                  input(7) ... natural frequency omega
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
T0 = input(5);
xi = input(6);
omega = input(7);

d2=exp(-2*xi*omega*T0);
if xi<=1
   d1=-2*exp(-xi*omega*T0)*cos(omega*T0*(sqrt(1-xi*xi)));
else
   d1=-2*exp(-xi*omega*T0)*cosh(omega*T0*(sqrt(xi*xi-1)));
end

% solve diofantic equation A(z^-1)*P(z^-1) + B(z^-1)*(Q(z^-1)+r0) = D(z^-1)
% P(z^-1) = (1-z^-1) * (1+gama*z^-1)
% Q(z^-1) = (1-z^-1) * (q0m - q2m*z^-1)
% D(z^-1) = 1 + d1*z^-1 + d2*z^-2
s1=a2*(b2*(a1*(b1+b2)+b1*(d2-a2)-b2*(d1+1))-a2*b1^2);
r1=(b1+b2)*(a1*b1*b2-a2*b1^2-b2^2);

q2m = s1/r1;
gama = q2m*b2/a2;
q0m = q2m*(b1/b2-a1/a2)-a2/b2;

r0 = (d1+1-a1-gama-b1*q0m)/b1;
q0 = q0m + r0;
q1 = -(q0m + q2m);
q2 = q2m;
p1 = gama-1;
p2 = -gama;

param=[r0; q0; q1; q2; p1; p2];
