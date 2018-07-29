% makenoise.m
% written by: Duncan Po
% Date: August 24, 2002
% Generate additive Gaussian noise and add the noise to an image
% This function assumes that the image is stored in uint8 format with
% values from 0 to 255
% Usage: noisepic = makenoise(imname, imformat, nvar)
% Inputs:   imname      - name of the image file
%           imformat    - format of the image file
%           nvar        - variance of the noise normalized to the image range
% Output:   noisepic    - the resulting noisy image

function noisepic = makenoise(imname, imformat, nvar)

pic = imread(imname,imformat);
figure;
imshow(pic);
pic = double(pic);

% the following step is needed for the command imnoise (normalize)
pic2 = pic/255;

% adds zero mean Gaussian noise of power (0.1*255)^2 = 650.25
noisepic = imnoise(pic2, 'Gaussian', 0, nvar);

% converts the image back to a scale of 8 bits (0 to 255)
noisepic = noisepic*255;

% calculate initial MSE of the noisy image
MSE = sqrt(sum(sum((noisepic - pic).*(noisepic-pic)/(size(pic,1)*size(pic,2))...
    /(size(pic,1)*size(pic,2)))))
noisepic = uint8(noisepic);

figure;
imshow(noisepic);
