function kmph = mps2kmph(mps)
%MPS2KMPH Convert speed from meters per second to kilometers per hour
%
%  kmph = MPS2KMPH(mps) convert speed from meters per second to kilometers
%   per hour.
%
%  See also MPS2FTPS, MPS2KTS, MPS2MPH, KMPH2MPS.

% Jonathan Sullivan
% Original: May 2011
% jonathan.sullivan@ll.mit.edu

kmph = mps*3.6;