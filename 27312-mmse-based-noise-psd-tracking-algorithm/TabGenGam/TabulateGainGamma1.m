function [G1,G2]=TabulateGainGamma1(Rprior,Rpost,nu,K);
% function [G1,G2]=TabulateGainGamma1(Rprior,Rpost,nu,K);
% This function tabulates the gain functions G1 and G2 for MMSE estimation
% of speech spectral amplitude and amplitude-squared, respectively, for a
% Generalized Gamma speech amplitude prior with gamma=1. The gain function
% is the maximum of two approximations of which one is most accurate at low
% SNRs, while the other is at high SNRs. For explanations, derivations and
% motivations, see: J.S. Erkelens, R.C. Hendriks, R. Heusdens, J. Jensen,
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
% K: number of terms used in the low-snr approximation.
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
Rpost=10.^(Rpost(:)'/10);% transformed into a row vector.
Rprior=10.^(Rprior/10);
G1=zeros(length(Rprior),length(Rpost));G2=G1;
for k=1:length(Rprior)
    SNRprior=Rprior(k);
    % Low SNR approximation
    [Glow,G2low]=lowSNRgains(nu,Rpost,SNRprior,K);
    % High SNR approximation
    [Ghigh,G2high]=highSNRgains(nu,Rpost,SNRprior);
    % Take the maximum of both approximations
    G1(k,:)=max(Glow,Ghigh);
    G2(k,:)=max(G2low,G2high);
end

function [G1,G2]=lowSNRgains(nu,SNRpost,SNRprior,K);
% Compute low-SNR approximation
mu=sqrt(nu*(nu+1));
% Assumption: SNRpost and SNRprior have the same length or otherwise 
% SNRprior must be a scalar
SNRpost=SNRpost(:)';SNRprior=SNRprior(:)';
Lg=length(SNRpost);Lk=length(SNRprior);
% Argument parabolic cylinder functions (D-functions)
x=mu./sqrt(2*SNRprior);
% We make use of recursive relations for the various terms.
% Parabolic cylinder functions decrease when the order becomes more
% negative. Use 19.6.4 of Abramowitz and Stegun, going from large negative
% order to small negative order.

% Initialisation. Compute everything for the maximum value of k.
FACK2=zeros(K,1);
FACK2(K)=1/gamma(K)^2;
GAMMA2KA=zeros(2*K+1,1);
GAMMA2KA(2*K+1)=gamma(nu+2*K);
GAMMA2KA(2*K)=GAMMA2KA(2*K+1)/(nu+2*K-1);
GAMMA2KA(2*K-1)=GAMMA2KA(2*K)/(nu+2*K-2);
SNRPOST2K=zeros(K,Lg);
SNRPOST2K(K,:)=(SNRpost/2).^(K-1);
D=zeros(2*K+1,Lk);
% ParCylFun: computes parabolic cylinder functions (D-functions)
D(2*K+1,:)=ParCylFun(-nu-2*K,x);
D(2*K,:)=ParCylFun(-nu-2*K+1,x);
D(2*K-1,:)=(nu+2*K-1)*D(2*K+1,:)+x.*D(2*K,:);
% Num1/Num2 : numerators for gains G1 and G2
% Den1: denominator for gains G1 and G2
Num1=FACK2(K)*SNRPOST2K(K,:)*GAMMA2KA(2*K).*D(2*K,:);
Num2=FACK2(K)*SNRPOST2K(K,:)*GAMMA2KA(2*K+1).*D(2*K+1,:);
Den1=FACK2(K)*SNRPOST2K(K,:)*GAMMA2KA(2*K-1).*D(2*K-1,:);
% k in the loop corresponds to k-1 in the equations
for k=K-1:-1:1
   fack2=FACK2(k+1)*(k^2);
   FACK2(k)=fack2;
   SNRpost2k=SNRPOST2K(k+1,:)./(SNRpost/2);
   SNRPOST2K(k,:)=SNRpost2k;
   even2ka=GAMMA2KA(2*k+1)/(nu+2*k-1);
   GAMMA2KA(2*k)=even2ka;
   odd2ka=even2ka/(nu+2*k-2);
   GAMMA2KA(2*k-1)=odd2ka;
   Deven=(nu+2*k)*D(2*k+2,:)+x.*D(2*k+1,:);
   D(2*k,:)=Deven;
   Dodd=(nu+2*k-1)*D(2*k+1,:)+x.*Deven;
   D(2*k-1,:)=Dodd;
   Num2=Num2+fack2*SNRpost2k*GAMMA2KA(2*k+1).*D(2*k+1,:);
   Num1=Num1+fack2*SNRpost2k*even2ka.*Deven;
   Den1=Den1+fack2*SNRpost2k*odd2ka.*Dodd;
end
G1=Num1./Den1./sqrt(2*SNRpost);
G2=Num2./Den1/2./SNRpost;
G1=G1(:).';
G2=G2(:).';
function [G1,G2]=highSNRgains(nu,SNRpost,SNRprior);
% Computes the gains and uses a recursion for the D-functions
mu=sqrt(nu*(nu+1));
% Argument of the D-functions.
x=mu./sqrt(2*SNRprior)-sqrt(2*SNRpost);
% Numerators
Dnum2=ParCylFun(-nu-1.5,x);
Dnum=ParCylFun(-nu-0.5,x);
% Compute denominator of G2 recursively. Denominator is used also for G1.
Dden=(nu+0.5)*Dnum2+x.*Dnum;
G1=(nu-0.5)./sqrt(2*SNRpost).*Dnum./Dden;
G2=(nu^2-1/4)/2./SNRpost.*Dnum2./Dden;
G1=G1(:).';
G2=G2(:).';