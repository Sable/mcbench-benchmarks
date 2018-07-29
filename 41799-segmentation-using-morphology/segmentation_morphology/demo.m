% Segmentation by morphological closing and reconstruction

% reads in a test image containing darker circular / sort of circular regions
% Note that the background is as dark as the objects in some places
% There are larger regions of a similar grayscale to the circular objects
% Some of the objectinos are pseudo circular

% Benjamin Irving

% Test image
I=imread('recon_test.png');

% Appling the filtering
%reconfilt: 
%	Inputs: 1) Image 2) Threshold 3) Largest kernel (pixels) 4) Smallest kernel (pixels)
%	Ouput: Segmented image

[I_segmented, recon]=reconfilt(I, 0.2, 15, 22);

% Plotting output
figure(1),
subplot(2,2,1),
imagesc(recon.original)
title('Original image with varying background and foreground objects')
subplot(2,2,2),
imagesc(recon.reconstruct)
title('Reconstructed image with circular regions removed')
subplot(2,2,3),
imagesc(recon.difference)
title('Difference image between original and reconstructed')
subplot(2,2,4),
imagesc(I_segmented)
title('Segmentation')
colormap('gray')
