function cost = computeCost(X, idx, centroids, K)

% computeCost is used to compute the final cost of all the points belonging
% to their respective clusters

% Initialize variables
cost = 0;

% Compute cost
for i=1:K
    temp = find(idx==i);
    Xtemp = X(temp,:); % Get all points belonging to respective cluster
    cost = cost + (1/length(Xtemp))*sum((sum(((bsxfun(@minus,centroids(i,:),Xtemp)).^2),2))...
                                                        .^(-1/2));
end

% Formula : {sqrt[(q1-p1)^2 + (q2-p2)^2 +...]}/{number of points belonging
% to cluster}
% q = q1 + q2 + ...