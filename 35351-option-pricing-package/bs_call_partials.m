

function hedge=bs_call_partials(S, K, r, sigma, time)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Partials of a European call option priced using Black-Scholes formula
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
% S:     spot price
% K:     Strike (exercise) price,
% r:     interest rate
% sigma: volatility
% time:  time to maturity
%
%--------------------------------------------------------------------------
%
% OUTPUT:
%
% hedge.Delta: partial with respect to S
% hedge.Gamma: second partial derivative with respect to S
% hedge.Theta: partial with respect to time
% hedge.Vega:  partial with respect to sigma
% hedge.Rho:   partial with respect to r
%
%--------------------------------------------------------------------------
%
% Author:  Paolo Z., February 2012
%
%--------------------------------------------------------------------------



time_sqrt = sqrt(time);

d1 = (log(S/K)+r*time)/(sigma*time_sqrt) + 0.5*sigma*time_sqrt;
d2 = d1-(sigma*time_sqrt);

hedge.Delta = normcdf(d1);
hedge.Gamma = normcdf(d1)/(S*sigma*time_sqrt);
hedge.Theta = -(S*sigma*normcdf(d1))/(2*time_sqrt)-r*K*exp(-r*time)*normcdf(d2);
hedge.Vega  = S * time_sqrt*normcdf(d1);
hedge.Rho   = K*time*exp(-r*time)*normcdf(d2);
