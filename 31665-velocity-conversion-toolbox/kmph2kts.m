function kts = kmph2kts(kmph)
%KMPH2KTS Convert speed from kilometers per hour to knots
%
%  kts = KMPH2KTS(kmph) converts speeds from kilometers per hour to knots.
%
%  See also KMPH2FTPS, KMPH2MPH, KMPH2MPS, KTS2KMPH.

% Jonathan Sullivan
% Original: May 2011
% jonathan.sullivan@ll.mit.edu

kts = kmph/1.852;