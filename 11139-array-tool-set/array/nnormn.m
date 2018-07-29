%
% y = nnormn(x,dim,p)
%
% NNORMN normalizes an array x by its p-vector norms along dimension <dim>.
%
% dim: dimension along which to calculate norm.  Default first nonsingleton
%   p: norm-type.  Default is 2.
%
% Equivalence: normc(x) == nnormn(x,1,2), normr(x) == nnormn(x,2,2)
%
% See also NORMC, NORMR, NNORM

% Created by Bill Winter December 2005
% Based on normc and normr
function x = nnormn(x,dim,p)
siz = size(x);
if nargin < 2, dim = find(siz > 1,1); end
if nargin < 3, p = 2; end
switch p
    case inf,   a = max(x,[],dim);              % max
    case -inf,  a = min(x,[],dim);              % min
    case 1,     a = sum(abs(x),dim);            % manhattan
    case 2,     a = sqrt(sum(abs(x).^2,dim));   % euclidean
    otherwise,  a = sum(abs(x).^p,dim).^(1/p);  % p-norm
end
a(a == 0) = 1;
N(1:length(siz)) = {':'};
N{dim} = ones(1,siz(dim));
x = x./a(N{:});