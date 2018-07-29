function varargout = setsparse(varargin)
% function S = SETSPARSE(S, r, c, v)
%
% PURPOSE: a new sparse matrix after assigning S(r(:), c(:)) = v(:)
%
% SETSPARSE(..., fun)
%   where fun is a function handle: apply two-variates FUN before assign
%       the values S(k) = fun(S(k),v(k)), (k is corresponding linear-index)
%    Reverse order of input variables SETSPARSE(r, c, v, S, fun) to
%    apply function in other way around: S(k) = fun(v(k),S(k))
%
% FUN can either be a function handle in mfile or following functions:
%
%     @asgn           Assign value
%     @plus           Plus
%     @minus          Minus
%     @times          Array multiply
%     @rdivide        Right array divide
%     @ldivide        Left array divide
%     @power          Array power
%     @max            Binary maximum
%     @min            Binary minimum
%     @rem            Remainder after division
%     @mod            Modulus after division
%     @atan2	        Four-quadrant inverse tangent
%     @hypot	        Square root of sum of squares
%     @eq             Equal
%     @ne             Not equal
%     @lt             Less than
%     @le             Less than or equal
%     @gt             Greater than
%     @ge             Greater than or equal
%     @and            Element-wise logical AND
%     @or             Element-wise logical OR
%     @xor            Logical EXCLUSIVE OR
%
% Note: This function is useful for sparse because sometime a straight
% forward linear-indexing might not work for large indexes (overflow)
%
% Author Bruno Luong <brunoluong@yahoo.com>
% Last update: 05/April/2009

nout = max(nargout,1);
vout = cell(1,nout);
[vout{:}] = spsubsasgn(varargin{:});
varargout = vout;
