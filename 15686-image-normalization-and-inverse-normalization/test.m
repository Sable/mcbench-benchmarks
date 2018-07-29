% Normalization and inverse normalization of images

% Original image
im = imread('lena.tif');
[row col] = size(im);
[normim, normtform, xdata, ydata] = imnorm(im);
invnormim = iminvnorm(normim, row, col, normtform, xdata, ydata);

% Rotate 30 degrees
imr = imrotate(im, 30, 'bilinear');
[row col] = size(imr);
[normim, normtform, xdata, ydata] = imnorm(imr);
invnormim = iminvnorm(normim, row, col, normtform, xdata, ydata);

% Scale to [400 800]
ims = imresize(im, [400 800], 'bilinear');
[row col] = size(ims);
[normim, normtform, xdata, ydata] = imnorm(ims);
invnormim = iminvnorm(normim, row, col, normtform, xdata, ydata);

% Scale to [400 800] and then rotate 30 degrees
imrs = imresize(im, [400 800], 'bilinear');
imrs = imrotate(imrs, 30, 'bilinear');
[row col] = size(imrs);
[normim, normtform, xdata, ydata] = imnorm(imrs);
invnormim = iminvnorm(normim, row, col, normtform, xdata, ydata);

