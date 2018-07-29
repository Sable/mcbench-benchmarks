function C = gbm_call_price(X0, K, r0, T, sigma)
%gbm_call_price - Black-Scholes call option pricing model for geometric Brownian motion prices.
%
%	C = gbm_call_price(x0, K, r0, T, sigma);
%
% Inputs:
%	X0 - Current stock price [scalar].
%	K - Strike price of call option [scalar].
%	r0 - Risk-free rate (annualized) [scalar].
%	T - Time from current time to expiration of call option (years) [scalar].
%	sigma - Stock price volatility (annualized) [scalar].
%
% Outputs:
%	C - Call price [scalar].
%
% Comments:
%	1) This function is a custom version of blsprice that prices an American call option for a stock
%		with no dividends.
%
% See also blsprice.

% Copyright (C) 2012 The MathWorks, Inc.

a1 = 0.5*sigma^2;
a2 = log(X0/K);
a3 = sigma*sqrt(2*T);

d1 = (a2 + (r0 + a1)*T)/a3;
d2 = (a2 + (r0 - a1)*T)/a3;

n1 = 1 + erf(d1);
n2 = 1 + erf(d2);

C = 0.5*(n1*X0 - n2*K*exp(-r0*T));
