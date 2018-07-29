function mps = mph2mps(mph)
%MPH2MPS Convert speed from miles per hour to meters per second
%
%  mps = MPH2MPS(mph) convert speeds from miles per hour to meters per 
%   second.
%
%  See also MPH2KMPH, MPH2FTPS, MPH2KTS, MPS2MPH.

% Jonathan Sullivan
% Original: May 2011
% jonathan.sullivan@ll.mit.edu

mps = mph*0.44704;