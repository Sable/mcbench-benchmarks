function [U S] = performPCA(X)

% This function calculates the covariance matrix (Sigma) and then performs 
% svd on it to get the eigen vectors and eigen values

[m n] = size(X); % m - no of egs; n - no of features

Sigma = (1/m)*(X')*(X); % Covariance matrix

[U S V] = svd(Sigma); % Perform Singular Value Decomposition