

function call_price=european_call_futures(F, K, r, sigma, time)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Price of European call option on futures contract
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
% F:     futures price
% K:     exercise price
% r:     interest rate
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
d1 = (log (F/K) + 0.5 * sigma_sqr * time) / (sigma * time_sqrt);
d2 = d1 - sigma * time_sqrt;

call_price = exp(-r*time)*(F * normcdf(d1) - K * normcdf(d2));



