function y = sgn(x)
%SGN   Modified signum function.
%   For each element of X, SIGN(X) returns 1 if the element
%   is greater than or equal to zero, and -1 if it is
%   less than zero.
%
%   See also SIGN.
%
%   Author: Nabin Sharma
%   Date: 2009/03/15

y = (x>=0) + (-1)*(x<0);