function cdf = normcdf(x, mu, sigma)
% normal CDF
%
% file:      	normcdf.m, (c) Matthew Roughan, Tue Jul 21 2009
% directory:   /home/mroughan/src/matlab/NUMERICAL_ROUTINES/
% created: 	Tue Jul 21 2009 
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
% INPUTS:
%   x      = a vector of points at which to calculate the normal CDF 
%   mu     = mean of the normal
%   sigma  = std dev. of the normal
%

cdf = 0.5 * erfc(-(x-mu)/(sigma*sqrt(2)));

