function [centroids cost idx] = runKMeans(X, K, iterCentroids)

% This function runs K means the number of times specified by iterKMeans.
% It returns the final centroids and the final cost of that iteration.

% Initialize centroids
fprintf('Initializing centroids');
centroids = initCentroids(X,K);
fprintf('...done\n\n');

for num=1:iterCentroids
    
    %fprintf('Starting iteration number %d\n\n',num);
    
    % return index of closest centroid for each point
    idx = findClosestCentroids(X, centroids);
    
    % Compute New centroid of each cluster
    centroids = computeNewCentroids(X, idx, K);
    
end

% Compute cost of the final clusters
cost = computeCost(X, idx, centroids, K);