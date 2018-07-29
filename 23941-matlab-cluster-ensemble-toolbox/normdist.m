function X = normdist(n,d,m,c,mode)
%NORMDIST Normal distribution.
% X = NORMDIST(N,D,M,C) returns N Gaussian (normally) distributed random
% points of dimension D, with specified mean, m, and covariance, c.  X is
% the N-by-D matrix of points.  The argument, mode, specifies whether or
% not the distrubtion is adjusted to yield the exact mean and covariance
% specified.  A value of 0 specifies no adjsutment and 1 specifies
% adjustment. Omitting the mode argument results in no adjustment
% (default).
%
% Copyright (2009) Sandia Corporation. Under the terms of Contract 
% DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government retains 
% certain rights in this software.

% if mode is ommitted use default of 0
if nargin == 4
    mode = 0;
end

% generate normal distribution
X = randn(n, d);
    
if mode == 0
    X = X*sqrtm(c);
    X = X + repmat(m,[n,1]);
elseif mode == 1
    X = X - repmat(mean(X),[n,1]);
    X = X*sqrtm(inv(cov(X)))*sqrtm(c);
    X = X + repmat(m,[n,1]);
else
    error('Invalid value for ''mode''.');
end