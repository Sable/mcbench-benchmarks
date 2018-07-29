function yms=EWT2D_Meyer_Scaling(w1,gamma,W,H)

%==================================================
% function ymw=EWT2D_Meyer_Scaling(w1,gamma,W,H)
%
% Generate the 1D Meyer wavelet in the Fourier
% domain associated to the disk [0,w1] 
% with transition ratio gamma
%
% Input parameters:
%   -w1 : boundary
%   -gamma : transition ratio
%   -W : image width
%   -H : image height
%
% Output:
%   -yms: Fourier transform of the scaling function
%
% Author: Jerome Gilles - Giang Tran
% Institution: UCLA - Department of Mathematics
% Year: 2013
% Version: 1.0
%===================================================

an=1/(2*gamma*w1);
pbn=(1+gamma)*w1;
mbn=(1-gamma)*w1;

Mj=round(H/2)+1;
Mi=round(W/2)+1;

yms=zeros(H,W);

for i=0:W-1
   for j=0:H-1
      k1=pi*double(i-Mi)/Mi;
      k2=pi*double(j-Mj)/Mj;
      
      w=sqrt(k1^2+k2^2);

      if (w<mbn)
        yms(j+1,i+1)=1;
      elseif ((w>=mbn) && (w<=pbn))
        yms(j+1,i+1)=cos(pi*EWT_beta(an*(w-mbn))/2);
      end
   end
end
yms=ifftshift(yms);