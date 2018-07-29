function [c, d] = lpdec1(x, h, g, extmod)
% LPDEC1   One-level Laplacian pyramid decomposition
%
%	[c, d] = lpdec1(x, h, g)
%
% Input:
%   x:      input signal
%   h, g:   two biorthogonal 1-D lowpass filters
%   extmod: [optional] extension mode (default is 'per')
%
% Output:
%   c:      coarse signal at half size
%   d:      detail signal at full size
%
% See also:	LPREC1

if ~exist('extmod', 'var')
    extmod = 'per';
end

nd = ndims(x);

% Computer the coarse signal by filter and downsample
c = x;
for dim = 1:nd
    c = filtdn(c, h, dim, extmod, 0);
end
    
% Compute the detail signal by upsample, filter, and subtract
% Even size filter needs to be adjusted to obtain perfect reconstruction
adjust = mod(length(g) + 1, 2);

p = c;
for dim = 1:nd
    p = upfilt(p, g, dim, extmod, adjust);
end

d = x - p;