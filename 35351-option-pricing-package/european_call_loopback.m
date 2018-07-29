

function call_price=european_call_loopback(S, Smin, r, q, sigma, time)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Price of a European lookback call option by Goldman, Sosin and Gatto (1979)
%
%
% Reference:
%
% M Barry Goldman, Howard B Sosin and Mary Ann Gatto,
% "Path-dependent options: Buy at the low, sell at the high",
% Journal of Finance, 34, December 1979.
% 
%--------------------------------------------------------------------------
%
% INPUTS:
%
% S:        spot price
% Smin:     minimum spot price
% r:        interest rate
% q:        dividend yield
% sigma:    volatility
% time:     time to maturity
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


if (r==q) 
    call_price = 0;
else    
    sigma_sqr=sigma*sigma;
    time_sqrt = sqrt(time);
    a1 = (log(S/Smin) + (r-q+sigma_sqr/2.0)*time)/(sigma*time_sqrt);
    a2 = a1-sigma*time_sqrt;
    a3 = (log(S/Smin) + (-r+q+sigma_sqr/2.0)*time)/(sigma*time_sqrt);
    Y1 = 2.0 * (r-q-sigma_sqr/2.0)*log(S/Smin)/sigma_sqr;
    call_price = S * exp(-q*time)*normcdf(a1)- S*exp(-q*time)*(sigma_sqr/(2.0*(r-q)))*normcdf(-a1)- Smin * exp(r*time)*(normcdf(a2)-(sigma_sqr/(2*(r-q)))*exp(Y1)*normcdf(-a3));
end
