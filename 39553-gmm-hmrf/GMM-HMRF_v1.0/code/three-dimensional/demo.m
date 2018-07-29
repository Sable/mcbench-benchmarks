%% This is a demo of 3D volume segmentation

%   Copyright by Quan Wang, 2012/12/16
%   Please cite: Quan Wang. GMM-Based Hidden Markov Random Field for 
%   Color Image and 3D Volume Segmentation. arXiv:1212.4527 [cs.CV], 2012.

clear;clc;close all;

fid=fopen('Image.raw');
I=fread(fid,50*50*50,'uint8');
fclose(fid);
I=reshape(I,[50 50 50]);

Y=double(I);

k=2; % k: number of regions
g=1; % g: number of GMM components
beta=1; % beta: unitary vs. pairwise
EM_iter=10; % max num of iterations
MAP_iter=10; % max num of iterations

tic
fprintf('Performing k-means segmentation\n');
[X GMM]=image_kmeans(Y,k,g);
X_kmeans=X;

[X GMM]=HMRF_EM(X,Y,GMM,k,g,EM_iter,MAP_iter,beta);
toc

delete segmentation.raw;
fid=fopen('segmentation.raw','w');
fwrite(fid,uint8(X),'uint8');
fclose(fid);

delete kmeans.raw;
fid=fopen('kmeans.raw','w');
fwrite(fid,uint8(X_kmeans),'uint8');
fclose(fid);