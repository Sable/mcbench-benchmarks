function [param]=zn3tak(input)
% [param]=zn3pd(input)
% Takahashi's controller for processes of 3rd order.
% This function computes parameters of the controller (r0, q0, q1, q2, p1, p2).
% Output of the controller is calculated follows:
%
%                  r0                            q0 + q1*z^-1 + q2*z^-2              
% U(z^-1) = ----------------------- * W(z^-1) - ------------------------ * Y(z^-1)
%            1 + p1*z^-1 + p2*z^-2                1 + p1*z^-1 + p2*z^-2
%
% where p1=-1, p2=0
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
% Output: param ... controller parameters   
%                   param(1) ... r0
%                   param(2) ... q0
%                   param(3) ... q1
%                   param(4) ... q2 (0)
%                   param(5) ... p1 (0)
%                   param(6) ... p2 (0)

a1 = input(1);
b1 = input(2);
a2 = input(3);
b2 = input(4);
a3 = input(5);
b3 = input(6);
T0 = input(7);

% compute ultimate gain and frequency
[Kpu, Tu] =  ultim([b1 b2 b3],[a1 a2 a3],T0);

Kp = 0.6*Kpu*(1-T0/Tu);
Ti = Kp*Tu/(1.2*Kpu);
Td = 3*Kpu*Tu/(40*Kp);

r0 = Kp*T0/Ti;
q0 = Kp*(1+T0/Ti+Td/T0);
q1 = -Kp*(1+2*Td/T0);
q2 = Kp*(Td/T0);
p1 = -1;
p2 = 0;

param=[r0; q0; q1; q2; p1; p2];
