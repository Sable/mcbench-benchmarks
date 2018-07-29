function pole_cplx = cplxpole(zta,wn,w,flag)
%
% Utility function: CPLXPOLE
%
% The purpose of this function is to compute the magnitude response of a
% complex pole or zero.

% Author: Craig Borghesani
% Date: 8/8/94
% Revised:
% Copyright (c) 1999, Prentice-Hall

if length(flag)==1,
 s = sqrt(-1)*w(:)';
 ht = s.^2 + 2*zta*wn*s + wn^2;
else
 T = flag(2);
 z = exp(sqrt(-1)*w(:)'*T);
 a = zta*wn; b = wn*sqrt(1-zta^2);
 ht = z - 2*exp(-a*T)*cos(b*T) + exp(-2*a*T)./z;
end
zero=find(abs(ht)==0);
if length(zero), ht(zero)=ones(1,length(zero))*eps; end
pole_cplx = ht.^flag(1);
