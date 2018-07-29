function yms=EWT2D_Curvelet_Scaling(Radius,w1,gamma,W,H)

%==================================================
% function ymw=EWT2D_Curvelet_Scaling(w1,gamma,W,H)
%
% Generate the 1D Littlewood-Paley wavelet in the 
% Fourier domain associated to the disk [0,w1] 
% with transition ratio gamma
%
% Input parameters:
%   -Radius : matrix giving the radius at each pixel
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

yms=zeros(H,W);

for i=1:W
   for j=1:H
      if (Radius(j,i)<mbn)
        yms(j,i)=1;
      elseif ((Radius(j,i)>=mbn) && (Radius(j,i)<=pbn))
        yms(j,i)=cos(pi*EWT_beta(an*(Radius(j,i)-mbn))/2);
      end
   end
end