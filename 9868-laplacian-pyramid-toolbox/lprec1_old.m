function x = lprec1_old(c, d, h, g, extmod)
% LPREC1_OLD   Laplacian pyramid reconstruction using the old method
%
%	x = lprec1_old(c, d, h, g)
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
% See also:	LPDEC1

if ~exist('extmod', 'var')
    extmod = 'per';
end

nd = ndims(c);

% Even size filter needs to be adjusted to obtain perfect reconstruction
adjust = mod(length(g) + 1, 2); 

% Upsample and filter the coarse signal
p = c;
for dim = 1:nd
    p = upfilt(p, g, dim, extmod, adjust);
end

% Add with the detail signal
x = p + d;