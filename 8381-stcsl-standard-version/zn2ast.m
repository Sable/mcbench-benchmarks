function [param]=zn2ast(input)
% [param]=zn2ast(input)
% Äström's controller for 2nd order processes.
% This function computes parameters of the controller (Kp, Ti, Td)
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
% Output: param ... controller parameters   
%                   param(1) ... Kp
%                   param(2) ... Ti 
%                   param(3) ... Td

a1 = input(1);
b1 = input(2);
a2 = input(3);
b2 = input(4);
T0 = input(5);

% compute ultimate gain and frequency
[Kpu, Tu] =  ultim([b1 b2],[a1 a2],T0);
   
Kp = 0.6*Kpu;
Ti = Tu/2;
Td = Tu/8;

param=[Kp;Ti;Td];