function icdf = imgcdf(img)
% Author: Javier Montoya (jmontoyaz@gmail.com).
%         http://www.lis.ic.unicamp.br/~jmontoya
%
% IMGCDF calculates the Cumulative Distribution Function of image I.
% Input parameters:
%    img: image I (passed as a bidimensional matrix).
% Ouput parameters:
%    icdf: cumulative distribution function.
%
% See also: IMGHIST
%
% Usage:
%    I    = imread('tire.tif');
%    icdf = imgcdf(I);
%    figure; stem(icdf); title('Cumulative Distribution Function (CDF)');

   if exist('img', 'var') == 0
      error('Error: Specify an input image.');
   end
   
   icdf    = [];
   ihist   = imghist(img);
   maxgval = 255;
   icdf    = zeros(1,maxgval);
   
   icdf(1)= ihist(1);
   for i=2:1:maxgval+1
      icdf(i) = ihist(i) + icdf(i-1);
   end
end
