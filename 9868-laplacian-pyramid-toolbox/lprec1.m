function x = lprec1(c, d, h, g, extmod)
% LPREC1   One-level Laplacian pyramid reconstruction
%
%	x = lprec1(c, d, h, g)
%
% Input:
%   c:      coarse signal at half size
%   d:      detail signal at full size
%   h, g:   two biorthogonal 1-D lowpass filters
%   extmod: [optional] extension mode (default is 'per')
%
% Output:
%   x:      reconstructed signal
%
% Note:     This uses a new reconstruction method by Do and Vetterli,
%           "Framming pyramids", IEEE Trans. on Sig Proc., Sep. 2003.
%
% See also:	LPDEC1

if ~exist('extmod', 'var')
    extmod = 'per';
end

nd = ndims(c);

% First, filter and downsample the detail image
r = d;
for dim = 1:nd
    r = filtdn(r, h, dim, extmod, 0);
end

% Then subtract the result from the coarse signal
p = c - r;

% Even size filter needs to be adjusted to obtain perfect reconstruction
adjust = mod(length(g) + 1, 2); 

% Then upsample and filter
for dim = 1:nd
    p = upfilt(p, g, dim, extmod, adjust);
end

% Final combination
x = p + d;