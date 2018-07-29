%%  kmeans algorithm for an image
%---input---------------------------------------------------------
%   Y: 2D image
%   k: number of clusters
%   g: number of GMM components
%---output--------------------------------------------------------
%   X: 2D labels
%   GMM: Gaussian mixture model parameters

function [X GMM]=image_kmeans(Y,k,g)
[m n temp]=size(Y);
y=reshape(Y,[m*n 3]);
x=kmeans(y,k);
X=reshape(x,[m n]);

GMM=get_GMM(X,Y,g);