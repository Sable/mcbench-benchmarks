function [qp]=da2(input)	
% [qp] = da2(input)
% Dahlin's controller for processes of 2nd order.
% This function computes parameters of the controller (q0, q1, q2, p1, p2).
% Transfer function of the controller is as follows:
%
%            q0 + q1*z^-1 + q2*z^-2     q0 + q1*z^-1 + q2*z^-2
% G(z^-1) = ------------------------ = ------------------------
%                  1 - z^-1              1 + p1*z^-1 + p2*z^-2
%
% where p1=-1 and p2=0.
%
% Transfer function of the controlled system is:
%
%                  b1*z^-1
% Gs(z^-1) = -----------------------
%             1 + a1*z^-1 + a2*z^-2
%
% Input: input ... input parameters
%                  input(1) ... a1
%                  input(2) ... b1
%                  input(3) ... a2
%                  input(4) ... sample time T0
%                  input(5) ... adjustment factor B
% Output: qp ... controller parameters   
%                qp(1) ... q0
%                qp(2) ... q1
%                qp(3) ... q2
%                qp(4) ... -1   (p1 of the controller)
%                qp(5) ... 0    (p2 of the controller)

a1 = input(1);
b1 = input(2);
a2 = input(3);
T0 = input(4);
B = input(5);

% check inputs
if (T0 <= 0)
   disp('da2.m: Input parameter T0 (sample time) must be greater than 0');
   disp('       parameter value has been changed to 1');
   T0 = 1;
end;
if (B <= 0)
   disp('da2.m: Input parameter B (adjustment factor) must be greater than 0');
   disp('       parameter value has been changed to 1e-6');
   B = 1e-6;
end;

Q = 1-exp(-T0/B);
Kp = -(a1+2*a2)*Q/b1;
Td = T0*a2*Q/(Kp*b1);
Ti = -T0/((1/(a1+2*a2))+1+Td/T0);

q0 = Kp*(1+T0/Ti+Td/T0);
q1 = -Kp*(1+2*Td/T0);
q2 = Kp*Td/T0;
p1 = -1;
p2 = 0;

qp=[q0; q1; q2; p1; p2];