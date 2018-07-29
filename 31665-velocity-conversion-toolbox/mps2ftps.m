function ftps = mps2ftps(mps)
%MPS2FTPS Convert speed from meters per second to feet per second
%
%  ftps = MPS2FTPS(mps) convert speed from meters per second to feet per 
%   second.
%
%  See also MPS2KMPH, MPS2KTS, MPS2MPH, FTPS2MPS.

% Jonathan Sullivan
% Original: May 2011
% jonathan.sullivan@ll.mit.edu

ftps = mps./0.3048;