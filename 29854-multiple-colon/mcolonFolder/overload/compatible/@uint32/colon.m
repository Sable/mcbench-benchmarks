function A = colon(varargin)
% overload Matlab built-in colon with mcolon
% A = colon(varargin)
% MATLB compatible when using with scalar inputs
% Author: Bruno Luong <brunoluong@yahoo.com>

if isscalar(varargin{1})
    A = builtin('colon', varargin{:});
else
    A = mcolon(varargin{:});
end