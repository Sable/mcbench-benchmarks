function r = sample_no_repl(n, k)
%sample_no_repl(n, k): k random samples from 1:n, without replacement.
%
% Same functionality as (part of) randsample(n, k) but can handle larger n
% without running out of memory.
%
% Returned samples are sorted.
%
% Examples:
%   r = randsample(10, 5)
%   r = randsample(1e10, 5)     % fails (on a machine with 12GB)
%   r = sample_no_repl(1e10, 5) % works
%
%   % Seems reasonably efficient for moderate numbers of samples, e.g.
%   tic; r = sample_no_repl(1e10, 1e4); T = toc, hist(r)
%
% See also: randperm, uperms, perms, perms_m, signs_m, nchoosek_m

% Copyright 2010 Ged Ridgway
% http://www.mathworks.com/matlabcentral/fileexchange/authors/27434

r = [];

% while length(r) < k
%     r = [r ceil(n*rand(1, k))];
%     r = unique(r); %%% Broken, since unique *sorts* and then the trimming
%                    %%% below knackers the high numbers...
% end
% r = r(1:k)';

% if ~exist('randi', 'builtin') % (not present in older versions of MATLAB)
%     randi = @(n) ceil(n * rand(1));
% end

while length(r) < k
    r = union(r, ceil(n * rand(1)));
end
