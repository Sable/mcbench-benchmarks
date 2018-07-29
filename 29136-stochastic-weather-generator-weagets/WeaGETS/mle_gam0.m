function [U2] = mle_gam0(X,PP,logPP,PnP)
%
%
% this function calculates the maximum likelihood function U2 
% (gamma distribution) with 0 Fourier harmonics
%
%
% zero harmonic
%
Np=sum(sum(PnP));
sumPP=sum(sum(PP));
sumlogPP=sum(sum(logPP));
U2=X(1)*log(X(2))*Np+(X(1)-1)*sumlogPP-X(2)*sumPP-gammaln(X(1))*Np;
U2=-U2;