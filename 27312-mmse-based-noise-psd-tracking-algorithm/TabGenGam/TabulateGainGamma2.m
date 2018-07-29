function [G1,G2]=TabulateGainGamma2(Rprior,Rpost,nu);
% function [G1,G2]=TabulateGainGamma2(Rprior,Rpost,nu);
% This function tabulates the gain functions G1 and G2 for MMSE estimation
% of speech spectral amplitude and amplitude-squared, respectively, for a
% Generalized Gamma speech amplitude prior with gamma=2. For explanations,
% derivations and motivations, see:
% J.S. Erkelens, R.C. Hendriks, R. Heusdens, and J. Jensen,
% "Minimum mean-square error estimation of discrete Fourier coefficients
% with Generalized Gamma priors", IEEE Trans. Audio, Speech and Language
% Processing, August 2007.
%
% INPUT variables:
% Rprior: Array of "a priori" SNR (SNRprior) values for which the gains are
% computed. NOTE: The values must be in dBs.
% Rpost: Array of "a posteriori" SNR (SNRpost) values for which the gains
% are computed. NOTE: The values must be in dBs.
% 'nu': parameter of the Generalized Gamma distribution.
% 
% OUTPUT variables:
% G1: Matrix with gain values for speech spectral amplitude estimation,
% evaluated at all combinations of a priori and a posteriori SNR in the
% input variables Rprior and Rpost. To be multiplied with the noisy amplitude.
% G2: Matrix with gain values for the amplitude-squared estimator (to be
% multiplied with the SQUARE of the noisy amplitude).
%
% Copyright 2007: Delft University of Technology, Information and
% Communication Theory Group. The software is free for non-commercial use.
% This program comes WITHOUT ANY WARRANTY.
%
% Last modified: 25-6-2007.

% Convert to Rpost and Rprior to a linear scale.
Rpost=10.^(Rpost/10);
Rprior=10.^(Rprior(:)'/10);% transformed into a row vector.
G1=zeros(length(Rprior),length(Rpost));G2=G1;
for k=1:length(Rpost)
    SNRpost=Rpost(k);
    [g1,g2]=gam2gains(nu,SNRpost,Rprior);
    G1(:,k)=g1(:);
    G2(:,k)=g2(:);
end

function [G1,G2]=gam2gains(nu,SNRpost,Rprior);
% Gains can be expressed in terms of Besselfunctions for nu=1
if nu==1
    vk=SNRpost.*Rprior./(1+Rprior);
    G1=gamma(1.5)*sqrt(vk).*[(1+vk).*besseli(0,vk/2,1)+vk.*besseli(1,vk/2,1)]./SNRpost;
    G2=Rprior./(1+Rprior)./SNRpost.*(1+vk);
else
    Q=Rprior./(nu+Rprior);
    % ConflHyperGeomFun: computes confluent hypergeometric function
    Teller=ConflHyperGeomFun(nu+0.5,1,Q.*SNRpost);
    Teller2=ConflHyperGeomFun(nu+1,1,Q.*SNRpost);
    Noemer=ConflHyperGeomFun(nu,1,Q.*SNRpost);
    G1=gamma(nu+0.5)/gamma(nu)*sqrt(Q./SNRpost).*Teller./Noemer;
    G2=nu*(Q./SNRpost).*Teller2./Noemer;
    % asymptotic result for Q.*SNRpost>700 (Abramowitz and Stegun, 13.5.1) For very high values of nu and a posteriori SNR a value lower than 700 might be more appropriate.
    I=find(Q.*SNRpost>700);
    G1(I)=Q(I);
    G2(I)=Q(I).^2;
end
