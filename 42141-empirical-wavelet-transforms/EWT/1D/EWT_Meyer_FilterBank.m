function mfb=EWT_Meyer_FilterBank(boundaries,N)

% =========================================================================
% function mfb=EWT_Meyer_FilterBank(boundaries,N)
%
% This function generate the filter bank (scaling function + wavelets)
% corresponding to the provided set of frequency segments
%
% Input parameters:
%   -boundaries: vector containing the boundaries of frequency segments (0
%                and pi must NOT be in this vector)
%   -N: signal length
%
% Output:
%   -mfb: cell containing each filter (in the Fourier domain), the scaling
%         function comes first and then the successive wavelets
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2012
% Version: 1.0
% =========================================================================

Npic=length(boundaries);

% We compute gamma accordingly to the theory
gamma=1;
for k=1:Npic-1
    r=(boundaries(k+1)-boundaries(k))/(boundaries(k+1)+boundaries(k));
    if r<gamma 
       gamma=r;
    end
end

r=(pi-boundaries(Npic))/(pi+boundaries(Npic));
if r<gamma 
    gamma=r; 
end
gamma=(1-1/N)*gamma; %this ensure that gamma is chosen as strictly less than the min

mfb=cell(Npic+1,1);
% We start by generating the scaling function
mfb{1}=EWT_Meyer_Scaling(boundaries(1),gamma,N);

% We generate the wavelets
for k=1:Npic-1
   mfb{k+1}=EWT_Meyer_Wavelet(boundaries(k),boundaries(k+1),gamma,N); 
end
mfb{Npic+1}=EWT_Meyer_Wavelet(boundaries(Npic),pi,gamma,N); 