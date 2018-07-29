function yms=EWT_Meyer_Scaling(w1,gamma,N)

%==================================================
% function ymw=EWT_Meyer_Scaling(w1,gamma,N)
%
% Generate the 1D Meyer wavelet in the Fourier
% domain associated to the segment [0,w1] 
% with transition ratio gamma
%
% Input parameters:
%   -w1 : boundary
%   -gamma : transition ratio
%   -N : number of point in the vector
%
% Output:
%   -yms: Fourier transform of the scaling function
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2012
% Version: 1.0
%===================================================

Mi=floor(N/2);
w=fftshift((0:2*pi/N:2*pi-2*pi/N))';
w(1:Mi)=-2*pi+w(1:Mi);

aw=abs(w);
yms=zeros(N,1);

an=1/(2*gamma*w1);
pbn=(1+gamma)*w1;
mbn=(1-gamma)*w1;

for k=1:N
   if (aw(k)<=mbn)
       yms(k)=1;
   elseif ((aw(k)>=mbn) && (aw(k)<=pbn))
       yms(k)=cos(pi*EWT_beta(an*(aw(k)-mbn))/2);
   end
end
yms=ifftshift(yms);