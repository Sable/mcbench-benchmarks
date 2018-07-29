function lr = LikelihoodR(ys,ar0,ma0,var0,ar1,ma1,var1)

%LIKELIHOODR Likelihood ratio between estimated ARMA models
%   lr = likelihoodR(y,ar0,ma0,var0,ar1,ma1,var1)
%   is the Likelihood ratio of the ARMA model ar0, ma0, var0
%   with respect to the ARMA model ar1, ma1, var1.
% 
%   y can also be a matrix containing several segments of equal
%   length (segments in colums). The segments are considered to be
%   independent.
%
%   See also: LIKELIHOODR_MOD, KLINDEX_HAT.

% S. de Waele, March 2003.

lr = sum(KLIndex_hat(ys,ar0,ma0,var0)) - sum(KLIndex_hat(ys,ar1,ma1,var1));