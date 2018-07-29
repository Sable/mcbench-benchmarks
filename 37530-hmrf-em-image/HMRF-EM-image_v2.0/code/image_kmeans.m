%%  kmeans algorithm for an image
%   Y: 2D image
%   k: number of clusters
%   X: 2D label image
%   mu: vector of means of clusters
%   sigma: vector of standard deviations of clusters

function [X mu sigma]=image_kmeans(Y,k)
y=Y(:);
x=kmeans(y,k);
X=reshape(x,size(Y));
mu=zeros(k,1);
sigma=zeros(k,1);
for i=1:k
    yy=y(x==i);
    mu(i)=mean(yy);
    sigma(i)=std(yy);
end