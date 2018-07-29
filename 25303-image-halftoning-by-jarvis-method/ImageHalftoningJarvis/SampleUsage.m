
%Author : Athi Narayanan S
%M.E, Embedded Systems,
%K.S.R College of Engineering
%Erode, Tamil Nadu, India.
%http://sites.google.com/site/athisnarayanan/

%Clearing memory and command window
clc;clear all;close all;

%Getting Input
INPUT = 'lena.bmp';
in_img = imread(INPUT);
imshow(in_img);title('Input Image');

%Halftone Image Conversion
halftone_img = jarvisHalftone(in_img);
figure;imshow(halftone_img);title('Jarvis Halftoned Image');
imwrite(halftone_img,'lena_halftone.bmp');
