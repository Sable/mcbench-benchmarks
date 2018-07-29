

function put_price=bs_european_put(S, K, r, sigma, time)


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
%   K:      exercise price
%   r:      interest rate
%   sigma:  volatility
%   time:   time to maturity
%
%--------------------------------------------------------------------------
%
% OUTPUT:
%
% put_price: price of a put option
%
%--------------------------------------------------------------------------
%
% Author:  Paolo Z., February 2012
%
%--------------------------------------------------------------------------


d1=(log(S/K)+(r+sigma^2/2)*time)/(sigma*sqrt(time));
d2=d1-sigma*sqrt(time);

put_price=K*exp(-r*time)*normcdf(-d2)-S*normcdf(-d1);
