function y=logb(x,b)
% Copyright 2007 The MathWorks, Inc.
% logb: Calculates the logarithm of x to user-specified base b.
%
% USAGE: y = logb(x,b)
%
% (A trivial but useful function for arbitrary-base log calculations.)
%
% Arguments:
% Y: the base 'b' logarithm of input x
% B: The base of the logarithmic calculation (default, e).
%    Note that if B is non-scalar, it must be the same size as X. In that
%    case, the log transformation will be element-by-element.
%
% Examples:
% 1) To calculate the base 5 logarithm of 3:
% y = logb(3,5)
%
% 2) To calculate element-wise the log of a non-scalar input using
%    different bases:
% y = logb(magic(3),[1 2 3; 4 5 6; 7 8 9]);
%
% See also: log, log10, log2

% Brett Shoelson
% brett.shoelson@mathworks.com
% 05/03/07

if nargin < 2
    b = exp(1);
end

if ~isscalar(b) && ~ all(size(x)==size(b))
        error('LOGB: Base B must be a scalar, or must be the same size as X.');
end

y = log(x)./log(b);