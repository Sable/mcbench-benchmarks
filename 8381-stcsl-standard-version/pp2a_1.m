function [qp]=pp2a_1(input)
% [qp]=pp2a_1(input)
% PID A-1 pole placement controller for 2nd order processes.
% This function computes parameters of the controller (q0, q1, q2, p1, p2).
% The dynamic behaviour of the closed-loop is similar to 
% second order continuous system with characteristic polynomial 
% s^2 + 2*xi*omega*s + omega^2.
% Transfer function of the controller is as follows:
%
%            q0 + q1*z^-1 + q2*z^-2
% G(z^-1) = ------------------------
%             1 + p1*z^-1 + p2*z^-2
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
% Output: qp ... controller parameters   
%                qp(1) ... q0
%                qp(2) ... q1
%                qp(3) ... q2
%                qp(4) ... p1
%                qp(5) ... p2

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

% solve diofantic equation A(z^-1)*P(z^-1) + B(z^-1)*Q(z^-1) = D(z^-1)
% P(z^-1) = (1-z^-1) * (1+gama*z^-1)
% Q(z^-1) = q0 + q1*z^-1 + q2*z^-2
% D(z^-1) = 1 + d1*z^-1 + d2*z^-2
s1 = a2*((b1+b2)*(a1*b2-a2*b1)+b2*(b1*d2-b2*d1-b2));
r1 = (b1+b2)*(a1*b1*b2-a2*b1^2-b2^2);

q2 = s1/r1;
gama = q2*b2/a2;
q1 = a2/b2-q2*(b1/b2-a1/a2+1);
q0 = 1/b1 * (d1+1-a1-gama);
p1 = gama-1;
p2 = -gama;

qp=[q0; q1; q2; p1; p2];