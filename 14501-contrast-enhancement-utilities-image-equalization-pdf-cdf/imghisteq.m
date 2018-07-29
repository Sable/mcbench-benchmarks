function ieqhist = imghisteq(img)
% Author: Javier Montoya (jmontoyaz@gmail.com).
%         http://www.lis.ic.unicamp.br/~jmontoya
%
% IMGHISTEQ equalizes the histogram of image I.
% Input parameters:
%    img: image I (passed as a bidimensional matrix).
% Ouput parameters:
%    eqhist: equalized histogram.
%
% See also: IMGCDF
%
% Usage:
%    I       = imread('tire.tif');
%    ieqhist = imghisteq(I);
%    figure; stem(ieqhist); title('Equalized Histogram');

   if exist('img', 'var') == 0
      error('Error: Specify an input image.');
   end
   
   ieqhist     = [];
   icdf        = imgcdf(img);
   [rows,cols] = size(img);
   ieqhist     = round(255*icdf/(rows*cols));
end