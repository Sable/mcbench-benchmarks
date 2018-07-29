% MVNORMLPR - Multivariate Normal Distribution - Log Density Ratio
% Copyright (c) 1998, Harvard University. Full copyright in the file Copyright
% 
% [ lpr ] = mvnormlpr(x1, x2, mu, sigma)
%
%   mu = mean column vector, p x 1
%   sigma = covariance matrix, p x p 
%   x1, x2 = sample values, p x 1
%
%   lpr = log probability ratio
%
% returns the log of the p(p1) / p(p2) when both
% are distributed Multivariate Normal (mu,sigma).
%
% Useful for calculations in Metropolis-Hastings steps
%
% See also: METROP

function [ lpr ] = mvnormlpr (x1, x2, mu, sigma) 

d1 = x1 - mu ;
d2 = x2 - mu ;
lpr = (-(d1'/sigma)*d1 + (d2'/sigma)*d2) / 2 ;
