function [qp]=zn3pi(input)
% [qp]=zn3pi(input)
% Ziegler-Nichols PI controller for processes of 3rd order.
% This function computes parameters of the controller (q0, q1, q2, p1, p2).
% Controller is based on trapezoidal method of discretization.
% Transfer function of the controller is as follows:
%
%            q0 + q1*z^-1     q0 + q1*z^-1 + q2*z^-2
% G(z^-1) = -------------- = ------------------------
%              1 - z^-1        1 + p1*z^-1 + p2*z^-2
%
% where q2=0, p1=-1 and p2=0.
%
% Transfer function of the controlled system is:
%
%               b1*z^-1 + b2*z^-2 + b3*z^-3
% Gs(z^-1) = ---------------------------------
%             1 + a1*z^-1 + a2*z^-2 + a3*z^-3
%
% Input: input ... input parameters
%                  input(1) ... a1
%                  input(2) ... b1
%                  input(3) ... a2
%                  input(4) ... b2
%                  input(5) ... a3
%                  input(6) ... b3
%                  input(7) ... sample time T0
% Output: qp ... controller parameters   
%                qp(1) ... q0
%                qp(2) ... q1
%                qp(3) ... q2 (0)
%                qp(4) ... p1 (-1)
%                qp(5) ... p2 (0)

a1 = input(1);
b1 = input(2);
a2 = input(3);
b2 = input(4);
a3 = input(5);
b3 = input(6);
T0 = input(7);

% compute ultimate gain and frequency
[Kpu, Tu] =  ultim([b1 b2 b3],[a1 a2 a3],T0);

Kp = 0.6*Kpu;
Ti = Tu/2;

q0 = Kp*(1 + T0/(2*Ti));
q1 = -Kp*(1 - T0/(2*Ti));
q2 = 0;
p1 = -1;
p2 = 0;

qp=[q0; q1; q2; p1; p2];