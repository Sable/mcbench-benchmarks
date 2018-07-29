function A = colon(varargin)
% overload Matlab built-in colon with mcolon
% A = colon(varargin)
% Author: Bruno Luong <brunoluong@yahoo.com>

A = mcolon(varargin{:});
