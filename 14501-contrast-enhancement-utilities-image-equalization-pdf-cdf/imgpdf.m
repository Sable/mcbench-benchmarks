function pdfhist = imgpdf(img)
% Author: Javier Montoya (jmontoyaz@gmail.com).
%         http://www.lis.ic.unicamp.br/~jmontoya
%
% IMGPDF normalizes a given histogram ('hist').
% Input parameters:
%    img: image I (passed as a bidimensional matrix).
% Ouput parameters:
%    pdfhist: normalized histogram => pdf.
%
% See also: IMGHIST
%
% Usage:
%    I       = imread('tire.tif');
%    pdfhist = imgpdf(I);
%    figure; stem(pdfhist); title('Normalized Histogram (PDF)');

   if exist('img', 'var') == 0
      error('Error: Specify an input image.');
   end

   ihist       = imghist(img);
   [rows,cols] = size(img);
   pdfhist     = ihist/rows/cols;
end