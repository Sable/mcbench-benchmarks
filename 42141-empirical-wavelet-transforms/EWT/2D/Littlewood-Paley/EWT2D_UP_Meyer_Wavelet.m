function ymw=EWT2D_UP_Meyer_Wavelet(wn,gamma,W,H)

%=========================================================
% function ymw=EWT2D_UP_Meyer_Wavelet(wn,gamma,W,H)
%
% Generate the 2D Meyer wavelet in the Fourier
% domain associated to finest scale (highest frequencies)
% ring with transition ratio gamma.
%
% Input parameters:
%   -wn : lower boundary
%   -gamma : transition ratio
%   -W : image width
%   -H : image height
%
% Output:
%   -ymw: Fourier transform of the wavelet on the highest 
%         frequencies.
%
% Author: Jerome Gilles - Giang Tran
% Institution: UCLA - Department of Mathematics
% Year: 2012
% Version: 1.0
%==========================================================

an=1/(2*gamma*wn);
pbn=(1+gamma)*wn;
mbn=(1-gamma)*wn;

Mi=floor(W/2);
Mj=floor(H/2);

ymw=ones(H,W);

for i=0:W-1
   for j=0:H-1
      k1=pi*double(i-Mi)/Mi;
      k2=pi*double(j-Mj)/Mj;
      
      w=sqrt(k1^2+k2^2);
      if (w<mbn)
           ymw(j+1,i+1)=0;
      elseif ((w>=mbn) && (w<pbn))
           %ymw(j+1,i+1)=complex(cos(w/2),-sin(w/2))*sin(pi*EWT_beta(an*(w-mbn))/2);
           ymw(j+1,i+1)=sin(pi*EWT_beta(an*(w-mbn))/2);
      end
   end
end
ymw=ifftshift(ymw);