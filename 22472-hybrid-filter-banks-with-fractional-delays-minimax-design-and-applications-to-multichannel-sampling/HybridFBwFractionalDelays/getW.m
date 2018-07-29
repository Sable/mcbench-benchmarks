function [Aw, Bw, Cw, Dw] = getW(sys, M)

% getW: get system W as in Theorem 1
%
% Usage:    [Aw, Bw, Cw, Dw] = getW(sys, M)
%
% INPUT:
%   sys: a system (after the Prop. 3)
%   M: superresolution factor (integer)
%
% OUTPUT: system W = {Aw, Bw, Cw, Dw}, in state space representation
%
% See also: getH, getP, designIIR

[A, B, C, D] = ssdata(sys);
C = C(1,:);

Aw = A^M;

Bw = [];
Cw = [];
Dw = [];

for i = 1:M
    Bw = [Bw A^(M-i)*B];
    Cw = [Cw; C*A^(i-1)];
    
    Di = [];
    
    for j = 1:M
        if (j < i)
            Di = [Di C*A^(i-j-1)*B];
        else
            Di = [Di zeros( size(C,1), size(B,2) )];
        end
    end
    
    Dw = [Dw; Di];
end
