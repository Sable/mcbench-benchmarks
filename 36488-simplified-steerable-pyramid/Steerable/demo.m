% A simple demo of the use of simplified steerable pyramid
% Dzung Nguyen <dzungng89@gmail.com>

clear all;
close all;
clc;

im=double(imread('lena512.bmp'));

% Steerable pyramid through convolution
coeff=buildSpyr(im,5,'sp3.mat');
out=reconSpyr(coeff,'sp3.mat');
imshow(out,[]);
title('Steerable pyramid in time domain');
showsteerable(coeff);

% % Steerable pyramid implemented in frequency domain
% coeff=buildSFpyr(im,5);
% out=reconSFpyr(coeff);
% imshow(out,[]);
% title('Steerable pyramid in frequency domain');
% 
% % Complex steerable pyramid implemented in frequency domain
% coeff=buildSCFpyr(im,5);
% out=reconSCFpyr(coeff);
% imshow(out,[]);
% title('Complex steerable pyramid in frequency domain');
