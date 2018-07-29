function myCtReconstruction(phantomData)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is a demo file for ct reconstruction
% written by Mark Bangert
% m.bangert@dkfz.de 2011

figure
colormap bone 

% if no image data available -> load matlab's shepp logan phantom
if ~exist('phantomData','var')
    imageResolution = 128; % increasing the resolution results in lonmger computation times...
    phantomData = phantom(imageResolution);
end
phantomData = double(phantomData - min(phantomData(:))); % set min of image to zero

% pad the image with zeros so we don't lose anything when we rotate.
padDims = ceil(norm(size(phantomData)) - size(phantomData)) + 2;
P       = padarray(phantomData,padDims);

% plot original image
subplot(2,3,1)
imagesc(P);
title('Phantom')
xlabel('X')
ylabel('Y')

% set some parameters
freq = 1; % [1/degree]
thetas = 0:1/freq:180-1/freq;

subplot(2,3,2)
% compute sinogram / radon transformation (schlegel & bille 9.1.1)
sinogram = myRadon(P,thetas);
% compute sinogram with matlab function
%sinogram = radon(P,thetas)

imagesc(sinogram);
title('Sinogram')
xlabel('\alpha')
ylabel('# parallel projection')

subplot(2,3,3)
% simple backprojection (schlegel & bille 9.1.2)
simpleBackprojection = myBackprojection(sinogram,thetas);

imagesc(simpleBackprojection);
title('Simple backprojection')
xlabel('X')
ylabel('Y')

%subplot(2,3,4)
% reconstruction with matlabs inverse radon transfromation
%matlabRecon = iradon(sinogram,thetas,'linear','Shepp-Logan'); % choose one 'Shepp-Logan' , 'Ram-Lak'
%imagesc(rot90(matlabRecon,-1));
%title('Filtered backprojection with Matlab')
%xlabel('X')
%ylabel('Y')

subplot(2,3,4)
% reconstruction with filtered back projection in spatial domain (schlegel
% & bille 9.3.1)
reconstruction1DFTSpatialDomain = myFilteredBackprojectionSpatialDomain(sinogram,thetas);

imagesc(reconstruction1DFTSpatialDomain);
title('Filtered backprojection using convolution in spatial domain')
xlabel('X')
ylabel('Y')

subplot(2,3,5)
% reconstruction with 2D fourier transformation (schlegel & bille 9.2.1)
% note that this function uses the backprojection of the sinogram as input
% and _not_ the sinogram
reconstrution2DFT = myFilteredBackprojection2DFT(simpleBackprojection);

imagesc(reconstrution2DFT);
title('Filtered backprojection using 2D FFT')
xlabel('X')
ylabel('Y')

subplot(2,3,6)
% reconstruction with backprojection using 1D fourier transformations 
% and central slice theorem (schlegel & bille 9.2.3)
reconstrution1DFT = myFilteredBackprojectionCentralSlice(sinogram,thetas);

imagesc(reconstrution1DFT);
title('Filtered backprojection using central slice theorem')
xlabel('X')
ylabel('Y')


