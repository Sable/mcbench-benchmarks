%%  kmeans algorithm for an image
%---input---------------------------------------------------------
%   Y: 3D image
%   k: number of clusters
%   g: number of GMM components
%---output--------------------------------------------------------
%   X: 3D labels
%   GMM: Gaussian mixture model parameters

function [X GMM]=image_kmeans(Y,k,g)
[m n l]=size(Y);
y=Y(:);
x=kmeans(y,k);
X=reshape(x,[m n l]);

GMM=get_GMM(X,Y,g);