function n = SHl2n(l)

% n = SHl2n(l)
%
% For given real spherical harmonic coefficient degree l compute
% the number of spherical harmonic coefficients up to and including
% degree l. Identical to SHlm2n(l,-l)

if l<0
    error('invalid usage: l has to be a non-negative integer');
end

k=0:l;

n = sum(2*k+1);
