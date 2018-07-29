function [nyear,ncoef]=decode_coeff_pointer(np);
%USAGE:  [nyear,ncoef]=decode_coeff_pointer(np); 
%
% Decode igrf10syn gh pointer to extract year number and ncoef
% 1<=ncoef<=120 for nyear=1:19
% 1<=ncoef<=195 for nyear=20:24
%
% np=(nyear-1)*120+ncoef for np<=np1_max
% np=np1_max+(nyear-19)*195+ncoef; for nyear=20:24
%
% year=1995+(nyear-1)*5;
%
np1_max=2280;
if np<=np1_max
    nyear=floor(np/120)+1;
    ncoef=np-(nyear-1)*120;
    if ncoef==0
        ncoef=120;
        nyear=nyear+1;
    end
elseif np<=3255
   np2=np-np1_max;
   nyear=floor(np2/195)+1;
   ncoef=np2-(nyear-1)*195;
   if ncoef==0
       ncoef=195;
       nyear=nyear+1;
   end
   nyear=19+nyear;
else
    error('np>3255!')
end
return