% bwt_test.m
%
% Test BWT code
% Version 1.2
%
% Citation:
%  Willmore B, Prenger RJ, Wu MC and Gallant JL (2008). The Berkeley 
%  Wavelet Transform: A biologically-inspired orthogonal wavelet transform.
%  Neural Computation 20:6, 1537-1564 
%
% The manuscript is available at:
%  <http://dx.doi.org/10.1162/neco.2007.05-07-513>
%
% Copyright (c) 2008 Ben Willmore
%
% Permission is hereby granted, free of charge, to any person
% obtaining a copy of this software and associated documentation
% files (the "Software"), to deal in the Software without
% restriction, including without limitation the rights to use,
% copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the
% Software is furnished to do so, subject to the following
% conditions:
% 
% The above copyright notice and this permission notice shall be
% included in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
% OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
% HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
% WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
% OTHER DEALINGS IN THE SOFTWARE.

im = [];
name = input('Input the variable name or filename of a test image: ','s');
if exist(name,'var')
  disp('Found variable');
  im = eval(name);
else
  try
    im = imread(name);
  catch
    disp('Name was not found as a variable or file');
    return;
  end
  disp('Found file');
end

% Convert to double precision, black-and-white, square, and 
% downsample to nearest power of 3
im = double(im);
im = mean(im,3);
sz = min(size(im));
im = im(1:sz,1:sz);
newsz = 3^floor(log(sz)/log(3));
im = imresize(im,newsz/sz);

tic;
disp('Performing BWT decomposition...');
imbwt = bwt(im);
toc
tic;
disp('Reconstructing from BWT coefficients...');
imr = ibwt(imbwt);
toc

d = imr-im;

subplot(2,2,1);
imagesc(im);title('Original');
subplot(2,2,2);
imagesc(imbwt);title('BWT decomposition');
subplot(2,2,3);
imagesc(imr);title('Reconstruction');
subplot(2,2,4);
plot(d(:));
hold on;
plot(eps*abs(im(:)),'r');
plot(-eps*abs(im(:)),'r');
hold off;
title('Reconstruction error');
