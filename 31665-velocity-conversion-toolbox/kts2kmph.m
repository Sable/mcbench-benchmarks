function kmph = kts2kmph(kts)
%KTS2KMPH Convert speed from knots to kilometers per hour
%
%  mph = KTS2KMPH(kts) convert speeds from knots to kilometers per hour.
%
%  See also KTS2MPH, KTS2FTPS, KTS2MPS, KMPH2KTS.

% Jonathan Sullivan
% Original: May 2011
% jonathan.sullivan@ll.mit.edu

kmph = kts*1.852;