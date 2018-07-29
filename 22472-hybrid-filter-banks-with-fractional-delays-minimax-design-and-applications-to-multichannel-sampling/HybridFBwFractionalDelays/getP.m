function [Ap, Bp, Cp, Dp, p, q] = getP(sys, M)

% getP: get system P as in Figure 7
%
% Usage:    [Ap, Bp, Cp, Dp, p, q] = getP(sys, M)
%
% INPUT:
%   sys: a system (after the Prop. 3)
%   M: superresolution factor (integer)
%
% OUTPUT: 
%   system P = {Ap, Bp, Cp, Dp}, in state space representation
%   p,q:    number of rows of Ch and Cw, to be used in hinfsyn
%
% See also: getW, getH, designIIR, hinfsyn

[Aw, Bw, Cw, Dw] = getW(sys, M);    
[Ah, Bh, Ch, Dh] = getH(sys, M);

p = size(Ch,1);
q = size(Cw,1);

Ap = blkdiag(Aw, Ah);
Bp = [ [Bw; Bh], zeros( size(Ap,1), size(Dw,1) ) ]; 
Cp = blkdiag(Cw, Ch);
Dp = [Dw, - eye( size(Dw,1) ) ;
      Dh, zeros( size(Dh,1), size(Dw,1) ) ];
  