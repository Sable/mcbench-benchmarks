function [G]=TabulateGenGam2dft(Rksi,Rgam,nu);
% function [G]=TabulateGenGam1dft(Rksi,Rgam,nu,K);
% This function tabulates the gain functions G for MMSE estimation
% of speech DFT coefficients, under the assumption of a
% Generalized Gamma speech amplitude prior with gamma=2. For explanations,
% derivations and motivations, see:
% J.S. Erkelens, R.C. Hendriks, R. Heusdens, and J. Jensen,
% "Minimum mean-square error estimation of discrete Fourier coefficients
% with Generalized Gamma priors", IEEE Trans. Audio, Speech and Language
% Processing, August 2007.
% and
%J.S. Erkelens, R.C. Hendriks and  R. Heusdens
%"On the Estimation of Complex Speech DFT Coefficients without Assuming Independent Real and Imaginary Parts", 
%IEEE signal processing letters 2008.
%
% INPUT variables:
% Rksi: Array of "a priori" SNR (SNRprior) values for which the gains are
% computed. NOTE: The values must be in dBs.
% Rgam: Array of "a posteriori" SNR (SNRpost) values for which the gains
% are computed. NOTE: The values must be in dBs.
% 'nu': parameter of the Generalized Gamma distribution.
% 
% OUTPUT variables:
% G: Matrix with gain values for speech DFT estimation,
% evaluated at all combinations of a priori and a posteriori SNR in the
% input variables Rksi and Rgam. To be multiplied with the noisy complex DFT coefficient.
% 
%
% Copyright 2007: Delft University of Technology, Information and
% Communication Theory Group. The software is free for non-commercial use.
% This program comes WITHOUT ANY WARRANTY.
%
% Last modified: 22-11-2007.


Rgam=10.^(Rgam(:)'/10);%Rksi and Rgam are in dBs.
Rksi=10.^(Rksi/10);
G=zeros(length(Rksi),length(Rgam));
for k=1:length(Rgam)
    [g]=gam2gains(nu,Rgam(k),Rksi);
    G(:,k)=g(:);
end

function [G]=gam2gains(nu,gamm,ksi);

Q=ksi./(nu+ksi);
Teller=ConflHyperGeomFun(nu+1,2,Q.*gamm);%evaluate the confluent hypergeometric functions
Noemer=ConflHyperGeomFun(nu,1,Q.*gamm); 
G=(nu.*Q).*Teller./Noemer;
% asymptotic result for Q.*gamm>700 (A&S, 13.5.1)  For very high values of nu and a posteriori SNR a value lower than 700 might be more appropriate.

I=find(Q.*gamm>700);
G(I)=Q(I);
%limit G for problematic cases
I=find(~isfinite(G));
G(I)=1;
I=find(G>1e4);
G(I)=1e4;

