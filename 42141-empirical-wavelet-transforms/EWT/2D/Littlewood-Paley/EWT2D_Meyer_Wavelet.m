function ymw=EWT2D_Meyer_Wavelet(wn,wm,gamma,W,H)

%=========================================================
% function ymw=EWT2D_Meyer_Wavelet(wn,wm,gamma,W,H)
%
% Generate the 1D Meyer wavelet in the Fourier
% domain associated to scale ring [wn,wm] 
% with transition ratio gamma
%
% Input parameters:
%   -wn : lower boundary
%   -wm : upper boundary
%   -gamma : transition ratio
%   -W : image width
%   -H : image height
%
% Output:
%   -ymw: Fourier transform of the wavelet on the band [wn,wm]
%
% Author: Jerome Gilles - Giang Tran
% Institution: UCLA - Department of Mathematics
% Year: 2012
% Version: 1.0
%==========================================================

an=1/(2*gamma*wn);
am=1/(2*gamma*wm);
pbn=(1+gamma)*wn;
mbn=(1-gamma)*wn;
pbm=(1+gamma)*wm;
mbm=(1-gamma)*wm;

Mi=floor(W/2);
Mj=floor(H/2);

ymw=zeros(H,W);

for i=0:W-1
   for j=0:H-1
      k1=pi*double(i-Mi)/Mi;
      k2=pi*double(j-Mj)/Mj;
      
      w=sqrt(k1^2+k2^2);
      if ((w>=pbn) && (w<=mbm))
           ymw(j+1,i+1)=1;
      elseif ((w>mbm) && (w<=pbm))
           %ymw(j+1,i+1)=complex(cos(w/2),-sin(w/2))*cos(pi*EWT_beta(am*(w-mbm))/2);   
           ymw(j+1,i+1)=cos(pi*EWT_beta(am*(w-mbm))/2);
      elseif ((w>=mbn) && (w<pbn))
           %ymw(j+1,i+1)=complex(cos(w/2),-sin(w/2))*sin(pi*EWT_beta(an*(w-mbn))/2);
           ymw(j+1,i+1)=sin(pi*EWT_beta(an*(w-mbn))/2);
      end
   end
end
ymw=ifftshift(ymw);