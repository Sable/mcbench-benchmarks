%Program for Fusing 2 images

%Author : Athi Narayanan S
%M.E, Embedded Systems,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%http://sites.google.com/site/athisnarayanan/
%s_athi1983@yahoo.co.in

%Program Description
%This program is the main entry of the application.
%This program fuses/combines 2 images
%It supports both Gray & Color Images
%Alpha Factor can be varied to vary the proportion of mixing of each image.
%With Alpha Factor = 0.5, the two images are mixed equally.
%With Alpha Facotr < 0.5, the contribution of background image will be more.
%With Alpha Facotr > 0.5, the contribution of foreground image will be more.

%Clear Memory & Console
clc;
close all;
clear all;

%Read Input Images
% bgImg = imread('FruitsGray.png');%Background Image
% fgImg = imread('LenaGray.png');%Foreground Image
bgImg = imread('FruitsColor.png');%Background Image
fgImg = imread('LenaColor.png');%Foreground Image

%Define Alpha Factor
alphaFactor = 0.5;% 0 <= alphaFactor =< 1

%Size Validation
bg_size = size(bgImg);
fg_size = size(fgImg);
sizeErr = isequal(bg_size, fg_size);
if(sizeErr == 0)
    disp('Error: Images to be fused should be of same dimensions');
    return;
end

%Fuse Images
fusedImg = FuseImages(bgImg, fgImg, alphaFactor);
fusedImg = uint8(fusedImg);

%Display Images
figure;
subplot(131);imshow(bgImg);title('BackGround');
subplot(132);imshow(fgImg);title('ForeGround');
subplot(133);imshow(fusedImg);title('Fused');

%Write Fused Image
% imwrite(fusedImg, 'CombinedGray.png');
imwrite(fusedImg, 'CombinedColor.png');