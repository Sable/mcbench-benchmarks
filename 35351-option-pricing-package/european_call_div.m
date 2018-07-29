

function call_price=european_call_div(S, K, r, sigma, time_to_maturity, dividend_times, dividend_amounts)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% European option price with an underlying stock paying a discrete-time
% dividend 
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
%  S:                   spot price
%  K:                   exercice price
%  r:                   interest rate
%  y:                   continous payout
%  sigma:               volatility
%  time_to_maturity:    time to maturity
%  dividend_times:      periods of dividend payment
%  dividend_amounts:    amounts of dividend payment 
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



adjusted_S = S;

for ( i=1:max(size(dividend_times)) ) 
    if (dividend_times(i)<=time_to_maturity)
        adjusted_S = adjusted_S-dividend_amounts(i)*exp(-r*dividend_times(i));
    end
end

call_price = bs_european_call(adjusted_S,K,r,sigma,time_to_maturity);
