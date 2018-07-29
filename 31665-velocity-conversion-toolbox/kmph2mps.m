function mps = kmph2mps(kmph)
%KMPH2MPS Convert speed from kilometers per hour to meters per second
%
%  mps = KMPH2MPS(kmph) converts speeds from kilometers per hour to meters 
%   per second.
%
%  See also KMPH2KTS, KMPH2FTPS, KMPH2MPH, MPS2KMPH.

% Jonathan Sullivan
% Original: May 2011
% jonathan.sullivan@ll.mit.edu

mps = kmph/3.6;