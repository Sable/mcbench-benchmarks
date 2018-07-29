function [dest] = rotate_coeff(src, rotation, degree, dl)
%%=============================================================
%% Project:   Spherical Harmonics
%% Module:    $RCSfile: rotate_coeff.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2007/12/27 06:23:36 $
%% Version:   $Revision: 1.3 $
%%=============================================================

R = SHRotate(rotation, degree);
if (nargin<4)
    dl = 1;
end

for i=0:dl:degree
    if (dl == 1)
        start_pos = i*i;
    else
        if (dl==2)
            start_pos = i*(i-1)/2;
        end
    end    
    dest(:,start_pos+1:start_pos+2*i+1)  = src(:,start_pos+1:start_pos+2*i+1)*R{i+1};
end
