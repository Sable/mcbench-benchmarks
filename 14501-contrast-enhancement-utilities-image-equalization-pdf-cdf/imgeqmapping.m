function ieq = imgeqmapping(img)
% Author: Javier Montoya (jmontoyaz@gmail.com).
%         http://www.lis.ic.unicamp.br/~jmontoya
%
% IMGEQMAPPING enhances the contrast of 'img' by using its equalized
% histogram.
% Input parameters:
%    img: image I (passed as a bidimensional matrix).
% Ouput parameters:
%    ieq: enhanced image.
%
% See also: IMGHISTEQ
%
% Usage:
%    I = imread('tire.tif');
%    J = imgeqmapping(I);
%    figure; imagesc(I); colormap('gray'); axis image; title('Input image');
%    figure; imagesc(J); colormap('gray'); axis image; title('Equalized image');

   ieqhist     = imghisteq(img);
   [rows,cols] = size(img);
   ieq         = zeros(rows, cols);
   
   for i=1:1:rows
       for j=1:1:cols
           pxval    = img(i,j)+1;
           ieq(i,j) = ieqhist(pxval)-1;
       end
   end
end