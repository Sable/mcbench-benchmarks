function chf = cauchy_chf(x,m,s)
%---------------------------------------------------
% PURPOSE: 
% Estimates the Cumulative Hazard Function of the 
% Cauchy-Lorentz Distribution for a series of x values, with m location 
% parameter and s scale parameter 
%---------------------------------------------------
% USAGE: 
% hf = cauchy_hf(x,m,s)
% where: 
% x = (n x 1) or (1 x n) vector
% m = (n x 1) or (1 x n) vector
% s = (n x 1) or (1 x n) vector
%---------------------------------------------------
% RETURNS: 
% hf = (n x 1) or (1 x n) vector containing the hf values for each
% element of x with corresponding location and scale parameters
%---------------------------------------------------
% Author:
% Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
% Date: 09/2010
%---------------------------------------------------

if nargin == 0 
    error('Data, Location Parameter, Scale Parameter') 
end

chf = -log(1-cauchy_cdf(x,m,s));

end