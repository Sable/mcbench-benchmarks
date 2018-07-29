function varargout = getsparse(varargin)
% function v = GETSPARSE(S, r, c)
%
% PURPOSE: return v(:) = S(r(:), c(:)) for sparse matrix
%
% Note: This function is useful for sparse because sometime a straight
% forward linear-indexing might not work for large indexes (overflow)
% 
% Author Bruno Luong <brunoluong@yahoo.com>
% Last update: 05/April/2009

nout = max(nargout,1);
vout = cell(1,nout);
[vout{:}] = spsubsref(varargin{:});
varargout = vout;