function [XNorm mu stddev] = normalizeFeatures(X)

% This function is used to normalize the features. It makes the mean of
% each feature 0. Formula for normalizing feature taking all examples into
% consideration is : [X(particular feature) - mean(of feature)]/ standard
% deviation of feature.

mu = mean(X);
stddev = std(X);

XNorm = bsxfun(@minus,X,mu); % subtract mean of each feature from original value
XNorm = bsxfun(@rdivide,XNorm,stddev); % divide by standard deviation