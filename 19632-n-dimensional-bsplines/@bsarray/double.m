function c = double(b)
% bsarray/double: convert bsarray object to coefficient array
% usage: c = double(b)
%
% arguments: 
%   b - bsarray object
% 
%   c - array of bspline coefficients

% author: Nathan D. Cahill
% email: ndcahill@gmail.com
% date: 18 April 2008

c = b.coeffs;