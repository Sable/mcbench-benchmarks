function out = reconSFpyr(coeff)
% Reconstruct from steerable pyramid using frequency domain
% Input:
%    coeff:     the steerable pyramid
%
% Output:
%      out:     original image

nbands = length(coeff{2});

% ======================== Create lo0 and hi0 mask ==============================

% Create the initial high pass and low pass filter
[m,n]=size(coeff{1});
[log_rad,angle]=base(m,n);

[Xrcos,Yrcos] = rcosFn(1,-1/2);
Yrcos = sqrt(Yrcos);
YIrcos = sqrt(abs(1.0 - Yrcos.^2));

lo0mask = pointOp(log_rad, YIrcos, Xrcos);
hi0mask = pointOp(log_rad, Yrcos, Xrcos);


% Recursive function
tempdft = reconSFpyrLevs(coeff(2:length(coeff)),log_rad, Xrcos, Yrcos, angle, nbands);

% Highpass residue
hidft = fftshift(fft2(coeff{1}));

outdft = tempdft .* lo0mask + hidft .* hi0mask;

%Final result
out = real(ifft2(ifftshift(outdft)));
