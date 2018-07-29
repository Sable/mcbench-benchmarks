function pole_cplx = realpole(pole,w,flag)
%
% Utility Function: REALPOLE
%
% This function computes the magnitude and phase response of a real pole/zero

% Author: Craig Borghesani
% Date: 8/8/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

if length(flag)==1,
 s = sqrt(-1)*w(:)';
 l = s + pole;
else
 T = flag(2);
 z = exp(sqrt(-1)*w(:)'*T);
 pole = real(exp(-pole*T));
 l = 1-pole./z;
end
zero = find(abs(l)==0);
if length(zero), l(zero)=ones(1,length(zero))*eps; end
pole_cplx= l.^flag(1);
