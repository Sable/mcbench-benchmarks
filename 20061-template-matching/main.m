
% main file 

close all
clear all


% read Template image
im1=imread('K.bmp');
%im1=imread('S.bmp');
%im1=imread('image1.jpg');


% read Traget Image
im2=imread('letters.bmp');
%im2=imread('image2.jpg');

% apply templete matching using power of the image
result1=tmp(im1,im2);

figure,
subplot(2,2,1),imshow(im1);title('Template');
subplot(2,2,2),imshow(im2);title('Target');
subplot(2,2,3),imshow(result1);title('Matching Result using tmp');


% apply templete matching using DC components of the image
result2=tmc(im1,im2);

figure,
subplot(2,2,1),imshow(im1);title('Template');
subplot(2,2,2),imshow(im2);title('Target');
subplot(2,2,3),imshow(result2);title('Matching Result using tmc');