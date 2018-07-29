function lr_mod = likelihoodR_mod(ys,ar0,ar1,varh,gamma)

%LIKELIHOODR Likelihood ratio between estimated ARMA models
%   lr_mod = LikelihoodR_mod(ys,ar0,ar1,varh)
%   is the modified Likelihood ratio of the AR model ar0, varh
%   with respect to the AR model ar1, varh with penalty factor 1
%   for the number of estimated parameters.
%   The ar1 model must be of higher order than the ar0 model.
%
%   lr_mod = LikelihoodR_mod(ys,ar0,ar1,varh,gamma)
%   Same as above with penalty factor gamma instead of 1.
%
%   y can also be a matrix containing several segments of equal
%   length (segments in colums). The segments are considered to be
%   independent.
%
%   See also: LIKELIHOODR, KLINDEX_HAT.

% S. de Waele, March 2003.
if nargin < 5,
    gamma = 1;
end

p0 = length(ar0)-1;
p1 = length(ar1)-1;
if p0 > p1
    error('The model ar1 must be of higher order than model ar0')
end
lr_mod = likelihoodR(ys,ar0,1,varh,ar1,1,varh) + gamma*(p1-p0);