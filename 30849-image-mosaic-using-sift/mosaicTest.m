clear
close all
f = 'a';
ext = 'jpg';
img1 = imread([f '1.' ext]);
img2 = imread([f '2.' ext]);
% img3 = imread('b3.jpg');

img0 = imMosaic(img2,img1,1);
% img0 = imMosaic(img1,img0,1);
figure,imshow(img0)
imwrite(img0,['mosaic_' f '.' ext],ext)