function ymw=EWT_Meyer_Wavelet(wn,wm,gamma,N)

%=========================================================
% function ymw=EWT_Meyer_Wavelet(wn,wm,gamma,N)
%
% Generate the 1D Meyer wavelet in the Fourier
% domain associated to scale segment [wn,wm] 
% with transition ratio gamma
%
% Input parameters:
%   -wn : lower boundary
%   -wm : upper boundary
%   -gamma : transition ratio
%   -N : number of point in the vector
%
% Output:
%   -ymw: Fourier transform of the wavelet on the band [wn,wm]
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2012
% Version: 1.0
%==========================================================

Mi=floor(N/2);
w=fftshift((0:2*pi/N:2*pi-2*pi/N))';
w(1:Mi)=-2*pi+w(1:Mi);

aw=abs(w);
ymw=zeros(N,1);

an=1/(2*gamma*wn);
am=1/(2*gamma*wm);
pbn=(1+gamma)*wn;
mbn=(1-gamma)*wn;
pbm=(1+gamma)*wm;
mbm=(1-gamma)*wm;

for k=1:N
   if ((aw(k)>=pbn) && (aw(k)<=mbm))
       ymw(k)=1;
   elseif ((aw(k)>=mbm) && (aw(k)<=pbm))
       %ymw(k)=complex(cos(w(k)/2),-sin(w(k)/2))*cos(pi*EWT_beta(am*(aw(k)-mbm))/2);   
       ymw(k)=cos(pi*EWT_beta(am*(aw(k)-mbm))/2);   
   elseif ((aw(k)>=mbn) && (aw(k)<=pbn))
       %ymw(k)=complex(cos(w(k)/2),-sin(w(k)/2))*sin(pi*EWT_beta(an*(aw(k)-mbn))/2);
       ymw(k)=sin(pi*EWT_beta(an*(aw(k)-mbn))/2);
   end
end
ymw=ifftshift(ymw);