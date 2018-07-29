function inv = gram_charlier_inv(x,m,s,sk,ku);
%---------------------------------------------------
% PURPOSE: 
% Estimates the Inverse of the Cumulative Distribution Function of the
% Gram Charlier Distribution for a series of x values, with m mean,
% s variance, sk skewness and ku kurtosis parameters 
%---------------------------------------------------
% USAGE: 
% inv = gram_charlier_inv(x,m,s,sk,ku)
%---------------------------------------------------
% Author:
% Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
% Date: 06/2010
%---------------------------------------------------
% Christoffersen, P., F., and Goncalves, S., (2005).
% “Estimation Risk in Financial Risk Management.” Journal of
% Risk, 7(3), 1-28
%---------------------------------------------------
if nargin == 0 
    error('Data, Mean, Variance, Skewness and Kurtosis Parameters') 
end

inv = norminv(x,m,s)*(1+(sk/6)*(norminv(x,m,s)^2-1)+((ku-3)/24)*(norminv(x,m,s)^3 - 3*norminv(x,m,s)));

end % Function End


    
