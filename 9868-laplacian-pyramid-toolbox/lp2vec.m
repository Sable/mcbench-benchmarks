function [c, s] = lp2vec(y)
% LP2VEC   Convert the output of the LP into a vector form
%
%       [c, s] = lp2vec(y)
%
% Input:
%   y:  an output of LPD
%
% Output:
%   c:  a column vector that contains all LP coefficients
%   s:  size vectors of each LP output layer, one per row
%
% See also:     LPD, VEC2LP

n = length(y);
s = zeros(n, ndims(y{1}));

% Save the sizes of cells of y into s
for l = 1:n
    s(l, :) = size(y{l});
end

% Flatten each layer of the LP into a vector and concatenate them
ind = 0;
c = zeros(sum(prod(s, 2)), 1);

for l = 1:n
    nc = prod(size(y{l}));
    c(ind+1:ind+nc) = y{l}(:);
    ind = ind + nc;
end