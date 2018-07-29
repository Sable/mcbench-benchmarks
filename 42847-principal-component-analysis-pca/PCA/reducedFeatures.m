function reducedData = reducedFeatures(X, U, K)

% Get data with reduced set of features. X = (m x n), where m is the number
% of examples and n is the original number of features. U = (n x n).
% UReduced = (n x K), where K is the number of reduced features that we
% want. Therefore X*UReduced = (m x K), m examples made up of K
% features.

UReduced = U(:,1:K); % Consider only first K features
reducedData = X*UReduced; % Get reduced data 