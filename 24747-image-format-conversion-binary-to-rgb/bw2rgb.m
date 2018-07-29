% 07/15/2009, bw2rgb
%
% bw2rgb reformats a binary (black and white) image into a true
%    color RGB image
% 
% Note: requires Image Processing Toolbox
% 
%    Color Conversion
%    Binary     RGB
%    0          [0 0 0]
%    1          [255 255 255]
% 
%    bw2rgb(bwPic) converts a binary image to a black and white
%       image in true color RGB format
%
%	 bwPic --> binary image (e.g. bwImage)
%
%    example: rgbImage = bw2rgb(bwImage);


function rgbPic = bw2rgb(bwPic)

bwPicSize = size(bwPic);

rgbPic = zeros(bwPicSize(1),bwPicSize(2),3);

rgbPic(bwPic==1)=255;
rgbPic(:,:,2) = rgbPic(:,:,1);
rgbPic(:,:,3) = rgbPic(:,:,1);

rgbPic = im2uint8(rgbPic);