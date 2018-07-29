% Demo for the kmeans algorithm

% First, generate sample data
%   We will test with 4 clusters in 3 dimensions,
%   by generating random data with gaussian density, variance 1,
%   with means (0,0,0), (0,0,6), (0,6,0) and (6,0,0)
%   and Ndata  200,       300,   100     and 500

K = 4;
dim = 3;
variance = 1;
sdev = sqrt(variance);

cluster1 = sdev*randn(200,dim) + kron(ones(200,1),[0,0,0]);
cluster2 = sdev*randn(300,dim) + kron(ones(300,1),[0,0,6]);
cluster3 = sdev*randn(100,dim) + kron(ones(100,1),[0,6,0]);
cluster4 = sdev*randn(500,dim) + kron(ones(500,1),[6,0,0]);

% Build data matrix
X = [cluster1 ; cluster2 ; cluster3; cluster4];

% Now apply K-means algorithm
% Note that order of results may vary
maxerr = 0;
[proto Nproto] = simple_kmeans(X,K,maxerr)
