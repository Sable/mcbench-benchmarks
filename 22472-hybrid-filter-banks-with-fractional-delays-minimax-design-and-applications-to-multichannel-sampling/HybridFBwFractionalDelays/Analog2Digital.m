function [A, B, C, D] = Analog2Digital(Ak, Bk, Ck, Dk)

% Analog2Digital: bilinear transformation of an analog system K to discrete
% time 
%
% Usage:    [A, B, C, D] = Analog2Digital(Ak, Bk, Ck, Dk)
%
% INPUTS: state space matrices of the input analog system K
%
% OUTPUTS: state space matrices of the output discrete system  
% 
% See also: designIIR, Digital2Analog

nk = size(Ak, 1);
S = inv(eye(nk) - Ak);

A = S * (eye(nk) + Ak);
B = S * Bk;
D = Dk + Ck * B;
C = Ck * (eye(nk) + A);

sys = ss(A,B,C,D);
sys = sminreal(sys);

[A, B ,C ,D] = ssdata(sys);