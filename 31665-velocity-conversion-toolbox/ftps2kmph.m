function kmph = ftps2kmph(ftps)
%FTPS2KMPH Convert speed from feet per second to kilometers per hour
%
%  kmph = FTPS2KMPH(ftps) converts speeds from feet per second to 
%   kilometers per hour.
%
%  See also FTPS2KTS, FTPS2MPH, FTPS2MPS, KMPH2FTPS.

% Jonathan Sullivan
% Original: May 2011
% jonathan.sullivan@ll.mit.edu

kmph = ftps*1.09728;