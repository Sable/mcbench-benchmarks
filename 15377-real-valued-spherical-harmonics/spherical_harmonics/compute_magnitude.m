%% Compute the magnitude of spherical harmonics coefficients at each band
%%
%% Example:
%%    [coeff_magnitude] = compute_magnitude(coeff, degree, dl)
%%
function [coeff_magnitude] = compute_magnitude(coeff, degree, dl)

%%=============================================================
%% Project:   Spherical Harmonics
%% Module:    $RCSfile: compute_magnitude.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2007/12/27 06:23:35 $
%% Version:   $Revision: 1.8 $
%%=============================================================

[n] = size(coeff,1);

if (nargin<3)
    dl = 1;
end

l = 0:dl:degree;
coeff_magnitude = zeros(n, length(l));
for i=l
    magnitude = zeros(n,1);
    if (dl == 1)
        start_pos = i*i;
    else
        if (dl==2)
            start_pos = i*(i-1)/2;
        end
    end
    
    for k=1:2*i+1
        magnitude = magnitude + coeff(:,start_pos+k).^2;
    end
    magnitude = sqrt(magnitude);
    coeff_magnitude(:,i/dl+1) = magnitude;
end