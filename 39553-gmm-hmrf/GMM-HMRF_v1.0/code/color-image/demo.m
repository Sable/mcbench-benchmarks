%% This is a demo of 2D color image segmentation

%   Copyright by Quan Wang, 2012/12/16
%   Please cite: Quan Wang. GMM-Based Hidden Markov Random Field for 
%   Color Image and 3D Volume Segmentation. arXiv:1212.4527 [cs.CV], 2012.
    
clear;clc;close all;
 
I=imread('385028.jpg');
Y=double(I);
Y(:,:,1)=gaussianBlur(Y(:,:,1),3);
Y(:,:,2)=gaussianBlur(Y(:,:,2),3);
Y(:,:,3)=gaussianBlur(Y(:,:,3),3);


k=3; % k: number of regions
g=3; % g: number of GMM components
beta=1; % beta: unitary vs. pairwise
EM_iter=10; % max num of iterations
MAP_iter=10; % max num of iterations

tic
fprintf('Performing k-means segmentation\n');
[X GMM]=image_kmeans(Y,k,g);
imwrite(uint8(X*80),'initial labels.png');

[X GMM]=HMRF_EM(X,Y,GMM,k,g,EM_iter,MAP_iter,beta);
imwrite(uint8(X*80),'final labels.png');
toc