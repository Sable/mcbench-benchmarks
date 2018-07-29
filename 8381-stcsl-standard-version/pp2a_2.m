function [qp]=pp2a_2(input)
% [qp]=pp2a_2(input)
% PID A-2 pole placement controller for 2nd order processes.
% This function computes parameters of the controller (q0, q1, q2, p1, p2).
% The dynamic behaviour of the closed-loop is defined by its  
% poles: z1 = alfa+j*omega, z2 = alfa-j*omega, z3,z4 = alfa. 
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
%                  input(5) ... imaginary component of the pole omega
%                  input(6) ... real component of the pole alfa
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
omega = input(5);
alfa = input(6);

% solve diofantic equation A(z^-1)*P(z^-1) + B(z^-1)*Q(z^-1) = D(z^-1)
% P(z^-1) = (1-z^-1) * (1+gama*z^-1)
% Q(z^-1) = q0 + q1*z^-1 + q2*z^-2
% D(z^-1) = (1-(alfa+j*omega)*z^-1) * (1-(alfa-j*omega)*z^-1) * (1-alfa*z^-1)^2
c = -4*alfa;
d = 6*alfa^2+omega^2;
f = -2*alfa*(2*alfa^2+omega^2);
g = alfa^2*(alfa^2+omega^2);
x1 = c+1-a1;
x2 = d+a1-a2;
x3 = f+a2;
x4 = g;
r1 = (b1+b2)*(a1*b1*b2-a2*b1^2-b2^2);
r2 = x1*(b1+b2)*(a1*b2-a2*b1);
r3 = b1^2*x4-b2*(b1*x3-b2*(x1+x2));
r4 = a1*(b1^2*x4+b2^2*x1-b1*b2*(x2+x3));
r5 = (b1+b2)*(a2*(b1*x2-b2*x1)-b1*x4+b2*x3);
r6 = b1^3*x4-b1^2*b2*x3+b1*b2^2*x2-b2^3*x1;

gama = r6/r1;
q0 = (r2-r3)/r1;
q1 = -(r4+r5)/r1;
q2 = (x4+gama*a2)/b2;
p1 = gama-1;
p2 = -gama;

qp=[q0; q1; q2; p1; p2];
