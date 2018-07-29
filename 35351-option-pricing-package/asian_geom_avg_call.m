

function call_price=asian_geom_avg_call(S, K, r, q, sigma, time)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Analytical price of an Asian geometric average price call by Kemma and
% Vorst (1990)
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
%  q:       dividend yield
%  sigma:   volatility
%  time:    time to maturity
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



sigma_sqr=sigma^2;
adj_div_yield=0.5*(r+q+sigma_sqr/6.0);
adj_sigma=sigma/sqrt(3.0);
adj_sigma_sqr=adj_sigma^2;
time_sqrt=sqrt(time);

d1 = (log(S/K) + (r-adj_div_yield + 0.5*adj_sigma_sqr)*time)/(adj_sigma*time_sqrt);
d2 = d1-(adj_sigma*time_sqrt);

call_price = S * exp(-adj_div_yield*time)* normcdf(d1) - K * exp(-r*time) * normcdf(d2);
