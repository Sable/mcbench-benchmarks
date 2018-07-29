% BlsMC.m
function [Price, CI] = BlsMCAV(S0,X,r,T,sigma,NRepl)
nuT = (r - 0.5*sigma^2)*T;
siT = sigma * sqrt(T);
Veps = randn(NRepl,1);
Payoff1 = max( 0 , S0*exp(nuT+siT*Veps) - X);
Payoff2 = max( 0 , S0*exp(nuT+siT*(-Veps)) - X);
DiscPayoff = exp(-r*T) * 0.5 * (Payoff1+Payoff2);
[Price, VarPrice, CI] = normfit(DiscPayoff);