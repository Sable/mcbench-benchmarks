function mps = kts2mps(kts)
%KTS2MPS Convert speed from knots to meters per second
%
%  mps = KTS2MPS(kts) convert speeds from knots to meters per second.
%
%  See also KTS2MPH, KTS2FTPS, KTS2KMPH, MPS2KTS.

% Jonathan Sullivan
% Original: May 2011
% jonathan.sullivan@ll.mit.edu

mps = kts*0.514444444444444;