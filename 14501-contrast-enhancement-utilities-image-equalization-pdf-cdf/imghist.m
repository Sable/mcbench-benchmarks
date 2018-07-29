function ihist = imghist(img)
% Author: Javier Montoya (jmontoyaz@gmail.com).
%         http://www.lis.ic.unicamp.br/~jmontoya
%
% IMGHIST calculates the histogram of a given image.
% Input parameters:
%    img: image I (passed as a bidimensional matrix).
% Ouput parameters:
%    ihist: histogram.
%
% Usage:
%    I     = imread('tire.tif');
%    ihist = imghist(I);
%    figure; stem(ihist); title('Image Histogram');

   if exist('img', 'var') == 0
      error('Error: Specify an input image.');
   end

   ihist       = [];
   [rows,cols] = size(img);
   maxgval     = 255;
   ihist       = zeros(1,maxgval);

   for i=0:maxgval
      ihist(i+1) = sum(img(:)==i);
   end
end