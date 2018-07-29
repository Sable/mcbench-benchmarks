function garchplot(data, ht, resids)
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
 resids:    (T x 1) vector of residuals

-----------------------------------------------------------------------
Author:
 Alexandros Gabrielsen, a.gabrielsen@city.ac.uk
 Date: 08/2011
-----------------------------------------------------------------------
%}
if nargin == 0 
    error('Data, Conditional Variance, Residuals')
end

if size(data,2) > 1 | size(resids,2) > 1 | size(resids,2) > 2
     error('Data, variance and residual vectors should be column vectors')
end

      
figure
subplot(3,1,1), plot(data);
title('Returns');
subplot(3,1,2), plot(resids); 
title('Residuals');
subplot(3,1,3), plot( ht); 
title('Conditional Variance');

end

