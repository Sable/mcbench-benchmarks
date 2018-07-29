function inv = cauchy_inv(x,m,s)
%---------------------------------------------------
% PURPOSE: 
% Estimates the Inverse of the Cumulative Distribution Function of the 
% Cauchy-Lorentz Distribution for a series of x values, with m location 
% parameter and s scale parameter 
%---------------------------------------------------
% USAGE: 
% inv = cauchy_inv(x,m,s)
% where: 
% x = (n x 1) or (1 x n) vector
% m = (n x 1) or (1 x n) vector
% s = (n x 1) or (1 x n) vector
%---------------------------------------------------
% RETURNS: 
% cdf = (n x 1) or (1 x n) vector containing the probability for each
% element of x with corresponding location and scale parameters
%---------------------------------------------------
% Author:
% Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
% Date: 06/2010
%---------------------------------------------------

if nargin == 0 
    error('Data, Location Parameter, Scale Parameter') 
end

inv = m + s.*tan(pi*(x-1/2));

end