function [A, B, C, D] = Digital2Analog(Ap, Bp, Cp, Dp)

% Digital2Analog: bilinear transformation of a discrete system P to analog
% domain 
%
% Usage:    [A, B, C, D] = Digital2Analog(Ap, Bp, Cp, Dp)
%
% INPUTS:   state space matrices of the input discrete system P
%
% OUTPUT:   state space matrices of the output analog system
%
% See also: designIIR, Analog2Digital

S = inv(eye(size(Ap,1)) + Ap);

A = (Ap - eye(size(Ap,1))) * S;
B = (eye(size(A))-A) * Bp;
C = Cp * S;
D = Dp - C * Bp;

sys = ss(A,B,C,D);
sys = sminreal(sys);

[A, B ,C ,D] = ssdata(sys);