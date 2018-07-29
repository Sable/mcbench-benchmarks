% usage demo for

% Masked k-order statistic filter for double data
% -------------------------------------------------
% by Fabio Bellavia (fbellavia@unipa.it),
% refer to: F. Bellavia, D. Tegolo, C. Valenti,
% "Improving Harris corner selection strategy",
% IET Computer Vision 5(2), 2011.
% Only for academic or other non-commercial purposes.

% see kordstatfilt2.m for more details

% compile the mex file
% tested with Matlab R2012a x32 on Ubuntu 12.04  
mex ordstatfilt2.c

% input data
im=double(rgb2gray(imread('donkey.jpg')));
figure;
imshow(im,[]);

% circular kernel
ker=fspecial('disk',15)>0;

% median filter
idx=sum(ker(:))/2+0.5;
res=kordstatfilt2(im,ker,idx);
figure;
imshow(res,[]);