%% This is a demo showing how to use this toolbox

%   Copyright by Quan Wang, 2012/04/25
%   Please cite: Quan Wang. HMRF-EM-image: Implementation of the 
%   Hidden Markov Random Field Model and its Expectation-Maximization 
%   Algorithm. arXiv:1207.3510 [cs.CV], 2012.

clear;clc;close all;

I=imread('Beijing World Park 8.JPG');
Y=rgb2gray(I);
Z = edge(Y,'canny',0.75);

imwrite(uint8(Z*255),'edge.png');

Y=double(Y);
Y=gaussianBlur(Y,3);
imwrite(uint8(Y),'blurred image.png');

k=2;
EM_iter=10; % max num of iterations
MAP_iter=10; % max num of iterations

tic
fprintf('Performing k-means segmentation\n');
[X mu sigma]=image_kmeans(Y,k);
imwrite(uint8(X*120),'initial labels.png');

[X mu sigma]=HMRF_EM(X,Y,Z,mu,sigma,k,EM_iter,MAP_iter);
imwrite(uint8(X*120),'final labels.png');
toc