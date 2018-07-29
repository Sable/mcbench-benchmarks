function ftps = kts2ftps(kts)
%KTS2FTPS Convert speed from knots to feet per second
%
%  ftps = KTS2FTPS(kts) convert speeds from knots to feet per second.
%
%  See also KTS2KMPH, KTS2MPH, KTS2MPS, FTPS2KTS.

% Jonathan Sullivan
% Original: May 2011
% jonathan.sullivan@ll.mit.edu

ftps = kts*1.687810;