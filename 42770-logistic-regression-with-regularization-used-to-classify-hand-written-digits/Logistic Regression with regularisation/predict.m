function prediction = predict(theta, X)

% This function returns the predicted label for the given X based on the
% highest probablity compared among each of the classifiers.

m = size(X, 1);
prediction = zeros(size(X, 1), 1);

% Add ones to the X data matrix to account for x0
X = [ones(m, 1) X];

tempProb = X * theta';
[output,prediction] = max(tempProb,[],2);