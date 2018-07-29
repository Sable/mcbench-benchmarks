

function call_price=american_call_bin(S, K, r, sigma, t, steps)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Price of American call option using a binomial approximation
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
%  S:       spot price
%  K:       exercice price
%  r:       interest rate
%  sigma:   volatility
%  t:       time to maturity
%  steps:   number of steps in binomial tree
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


R    = exp(r*(t/steps));
Rinv = 1.0/R;

u = exp(sigma*sqrt(t/steps));
d = 1/u;

p_up   = (R-d)/(u-d);
p_down = 1-p_up;

prices    = zeros(steps+1);
prices(1) = S*(d^steps);

uu = u*u;

for i=2:steps+1
    prices(i) = uu*prices(i-1);
end

call_values = max(0, (prices-K));

for step=steps:-1:1
    for i=1:step+1
        call_values(i) = (p_up*call_values(i+1)+p_down*call_values(i))*Rinv;
        prices(i) = d*prices(i+1);
        call_values(i) = max(call_values(i),prices(i)-K);
    end
end

call_price=call_values(1);
