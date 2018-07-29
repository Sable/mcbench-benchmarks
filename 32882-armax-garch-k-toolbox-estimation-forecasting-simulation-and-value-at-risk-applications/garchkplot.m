function garchkplot(data, ht, kt, resids)
%{
-----------------------------------------------------------------------
 PURPOSE:
 Plots the data, volatility and residuals
-----------------------------------------------------------------------
 USAGE:
 garch(data, ht, resids)

 INPUTS:
 data:      (T x 1) vector of data
 ht:        (T x 1) vector of conditional variance
 kt:        (T x 1) vector of conditional kurtosis
 resids:    (T x 1) vector of residuals

-----------------------------------------------------------------------
Author:
 Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
 Date: 11/2011
-----------------------------------------------------------------------
%}
if nargin == 0 
    error('Data, Conditional Variance, Conditional Kurtosis, Residuals')
end

if size(data,2) > 1 | size(resids,2) > 1 | size(resids,2) > 2
     error('Data, variance and residual vectors should be column vectors')
end

      
figure
subplot(4,1,1), plot(data);
title('Returns');
subplot(4,1,2), plot(resids); 
title('Residuals');
subplot(4,1,3), plot( ht); 
title('Conditional Variance');
subplot(4,1,4), plot( kt); 
title('Conditional Kurtosis');
end

