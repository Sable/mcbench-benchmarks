function z = myMultiGaussian(mu,sigma,varargin)
%--------------------------------------------------------------------------
% Syntax:       z = myMultiGaussian(mu,sigma);
%               z = myMultiGaussian(mu,sigma,N);
%
% Inputs:       mu is the desired M x 1 mean vector
%
%               sigma is the desired M x M covariance matrix
%
%               N is the number of samples to generate. The default is 1.
%               
% Outputs:      z is a matrix is an M x N matrix containing N samples of a
%               multivariate Gaussian random variable of dimension M with
%               mean vector mu and covariance matrix sigma.
%
% Description:  This function generates N samples of the M-dimensional
%               multivariate Gaussian distribution with mean vector mu and
%               covariance matrix sigma.
%
%               NOTE: You can check that cov(z') ~ sigma
%
% Author:       Brian Moore
%               brimoor@umich.edu
%
% Date:         October 9, 2012
%--------------------------------------------------------------------------

if (nargin == 3)
    N = varargin{1};
else
    N = 1;
end

[m n] = size(sigma);
if ((m ~= n) || (m ~= length(mu)))
    error('mu and sigma have incorrect dimensions');
end

L = chol(sigma,'lower');
z = repmat(mu,1,N) + L * randn(n,N);
