function y = vec2lp(c, s)
% VEC2LP   Convert the vector output back to the LP cell array form
%
%       y = vec2lp(c, s)
%
% Input:
%   c:  a column vector that contains all LP coefficients
%   s:  size vectors of each LP output layer, one per row
%
% Output:
%   y:  an output of LPD
%
% See also:     LPR, LP2VEC

n = size(s, 1);
y = cell(1, n);

ind = 0;
for l = 1:n
    nc = prod(s(l,:));
    y{l} = reshape(c(ind+1:ind+nc), s(l,:));
    ind = ind + nc;
end