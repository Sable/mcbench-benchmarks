function tf = isinteger(x)
%ISINTEGER returns TRUE if X is a legal integer.
%
%   Legal integer types include:
%       INT8, UINT8, INT16, UINT16, INT32, UINT32, INT64, UINT64

% Copyright 2004-2010 The MathWorks, Inc.

error(nargchk(1,1,nargin))
error(nargchk(0,1,nargout))

switch class(x)
  case {'int8','uint8','int16','uint16','int32','uint32','int64','uint64'}
    tf=true;
  otherwise
    tf=false;
end
