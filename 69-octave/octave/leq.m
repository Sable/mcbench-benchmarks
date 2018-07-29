function p=leq(x,t,Pref)
% LEQ  Computes the sequence of short-time RMS powers (Leq) of a signal. 
%     P = LEQ(X,T) is a length LENGTH(X)/T column vector whose 
%     elements are the RMS powers (Leq's) of length T frames of X. 
%     The powers are expressed in dB with 1 as reference level. 
%     LEQ(X,T,REF) uses REF as the reference level for the dB 
%     scale. If a RMS power is equal to zero, a NaN is returned 
%     for its dB value. 
%

% Author: Christophe Couvreur, Faculte Polytechnique de Mons (Belgium)
%         couvreur@thor.fpms.ac.be
% Last modification: Aug. 24, 1997, 4:00pm.

m = floor(length(x)/t);
p = zeros(m,1);
for i = 1:m
  p(i) = sum(x((i-1)*t+1:i*t).^2)/t; 
end
idx = (p>0);
if (nargin < 3)
  Pref = 1; 
end
if ~isempty(idx) 
  p(idx) = 10*log10(p(idx)/Pref);
  p(~idx) = NaN*ones(sum(~idx),1);
else
  p = NaN*ones(m,1);
end
