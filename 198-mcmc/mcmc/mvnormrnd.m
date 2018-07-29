% MVNORMRND - Multivariate Normal - Random Number Generation
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
% 
% Y = mvnormrnd(mu, sigma, n) 
%
%   mu = p by 1 mean column vector or n by p matrix of means
%   sigma = covariance matrix
%   n = number of observations to generate
%
%   Y = an n by p matrix of row vectors with mean mu and covariance sigma
%
% Note: works slightly different from Matlab builtin MVNRND.
%
%   if mu is a column vector, n rows will be returned, all with mean mu
%
%   if mu is a matrix, a matrix of the same size will be returned with
%   row Y(i,:) having mean mu(i,:) .
% 
% See also: MVNORMPDF, MVNORMLPR

function [Y] = mvnormrnd (mu,sigma,n) 

[d1,d2] = size(mu);
S = chol(sigma)';

if d2==1,
  % then mu is a column vector
  X = normrnd(0,1,n,d1);
  Y = X*S' + ones(n,1)*mu' ;
else 
  X = normrnd(0,1,d1,d2);
  Y = X*S' + mu ;
end
