function LP_boundaries(f,boundaries)

%=======================================================================
% function LP_boundaries(f,boundaries)
% 
% This function plots the concentric boundaries corresponding to the 
% detected scales in the 2D spectrum.
%
% Inputs:
%   -f: input image
%   -boundaries: list of Fourier boundaries
%
% Author: Jerome Gilles - Giang Tran
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%=======================================================================
color='white';
figure;imshow(log(1+fftshift(abs(fft2(f)))),[]);
hold on;
for n=1:length(boundaries)
    a=boundaries(n)*floor(size(f,2)/(2*pi));
    b=boundaries(n)*floor(size(f,1)/(2*pi));
    drawEllipse(floor(size(f,2)/2)+1,floor(size(f,1)/2)+1,a,b,color);
end