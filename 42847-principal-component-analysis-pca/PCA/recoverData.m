function XRecovered = recoverData(reducedData, U, K)

% This function is used to recover the original data from the data set with
% reduced features. reducedData = (m x K), where m is the number of examples
% and K is the reduced number of features. U = (n x n). UReduced = (n x K), 
% where K is the number of reduced features that we have. Therefore
% reducedData*(UReduced') becomes (m x n) , m examples made up of n features.

UReduced = U(:,1:K);
XRecovered = reducedData*(UReduced');