function initialCentroids = initCentroids(X, K)

% This function will be used to initialize K centroids by randomly choosing
% K data points from X to act as the initial centroids.

temp = (randperm(length(X)))'; % randomize rows
initialCentroids = X(temp(1:K,1),:); % select first K rows as initial centroids