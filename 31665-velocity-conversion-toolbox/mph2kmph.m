function kmph = mph2kmph(mph)
%MPH2KMPH Convert speed from miles per hour to kilometers per hour
%
%  kmph = MPH2KMPH(mph) convert speeds from miles per hour to kilometers
%   per hour.
%
%  See also FTPS2KMPH, MPH2KTS, MPH2MPS, KMPH2MPH.

% Jonathan Sullivan
% Original: May 2011
% jonathan.sullivan@ll.mit.edu

kmph = mph*1.609344;