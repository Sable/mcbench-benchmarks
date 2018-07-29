function [qp]=zn2fd(input)
% [qp] = zn2fd(input)
% Ziegler-Nichols controller for 2nd order processes with filtration of
% D-component using Tustin aproximation. Time constant of the filter is 
% computed: Tf = Td/alfa.
% This function computes parameters of the controller (q0, q1, q2, p1, p2).
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
%                  input(6) ... filtration coeficient alfa
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
alfa = input(6);

% compute ultimate gain and frequency
[Kpu, Tu] =  ultim([b1 b2],[a1 a2],T0);

Kp = 0.6*Kpu;
Ti = Tu/2;
Td = Tu/8;
Tf = Td/alfa;

cf = Tf/T0;
ci = T0/Ti;
cd = Td/T0;
p1 = -4*cf/(1+2*cf);
p2 = (2*cf-1)/(1+2*cf);
q0 = Kp * (1 + 2*(cf+cd) + (ci/2)*(1+2*cf))/(1+2*cf);
q1 = Kp * (ci/2-4*(cf+cd))/(1+2*cf);
q2 = Kp * (cf*(2-ci) + 2*cd + ci/2 - 1)/(1+2*cf);

qp=[q0; q1; q2; p1; p2];
