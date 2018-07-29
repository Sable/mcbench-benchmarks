function [param]=db2w(input)
% [param] = db2w(input)
% Dead beat controller for processes of 2nd order (weak version).
% This function computes parameters of the controller (r0, q0, q1, q2, p1, p2).
% Output of the controller is calculated follows:
%
%                  r0                            q0 + q1*z^-1 + q2*z^-2              
% U(z^-1) = ----------------------- * W(z^-1) - ------------------------ * Y(z^-1)
%            1 + p1*z^-1 + p2*z^-2                1 + p1*z^-1 + p2*z^-2
%
% where q2=0 and p2=0
% The controller parameters are calculated for step change of W. 
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
% Output: param ... controller parameters   
%                   param(1) ... r0
%                   param(2) ... q0
%                   param(3) ... q1
%                   param(4) ... q2
%                   param(5) ... p1
%                   param(6) ... p2

a1=input(1);
b1=input(2);
a2=input(3);
b2=input(4);

r0 = 1/b1;
q0 = -a1/b1;
q1 = -a2/b1;
q2 = 0;
p1 = b2/b1;
p2 = 0;

param=[r0; q0; q1; q2; p1; p2];