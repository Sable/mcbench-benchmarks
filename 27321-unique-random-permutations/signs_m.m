function s = signs_m(n, m)
%signs_m(n, m): return the mth unique set of an n-vector of +/- signs
% essentially the mth binary number from 0 to 2^n-1 with 1 = -, 0 = +
% n >= ceil(log2(m+1)) and defaults to equality.
% Note that sign-convention is chosen so that  signs_m(n, 0) == ones(n, 1)
% Note also signs_m(n, m) == -signs(n, 2^n - 1 - m) for all n and m
%
% Example:
%   s = signs_m(4, 10)'
%   b = dec2bin(10)
%
% See also: perms, randperm, uperms, perms_m, nchoosek_m, sample_no_repl

% Copyright 2010 Ged Ridgway
% http://www.mathworks.com/matlabcentral/fileexchange/authors/27434

N = ceil(log2(m+1));
if ~exist('n','var')
    n = N;
elseif n < N
    warning('signs_m:digits', '%d digits requested, but must use %d', n, N)
    n = N;
else
    n = round(n);
end

s = zeros(n,1);

i = n; % low end
while m >= 1
    if rem(m, 2)
        s(i) = 1;
    end
    m = floor(m / 2);
    i = i - 1;
end

s = 1 - 2*s;
