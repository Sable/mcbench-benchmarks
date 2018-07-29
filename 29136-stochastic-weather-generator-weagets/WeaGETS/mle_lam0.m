function [U2] = mle_lam0(phi2,PP,PnP)
%
%
% this function calculates the maximum likelihood function U2 
% (lambda) with 0 Fourier harmonics
%
%
% zero harmonic
%
Np=sum(sum(PnP));
sumPP=sum(sum(PP));
U2=Np*log(phi2(1))-sumPP*phi2(1);
