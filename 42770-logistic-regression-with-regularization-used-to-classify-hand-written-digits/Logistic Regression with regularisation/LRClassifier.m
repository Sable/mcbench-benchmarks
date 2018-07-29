function theta = LRClassifier(X, y, numLabels, lambda)

% LRClassifier returns the values of theta. Each row of theta corresponds
% to a single classifier for the number being considered.

% Some useful variables
m = size(X, 1); % number of examples
n = size(X, 2); % how many parameters (features)
theta = zeros(numLabels, n+1); % (n+1) to account for the x0 term
initialTheta = zeros(n+1,1);
options = optimset('GradObj','on','MaxIter',150); % used in fmincg

% Add ones to the X data matrix to account for x0
X = [ones(m, 1) X];

% fmincg works similarly to fminunc, but is more efficient when 
% dealing with large number of parameters.


for i=1:numLabels
    yTemp = (y==i); % select all examples of particular number for training
    [tempTheta(:,i)] = fmincg(@(t)(cost(t,X,yTemp,lambda)),...
                               initialTheta,options);
    % fmincg was taken from Andrew Ng machine learning course
    theta(i,:) = tempTheta(:,i)';
end