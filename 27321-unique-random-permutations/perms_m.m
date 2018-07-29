function p = perms_m(n, m)
%perms_m(n, m): return the mth permutation of the digits 1:n
% where m is from 0 to factorial(n) - 1
%
% The ordering is fairly arbitrary, but there is a bijection between m to
% the n! permutations (asking for same m twice gets same permutation), and
% perms_m(n, 0) is 1:n in order.
%
% Example:
%   p = perms(1:4);
%   P = zeros(size(p));
%   for i = 1:size(P,1)
%       P(i, :) = perms_m(4, i-1)';
%   end
%   all(all(sortrows(P) == sortrows(p)))
%
% See also: perms, randperm, uperms, signs_m, nchoosek_m, sample_no_repl

% Copyright 2010 Ged Ridgway
% http://www.mathworks.com/matlabcentral/fileexchange/authors/27434
 
n = ceil(abs(n)); m = round(abs(m));

M = factorial(n) - 1; % max m
if m < 0 || m > M
    error('perms_m:m_range', 'Require 0 <= m <= %d', M);
end

p = zeros(n,1);
d = 1:n;
F = factorial(n); % (F in loop goes from factorial(n-1) to factorial(0))
for f = 1:n
    F = F / (n + 1 - f); % (here rather than end of loop to avoid div-by-0)
    x = floor(m / F);
    p(f) = d(f + x);
    d(f + x) = d(f);
    m = rem(m, F);
end
