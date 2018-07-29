function ftps = mph2ftps(mph)
%MPH2FTPS Convert speed from miles per hour to feet per second
%
%  ftps = MPH2FTPS(mph) convert speeds from miles per hour to feet per
%   second.
%
%  See also MPH2KMPH, MPH2KTS, MPH2MPS, FTPS2MPH.

% Jonathan Sullivan
% Original: May 2011
% jonathan.sullivan@ll.mit.edu

ftps = mph*1.46666666667;