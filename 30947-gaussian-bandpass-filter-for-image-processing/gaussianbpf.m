
function filtered_image = gaussianbpf(I,d0,d1)
% Butterworth Bandpass Filter
% This simple  function was written for my Digital Image Processing course
% at Eastern Mediterranean University taught by
% Assoc. Prof. Dr. Hasan Demirel
% for the 2010-2011 Spring Semester
% for the complete report:
% http://www.scribd.com/doc/51981950/HW4-Frequency-Domain-Bandpass-Filtering
%
% Written By:
% Leonardo O. Iheme (leonardo.iheme@cc.emu.edu.tr)
% 24th of March 2011
%
%   I = The input grey scale image
%   d0 = Lower cut off frequency
%   d1 = Higher cut off frequency
%
% The function makes use of the simple principle that a bandpass filter
% can be obtained by multiplying a lowpass filter with a highpass filter
% where the lowpass filter has a higher cut off frquency than the high pass filter.
%
% Usage GAUSSIANBPF(I,DO,D1)
% Example
% ima = imread('grass.jpg');
% ima = rgb2gray(ima);
% filtered_image = gaussianbpf(ima,30,120);
% Gaussian Bandpass Filter


f = double(I);
[nx ny] = size(f);
f = uint8(f);
fftI = fft2(f,2*nx-1,2*ny-1);
fftI = fftshift(fftI);

subplot(2,2,1)
imshow(f,[]);
title('Original Image')

subplot(2,2,2)
fftshow(fftI,'log')
title('Fourier Spectrum of Image')
% Initialize filter.
filter1 = ones(2*nx-1,2*ny-1);
filter2 = ones(2*nx-1,2*ny-1);
filter3 = ones(2*nx-1,2*ny-1);

for i = 1:2*nx-1
    for j =1:2*ny-1
        dist = ((i-(nx+1))^2 + (j-(ny+1))^2)^.5;
        % Use Gaussian filter.
        filter1(i,j) = exp(-dist^2/(2*d1^2));
        filter2(i,j) = exp(-dist^2/(2*d0^2));
        filter3(i,j) = 1.0 - filter2(i,j);
        filter3(i,j) = filter1(i,j).*filter3(i,j);
    end
end
% Update image with passed frequencies
filtered_image = fftI + filter3.*fftI;

subplot(2,2,3)
fftshow(filter3,'log')
title('Frequency Domain Filter Function Image')
filtered_image = ifftshift(filtered_image);
filtered_image = ifft2(filtered_image,2*nx-1,2*ny-1);
filtered_image = real(filtered_image(1:nx,1:ny));
filtered_image = uint8(filtered_image);

subplot(2,2,4)
imshow(filtered_image,[])
title('Bandpass Filtered Image')