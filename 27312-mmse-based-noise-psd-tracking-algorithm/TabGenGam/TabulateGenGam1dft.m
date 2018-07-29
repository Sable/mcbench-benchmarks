function [G]=TabulateGenGam1dft(Rksi,Rgam,nu,K);
% function [G]=TabulateGenGam1dft(Rksi,Rgam,nu,K);
% This function tabulates the gain functions G for MMSE estimation
% of speech DFT coefficients, under the assumption of a
% Generalized Gamma speech amplitude prior with gamma=1. For explanations,
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


%%%%%%%%%%%
% Glow, Glow2 refer to two different approximations.
% similar for Ghigh and Ghigh2
% the combination G=max(Glow,Ghigh2) is most accurate;
%%%%%%%
Rgam=10.^(Rgam(:)'/10);%Rksi and Rgam are in dBs.
Rksi=10.^(Rksi/10);
G=zeros(length(Rksi),length(Rgam)); % initialize the matrix with Gain values
for k=1:length(Rksi)
    ksi=Rksi(k);
    % Low-SNR-approximation; 
    [Glow,Glow2]=lowSNRgains(nu,Rgam,ksi,K);
    % High-SNR-approximation
    [Ghigh,Ghigh2]=highSNRgains(nu,Rgam,ksi);
    G(k,:)=max(Glow,Ghigh2);
  
end

function [G,Gmeth2]=lowSNRgains(nu,gamm,ksi,K);
% A_hat=G*r;(A^2)_hat=G2*r^2;
% K is total number of terms (sums from 0 to K-1).
alpha=nu;mu=sqrt(alpha*(alpha+1));
%Variables gamm and ksi have the same length or  ksi is a scalar
gamm=gamm(:)';ksi=ksi(:)';
Lg=length(gamm);Lk=length(ksi);
% argument D-functions
x=mu./sqrt(2*ksi);
% Compute the D-functions for negative orders in a recursive manner,
% starting with largerst negative order.
    % initalisatie. Copute everyting for max. k.
    FACK2=zeros(K,1);
    FACK2(K)=1/gamma(K)^2;
    GAMMA2KA=zeros(2*K+1,1);
    GAMMA2KA(2*K+1)=gamma(alpha+2*K);
    GAMMA2KA(2*K)=GAMMA2KA(2*K+1)/(alpha+2*K-1);
    GAMMA2KA(2*K-1)=GAMMA2KA(2*K)/(alpha+2*K-2);
    GAMM2K=zeros(K,Lg);
    GAMM2K(K,:)=(gamm/2).^(K-1);
    D=zeros(2*K+1,Lk);
    D(2*K+1,:)=ParCylFun(-alpha-2*K,x);
    D(2*K,:)=ParCylFun(-alpha-2*K+1,x);
    D(2*K-1,:)=(alpha+2*K-1)*D(2*K+1,:)+x.*D(2*K,:);

    % Initialisation of numerator and denominator for G and G2
  
    T1=FACK2(K)*GAMM2K(K,:)*GAMMA2KA(2*K).*D(2*K,:);
    T2=(1./(factorial(K-1)*factorial(K)))*GAMM2K(K,:)*GAMMA2KA(2*K+1).*D(2*K+1,:);
        T3=FACK2(K)*GAMM2K(K,:)*GAMMA2KA(2*K+1).*D(2*K+1,:);
    N1=FACK2(K)*GAMM2K(K,:)*GAMMA2KA(2*K-1).*D(2*K-1,:);
    %k=1 corresponds with k=0 in formulas
    for k=K-1:-1:1
        fack2=FACK2(k+1)*(k^2);
        FACK2(k)=fack2;
        gamm2k=GAMM2K(k+1,:)./(gamm/2);
        GAMM2K(k,:)=gamm2k;
        even2ka=GAMMA2KA(2*k+1)/(alpha+2*k-1);
        GAMMA2KA(2*k)=even2ka;
        odd2ka=even2ka/(alpha+2*k-2);
        GAMMA2KA(2*k-1)=odd2ka;
        Deven=(alpha+2*k)*D(2*k+2,:)+x.*D(2*k+1,:);
        D(2*k,:)=Deven;
        Dodd=(alpha+2*k-1)*D(2*k+1,:)+x.*Deven;
        D(2*k-1,:)=Dodd;
        T2=T2+(1./(factorial(k-1)*factorial(k)))*gamm2k*GAMMA2KA(2*k+1).*D(2*k+1,:);
          T3=T3+fack2*gamm2k*GAMMA2KA(2*k+1).*D(2*k+1,:);
        T1=T1+fack2*gamm2k*even2ka.*Deven;
        N1=N1+fack2*gamm2k*odd2ka.*Dodd;
    end
G=T2./N1./2;
Gmeth2=((mu./(sqrt(8*ksi.*gamm.^2))).*(T1./N1)+((1./(2*gamm)).*(T3./N1))-(alpha./(2*gamm)));
G=G(:).';
Gmeth2=Gmeth2(:).';
function [G,Gmeth2]=highSNRgains(nu,gamm,ksi);
% Computes both gain functions and uses  recursion for  D-functions
alpha=nu;
mu=sqrt(alpha*(alpha+1));
% argument
x=mu./sqrt(2*ksi)-sqrt(2*gamm);
pdf=ParCylFun(-alpha-1.5,x);
Dteller2=pdf;
pdf=ParCylFun(-alpha-0.5,x);
Dteller=pdf;
Dnoemer=(alpha+0.5)*Dteller2+x.*Dteller;
G=(alpha-0.5)./sqrt(2*gamm).*Dteller./Dnoemer;
Gmeth2=(((alpha-0.5)*mu./(sqrt(8*ksi.*gamm.^2))).*(Dteller./Dnoemer)+(((alpha+0.5)*(alpha-0.5)./(2*gamm)).*(Dteller2./Dnoemer))-(alpha./(2*gamm)));
G=G(:).';
Gmeth2=Gmeth2(:).';