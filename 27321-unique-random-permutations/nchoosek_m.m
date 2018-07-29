function comb = nchoosek_m(n, k, m)
%nchoosek_m: efficiently compute the mth combination of nchoosek(1:n, k)
% comb = nchoosek_m(n, k, m)
%
% Examples:
%  first = nchoosek_m(10, 4, 1) % the "first" combination: [1 2 3 4]
%  last  = nchoosek_m(10, 4, nchoosek(10,4)) % the "final" comb: [7 8 9 10]
%  M = nchoosek(10, 4); rnd = nchoosek_m(10, 4, randi(M)); % random comb
%
% Motivation: nchoosek_m can be used to sample a few m with any k from
% n up to 53, easily ensuring no duplicates are sampled. In contrast,
% nchoosek(1:n, k) becomes time and memory expensive for n over about 30,
% e.g. combs = nchoosek(32, 16) takes over 2GB of memory.
%
% Note: this function is not reliable for n > 53. For speed reasons, this
% eventuality is not even checked, so be careful!
%
% See also: nchoosek, uperms, perms_m, signs_m, sample_no_repl

% Copyright 2010 Ged Ridgway
% http://www.mathworks.com/matlabcentral/fileexchange/authors/27434

comb = zeros(1, k);
i = 1; % ith element of requested comb
for c = 1:n % candidate for ith element (combs ordered lowest first)
    M = nchoosek_fast(n - c, k - i); % number of combs of higher elements
    if m <= M % are we within the set of combs starting with this c?
        comb(i) = c;
        i = i + 1;
        if i > k; return; end
    else
        m = m - M;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nck = nchoosek_fast(n, k)
%nchoosek_fast -- faster alternative to MATLAB version (no input checks)
nck = round(prod( (1+n-k:n) ./ (1:k) ));
