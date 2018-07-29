function [Ah, Bh, Ch, Dh] = getH(sys, M)

% getH: get system H as in Theorem 1
%
% Usage:    [Ah, Bh, Ch, Dh] = getH(sys, M)
%
% INPUT:
%   sys: a system (after the Prop. 3)
%   M: superresolution factor (integer)
%
% OUTPUT: system H = {Ah, Bh, Ch, Dh}, in state space representation
%
% See also: getW, getP, designIIR

[A, B, C, D] = ssdata(sys);

N = size(C,1)-1;

Ah = [];
Bh = [];
Ch = [];

for i = 1:N
    Ah = blkdiag(Ah, A^M);
    Ch = blkdiag(Ch, C(i+1,:));
    
    Bi = [];
    
    for j = 1:M
        Bi = [Bi A^(M-j)*B];
    end
    
    Bh = [Bh; Bi];
end

Dh = zeros( size(Ch,1), size(Bh,2) );

