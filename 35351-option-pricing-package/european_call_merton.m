

function call_price=european_call_merton(S, X, r, sigma, time_to_maturity, lambda, kappa, delta, maxn)


%--------------------------------------------------------------------------
%
% DESCRIPTION:
%
% Merton (1976) jump diffusion formula for a European call option
%
%
% Reference:
% Robert C. Merton, 
% "Option pricing when underlying stock returns are discontinous", 
% Journal of Financial Economics, 3:125-144, 1976.
% 
%--------------------------------------------------------------------------
%
% INPUTS:
%
%  S:                spot price
%  X:                exercise price
%  r:                interest rate
%  sigma:            volatility
%  time_to_maturity: time to maturity
%  lambda:           parameter of the jump distribution
%  kappa:            parameter of the jump distribution
%  delta:            parameter used to normalize volatility
%  maxn:             terminal point of the infinite sum used in the
%                       approximation of the option price
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



tau         = time_to_maturity;
sigma_sqr   = sigma*sigma;
delta_sqr   = delta*delta;
lambdaprime = lambda*(1+kappa);
gamma       = log(1+kappa);
c           = exp(-lambdaprime*tau)*bs_european_call(S,X,r-lambda*kappa,sigma,tau);
log_n       = 0;

for (n=1:maxn) 
    log_n   = log_n + log(double(n));
    sigma_n = sqrt( sigma_sqr+n*delta_sqr/tau );
    r_n     = r - lambda*kappa+n*gamma/tau;
    c       = c + exp(-lambdaprime*tau+n*log(lambdaprime*tau)-log_n)*bs_european_call(S,X,r_n,sigma_n,tau);
end

call_price=c;
