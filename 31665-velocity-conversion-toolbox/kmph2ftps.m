function ftps = kmph2ftps(kmph)
%KMPH2FTPS Convert speed from kilometers per hour to feet per second
%
%  ftps = KMPH2FTPS(kmph) converts speeds from kilometers per hour to feet 
%   per second.
%
%  See also KMPH2KTS, KMPH2MPH, KMPH2MPS, FTPS2KMPH.

% Jonathan Sullivan
% Original: May 2011
% jonathan.sullivan@ll.mit.edu

ftps = kmph/1.09728;