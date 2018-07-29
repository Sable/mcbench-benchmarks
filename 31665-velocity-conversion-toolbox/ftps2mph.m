function mph = ftps2mph(ftps)
%FTPS2MPH Convert speed from feet per second to miles per hour
%
%  mph = FTPS2MPH(fts) converts speeds from feet per second to miles per
%   hour.
%
%  See also FTPS2KTS, FTPS2kMPH, FTPS2MPS, MPH2FTPS.

% Jonathan Sullivan
% Original: May 2011
% jonathan.sullivan@ll.mit.edu

mph = ftps/1.46666666667;