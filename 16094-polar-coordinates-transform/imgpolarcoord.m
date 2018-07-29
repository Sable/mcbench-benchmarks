function pcimg=imgpolarcoord(img,radius,angle)
% IMGPOLARCOORD converts a given image from cartesian coordinates to polar
% coordinates.
%
% Input:
%        img  : bidimensional image.
%      radius : radius length (# of pixels to be considered).
%      angle  : # of angles to be considered for decomposition.
%
% Output:
%       pcimg : polar coordinate image.
%
% Usage Example:
%  im=double(imread('cameraman.tif'));
%  fim=fft2(im);
%  pcimg=iapolarcoord(im);
%  fpcimg=iapolarcoord(fim);
%  figure; subplot(2,2,1); imagesc(im); colormap gray; axis image;
%  title('Input image');  subplot(2,2,2);
%  imagesc(log(abs(fftshift(fim)+1)));  colormap gray; axis image;
%  title('FFT');subplot(2,2,3); imagesc(pcimg); colormap gray; axis image;
%  title('Polar Input image');  subplot(2,2,4);
%  imagesc(log(abs(fpcimg)+1));  colormap gray; axis image;
%  title('Polar FFT');
%
% Notes:
%  The software is provided "as is", without warranty of any kind.
%  Javier Montoya would like to thank prof. Juan Carlos Gutierrez for his
%  support and suggestions, while studying polar-coordinates.
%  Authors: Juan Carlos Gutierrez & Javier Montoya.

   if nargin < 1
      error('Please specify an image!');
   end
   
   img         = double(img);
   [rows,cols] = size(img);
   cy          = round(rows/2);
   cx          = round(cols/2);
   
   if exist('radius','var') == 0
      radius = min(round(rows/2),round(cols/2))-1;
   end
   
   if exist('angle','var') == 0
      angle = 360;
   end
  
   pcimg = [];
   i     = 1;
   
   for r=0:radius
      j = 1;
      for a=0:2*pi/angle:2*pi-2*pi/angle
         pcimg(i,j) = img(cy+round(r*sin(a)),cx+round(r*cos(a)));
         j = j + 1;
      end
      i = i + 1;
   end
end