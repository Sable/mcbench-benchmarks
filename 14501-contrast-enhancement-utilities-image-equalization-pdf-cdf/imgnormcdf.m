function icdfnorm = imgnormcdf(img)
% Author: Javier Montoya (jmontoyaz@gmail.com).
%         http://www.lis.ic.unicamp.br/~jmontoya
%
% IMGNORMPDF normalizes the CDF of image I.
% Input parameters:
%    img: image I (passed as a bidimensional matrix).
% Ouput parameters:
%    icdfnorm: normalized cdf
%
% See also: IMGCDF
%
% Usage:
%    I        = imread('tire.tif');
%    icdfnorm = imgnormcdf(I);
%    figure; stem(icdfnorm); title('Normalized CDF');

   if exist('img', 'var') == 0
      error('Error: Specify an input image.');
   end
   
   icdfnorm    = [];
   [rows,cols] = size(img);
   icdf        = imgcdf(img);
   icdfnorm    = icdf/rows/cols;
end