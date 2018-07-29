% BlsTMC.m
function [Price, CI] = BlsMC(S0,X,r,T,sigma,NRepl)
nuT = (r - 0.5*sigma^2)*T;
siT = sigma * sqrt(T);
DiscPayoff = exp(-r*T) * max( 0 , S0*exp(nuT+siT*randn(NRepl,1)) - X);
[Price, VarPrice, CI] = normfit(DiscPayoff);