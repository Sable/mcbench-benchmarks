%% Angular correlation between spherical harmonics profiles
%% Reference: 
%%     Adam W. Anderson. 
%%     Measurement of Fiber Orientation Distributions Using High Angular Resolution Diffusion Imaging. 
%%     Magn. Reson. Med., 54(5):1194-1206, 2005.  (Eq.(71))
%% Example:
%%     [corr] = angular_correlation(coeff_u,coeff_v);
function [corr] = angular_correlation(coeff_u,coeff_v)
%%=============================================================
%% Project:   Spherical Harmonics
%% Module:    $RCSfile: angular_correlation.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2007/12/27 06:23:35 $
%% Version:   $Revision: 1.3 $
%%=============================================================

corr = (coeff_u'*coeff_v)/(norm(coeff_u)*norm(coeff_v));