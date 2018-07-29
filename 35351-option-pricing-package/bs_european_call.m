

function call_price=bs_european_call(S, K, r, sigma, time)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% European put option using Black-Scholes' formula
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
%   S:      spot price
%   K:      strike price
%   r:      interest rate
%   sigma:  volatility
%   time:   time to maturity
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


time_sqrt = sqrt(time);

d1 = (log(S/K)+r*time)/(sigma*time_sqrt)+0.5*sigma*time_sqrt;
d2 = d1-(sigma*time_sqrt);

call_price  = S*normcdf(d1)-K*exp(-r*time)*normcdf(d2);
