

function call_price=european_call_contpay(S, X, r, q, sigma, time)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Option price with continous payout from underlying asset
%
%
% Reference:
%
% 
%--------------------------------------------------------------------------
%
% INPUTS:
%
% S:     spot price
% X:     strike (exercise) price
% r:     interest rate
% q:     yield on underlying
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


sigma_sqr = (sigma^2);
time_sqrt = sqrt(time);
d1 = (log(S/X) + (r-q + 0.5*sigma_sqr)*time)/(sigma*time_sqrt);
d2 = d1-(sigma*time_sqrt);
call_price = S * exp(-q*time)* normcdf(d1) - X * exp(-r*time) * normcdf(d2);


