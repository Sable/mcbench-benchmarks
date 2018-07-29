

function call_price=european_call_futures_currcy(S, X, r, r_f, sigma, time)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% European futures call option on currency
%
%
% Reference:
%
% John Hull, "Options, Futures and other Derivative Securities",
% Prentice-Hall, second edition, 1993.
% 
%--------------------------------------------------------------------------
%
% INPUTS:
%
% S:     exchange rate
% X:     exercise
% r:     domestic interest rate
% r_f:   foreign interest rate
% sigma: volatility
% time:  time to maturity
%
%--------------------------------------------------------------------------
%
% OUTPUT:
%
% call_price: price of a call option
%
%--------------------------------------------------------------------------
%
% Author:  Paolo Z., February 2012
%
%--------------------------------------------------------------------------


sigma_sqr = sigma*sigma;
time_sqrt = sqrt(time);
d1 = (log(S/X) + (r-r_f+ (0.5*sigma_sqr)) * time)/(sigma*time_sqrt);
d2 = d1 - sigma * time_sqrt;

call_price = S * exp(-r_f*time) * normcdf(d1) - X * exp(-r*time) * normcdf(d2);

