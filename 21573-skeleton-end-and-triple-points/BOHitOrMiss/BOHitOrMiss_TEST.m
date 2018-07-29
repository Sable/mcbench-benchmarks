%   AUTHOR:
%       Boguslaw Obara, http://boguslawobara.net/
%% Read image
im = imread('triple.tif');
im = im<10;
%% Skeleton
im = bwmorph(im, 'thin', inf);
%% Hit or Miss
out1 = BOHitOrMiss(im, 'end');
out2 = BOHitOrMiss(im, 'triple');
%% Plot
ims = im;
ims = ims + 2*out1;
ims = ims + 8*out2;
imagesc(ims);
%%