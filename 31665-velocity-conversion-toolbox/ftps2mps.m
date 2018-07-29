function mps = ftps2mps(ftps)
%FTPS2MPS Convert speed from feet per second to kilometers per hour
%
%  mps = FTPS2MPS(ftps) converts speeds from feet per second to meters per 
%   second.
%
%  See also FTPS2KTS, FTPS2MPH, FTPS2KMPH, MPS2FTPS.

% Jonathan Sullivan
% Original: May 2011
% jonathan.sullivan@ll.mit.edu

mps = ftps*0.3048;