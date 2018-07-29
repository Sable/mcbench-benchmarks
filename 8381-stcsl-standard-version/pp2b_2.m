function [param]=pp2b_2(input)
% [qp]=pp2b_2(input)
% PID B-2 pole placement controller for 2nd order processes.
% This function computes parameters of the controller (r0, q0, q1, q2, p1, p2).
% The dynamic behavoiour of the closed-loop is defined by its  
% poles: z1 = alfa+j*omega, z2 = alfa-j*omega, z3,z4 = alfa. 
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
%                  input(5) ... imaginary component of the pole omega
%                  input(6) ... real component of the pole alfa
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
omega = input(5);
alfa = input(6);

% solve equation A(z^-1)*P(z^-1) + B(z^-1)*(Q(z^-1)+r0) = D(z^-1)
% P(z^-1) = (1-z^-1) * (1+gama*z^-1)
% Q(z^-1) = (1-z^-1) * (q0m - q2m*z^-1)
% D(z^-1) = (1-(alfa+j*omega)*z^-1) * (1-(alfa-j*omega)*z^-1) * (1-alfa*z^-1)^2
c = -4*alfa;
d = 6*alfa*alfa + omega*omega;
f = -4*alfa*alfa*alfa - 2*alfa*omega*omega;
g = alfa*alfa*alfa*alfa + alfa*alfa*omega*omega;
x1 = c+1-a1;
x2 = d+a1-a2;
x3 = -f-a2;
x4 = g;
r1 = (b1+b2)*(a1*b1*b2-a2*b1^2-b2^2);
r2 = a1*b2*(b1*(x2-x3+x4)-b2*x1);
r3 = a2*b1*(b2*x1-b1*(x2-x3+x4));
r4 = (b1+b2)*(b1*x4+b2*(x3-x4));
r5 = b1*(b1^2*x4+b1*b2*x3+b2^2*x2)-b2^3*x1;
r6 = b1^2*(a2*x3+a1*x4-a2*x4);
r7 = b2*(b1*(a1*x4+a2*x2-x4)-b2*(a2*x1+x4));
gama = r5/r1;
q0m = -(r2+r3+r4)/r1;
q2m = (r6+r7)/r1;	

r0 = (x1+x2-x3+x4)/(b1+b2);
q0 = q0m+r0;
q1 = -(q0m + q2m);
q2 = q2m;
p1 = gama-1;
p2 = -gama;

param=[r0; q0; q1; q2; p1; p2];
