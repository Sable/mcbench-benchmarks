function reconstrution2DFT = myFilteredBackprojection2DFT(backprojection)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reconstruction with 2D fourier transformation -> schlegel & bille 9.2.1
% written by Mark Bangert
% m.bangert@dkfz.de 2011
%
% note: a) this function uses the back prjection as input _not_ the sinogram
%       b) matlab puts the 0 frequency component of a fourier spectrum _not_
%          in the middle. we need to fumble around with fftshift.


% find the middle index of the projections
midindex = floor(size(backprojection,1)/2) + 1;

% prepare filter for frequency domain without normalization
[xCoords,yCoords] = meshgrid(1 - midindex:size(backprojection,1) - midindex);
rampFilter2D      = sqrt(xCoords.^2 + yCoords.^2);

% 2 D Fourier transformation and sorting
reconstrution2DFT = fftshift(fft2(backprojection));

% Filter in Freq Domain
reconstrution2DFT = reconstrution2DFT .* rampFilter2D;

% inverse 2 D fourier transformation and sorting
reconstrution2DFT = real( ifft2( ifftshift(reconstrution2DFT) ) );

