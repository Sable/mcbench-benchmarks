function kts = ftps2kts(ftps)
%FTPS2KTS Convert speed from feet per second to knots
%
%  kts = FTPS2KTS(ftps) converts speeds from feet per second to knots.
%
%  See also FTPS2KMPH, FTPS2MPH, FTPS2MPS, KTS2FTPS.

% Jonathan Sullivan
% Original: May 2011
% jonathan.sullivan@ll.mit.edu

kts = ftps*1.687810;