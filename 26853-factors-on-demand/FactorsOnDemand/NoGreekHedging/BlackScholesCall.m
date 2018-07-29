function [c,delta,cash] = BlackScholesCall(spot,K,r,vol,T)
% Black-Scholes price of a European call
% Inputs:
%   spot = spot price of underlying
%   K = strike of the call optioon
%   r = risk free rate as a fraction
%   vol = volatility of the underlying as a fraction
%   T = time to maturity in years
% Outputs:
%   c = price of European call(s)
%   delta = delta of the call(s)
%   cash = cash held in a replicating portfolio
%
d1 = (log(spot./K) + (r + vol.*vol/2).*T)./(vol.*sqrt(T));
d2 = d1 - vol.*sqrt(T);
delta = normcdf(d1);
cash =  -K.*exp(-r.*T).*normcdf(d2);
c = spot.*delta + cash;
