function mph = kmph2mph(kmph)
%KMPH2MPH Convert speed from kilometers per hour to miles per hour
%
%  mph = KMPH2MPH(kmph) converts speeds from kilometers per hour to miles 
%   per hour.
%
%  See also KMPH2KTS, KMPH2FTPS, KMPH2MPS, MPH2KMPH.

% Jonathan Sullivan
% Original: May 2011
% jonathan.sullivan@ll.mit.edu

mph = kmph/1.609344;