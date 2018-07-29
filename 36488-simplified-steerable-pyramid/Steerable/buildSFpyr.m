function [coeff] = buildSFpyr(im, ht)
% Steerable pyramid in frequency domain
% Input:
%       im:     input image
%       ht:     height of the pyramid
%
% Output:
%    coeff:     the steerable pyramid

% Parameters
nbands = 4;

% Create the initial high pass and low pass filter
[m,n]=size(im);
[log_rad,angle]=base(m,n);

[Xrcos,Yrcos] = rcosFn(1,-1/2);
Yrcos = sqrt(Yrcos);
YIrcos = sqrt(1.0 - Yrcos.^2);

lo0mask = pointOp(log_rad, YIrcos, Xrcos);
hi0mask = pointOp(log_rad, Yrcos, Xrcos);

% Perform filtering recursively
imdft = fftshift(fft2(im));
lo0dft =  imdft .* lo0mask;

[temp] = buildSFpyrLevs(lo0dft, log_rad, angle, Xrcos, Yrcos, ht-1, nbands);

% High pass residue
hi0dft =  imdft .* hi0mask;
hi0 = ifft2(ifftshift(hi0dft));

% Put together in the cell output
coeff = [{real(hi0)} temp];

