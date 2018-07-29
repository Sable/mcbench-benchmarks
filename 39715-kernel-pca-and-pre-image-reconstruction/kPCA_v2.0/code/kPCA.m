%   X: data matrix, each row is one observation, each column is one feature
%   d: reduced dimension
%   type: type of kernel, can be 'simple', 'poly', or 'gaussian'
%   para (input): parameter for computing the 'poly' kernel, for 'simple'
%       and 'gaussian' it will be ignored
%   Y: dimensionanlity-reduced data
%   eigVector: eigen-vector, will later be used for pre-image
%       reconstruction
%   para (output): automatically selected Gaussian kernel parameter

%   Copyright by Quan Wang, 2011/05/10
%   Please cite: Quan Wang. Kernel Principal Component Analysis and its
%   Applications in Face Recognition and Active Shape Models.
%   arXiv:1207.3538 [cs.CV], 2012.

function [Y, eigVector, para]=kPCA(X,d,type,para)

%% check input
if ( strcmp(type,'simple') || strcmp(type,'poly') || ...
        strcmp(type,'gaussian') ) == 0
    Y=[];
    eigVector=[];
    para=[];
    fprintf(['\nError: Kernel type ' type ' is not supported. \n']);
    return;
end

%% parameters
N=size(X,1);
if strcmp(type,'gaussian')
    DIST=zeros(N,N);
    for k=1:size(X,2)
        [a,b]=meshgrid(X(:,k));
        DIST=DIST+(a-b).^2;
    end
    DIST=DIST.^0.5;
    DIST=DIST+diag(ones(N,1)*inf);
    para=10*median(min(DIST));
end

%% kernel PCA
K0=kernel(X,type,para);
oneN=ones(N,N)/N;
K=K0-oneN*K0-K0*oneN+oneN*K0*oneN;

%% eigenvalue analysis
[V,D]=eig(K/N);
eigValue=diag(D);
% eigValue=eigValue(1:min(size(X)));
[eigValue,IX]=sort(eigValue,'descend');
eigVector=V(:,IX);

%% normailization
norm_eigVector=sqrt(sum(eigVector.^2));
eigVector=eigVector./repmat(norm_eigVector,size(eigVector,1),1);

%% dimensionality reduction
Y=K0*eigVector(:,1:d);

