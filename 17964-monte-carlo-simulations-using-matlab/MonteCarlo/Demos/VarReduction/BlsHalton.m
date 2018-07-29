% BlsHalton.m
function [Price , CI]= BlsHalton(S0,X,r,T,sigma,NPoints)
nuT = (r - 0.5*sigma^2)*T;
siT = sigma * sqrt(T);


H = haltonset(1);
HaltonRandomNumbers = net(H,NPoints);

Norm = norminv(HaltonRandomNumbers);
DiscPayoff = exp(-r*T) * max( 0 , S0*exp(nuT+siT*Norm) - X);
[Price, VarPrice, CI] = normfit(DiscPayoff);