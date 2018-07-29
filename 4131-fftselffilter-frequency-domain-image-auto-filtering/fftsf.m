function ImgOut = fftsf(ImgIn,degree)
% FFTSF Frequency domain auto filtering (enhances powerfull frequencies)
%
% Input :	ImgIn  - grayscale image
%             degree - emphasis given to regular patterns
%                    values: 1, 2, 3, {4} (default)
% 
%                     Filtering    |   soft    strong
%                     ------------------------------
%                     emphasis     |   1       2
%                     attenuation  |   3       4
%
% Output: class double data
% Display:
% 
% im = imread('kb818c.jpg');
% figure
% subplot(2,3,2)
% imshow(im,[])
% title('Input')
% subplot(2,3,3)
% imshow(fftsf(im,1),[])
% title('1. Soft emphazis')
% subplot(2,3,6)
% imshow(fftsf(im,2),[])
% title('2. Strong emphazis')
% subplot(2,3,5)
% title([{'Self-filtering'},{'emphasizes or attenuates'},{'regular patterns'}])
% axis off
% subplot(2,3,1)
% imshow(fftsf(im,3),[])
% title('3. Soft attenuation')
% subplot(2,3,4)
% imshow(fftsf(im,4),[])
% title('4. Strong attenuation')
%
% Proceedure: The most powerfull frequencies in an image are enhanced /
%   attenuated by multiplying / dividing the complex FFT signal with the 
%   magnitude of the same FFT.
%
% Reference: This code is based on the technique described in:
%   D.G. Bailey - Detecting regular patterns using frequency domain
%   self-filtering, 1997 Intl. Conf. on Image Processing, 1:440-3.
%
% Written by Vlad Atanasiu 2003.09.25
% 2008.11.07 - modified sample code
% 2007.07.07 - added new magnitude enhancement options
%            - removed bug in 'switch'
%            - changed name from 'fftselffilter' to 'fftsf' (is shorter)

F = fft2(double(ImgIn));	% FFT
R = abs(F);                     % magnitude
Z = angle(F);                   % phase
switch degree                  % filtering
case(2)
    F2 = F.*R.*sqrt(R.^2+Z.^2);
case(3)
    R = R + eps;
    F2 = sqrt(R).*exp(i*Z);
case(4)
    R = R + eps;
    F2 = F./R;
otherwise
    F2 = F.*R;
end
ImgOut = real(ifft2(F2));		% filtered image

