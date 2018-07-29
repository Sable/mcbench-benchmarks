function idx = findClosestCentroids(X, centroids)

% findClosestCentroids computes the closest centroid for each point based
% on the Euclidean distance between the point and the centroid

% Initialize variables
K = size(centroids, 1); 
idx = zeros(size(X,1), 1); % returns index of closest centroid

for i=1:size(X,1)
    temp = X(i,:);
    [~,idx(i,1)] = min(sum(((bsxfun(@minus,temp,centroids)).^2),2));
end
