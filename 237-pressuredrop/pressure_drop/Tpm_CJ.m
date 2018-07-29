function CMN = Tpm_CJ(P,X,MFLUX)
% TPM_MN  Collier-Jones two-phase multiplier
% TPM_MN(P,X,MFLUX) Returns the Martinelli-Nelson two-phase 
% multipier corrected with the Collier-Jones correction factor (C)
% - for a steam-water system (i.e., TPM_{CJ-MN}=C*TPM_{MN})
%  Called function: Tpm_MN(P,X)
%  Required Inputs are: P - pressure (kPa), 
%                       X - quality (fraction),
%                   MFLUX - mass flux (kg/m^2s)
% REFERENCE: JONES, A.B., DIGHT, D.G., "HYDRODYNAMIC STABILITY OF
% A BOILING CHANNEL", PART 2,  KAPL-2208, 1962 
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

% THE CORRELATION CONSTANTS FOR THE COLLIER-JONES TPM CORRELATION
AA5=[0.14012797e+1 -0.68082318e-1 -0.83387593e-1...
      0.35640886e-1  0.21855741e-1 -0.63676796e-2];
AA6=[-0.38229399e-4 -0.45200014e-3  0.12278415e-3...
      0.15165216e-3 -0.34296260e-4 -0.32820747e-4];

%  CONVERT THE PRESSURE FROM KPA TO PSI
PPSI=P/6.895;

%  CONVERT THE MASS FLUX FROM (KG/M^2S) TO (M LBS/HR FT^2)
%  1 LBS/HR FT^2 = 1.3562E-3 KG/SM^2
GIMP=MFLUX/1.3562e-3/1e6;

% SET THE STARTING CONDITIONS
A5=0.0;
A6=0.0;

%  CALCULATE VG
VG=log(GIMP+0.2);
if (VG>1.335) 
   VG=1.335;
end

%  CALCULATE A5 AND A6
for I=0:5;
 A5=A5+AA5(I+1)*VG^I;
 A6=A6+AA6(I+1)*VG^I;
end
   
% CALCULATE C (C1 AND C2)
C1=A5+A6*PPSI-0.4;
C2=0.71195229-1.4077202e-3*PPSI+4.5726088e-6*PPSI^2-...
   7.9046866e-9*PPSI^3+7.671237e-12*PPSI^4-...
   4.1874181e-15*PPSI^5+1.2077478e-18*PPSI^6-...
   1.4334261e-22*PPSI^7;

if (C1<C2)
   C=C2;
else
   C=C1;
end

% get the MARTINELLI-NELSON multipllier
MNTPM=Tpm_MN(P,X);

% THE MARTINELLI-NELSON MULTIPLIER WITH THE COLLIER-JONES CORRECTION

CMN=C*MNTPM;

return
