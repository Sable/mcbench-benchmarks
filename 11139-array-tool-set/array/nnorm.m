%
% y = nnorm(x,dim,p)
%
% NNORM calculates the p-vector norms of the component vectors of array <x>
% along dimension <dim>.
%
% dim: dimension along which to calculate norm.  Default first nonsingleton
%   p: norm-type.  Default is 2.
%
% See also NORM

% Created by Bill Winter December 2005
% Based on concept of norm.m
function x = nnorm(x,dim,p)
siz = size(x);
if nargin < 2, dim = find(siz > 1,1); end
if nargin < 3, p = 2; end
switch p
    case inf,   x = max(x,[],dim);              % max
    case -inf,  x = min(x,[],dim);              % min
    case 1,     x = sum(abs(x),dim);            % manhattan
    case 2,     x = sqrt(sum(abs(x).^2,dim));   % euclidean
    otherwise,  x = sum(abs(x).^p,dim).^(1/p);  % p-norm
end