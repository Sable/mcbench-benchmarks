%% COMPUTE_GA  computes generalized anisotropy of a spherical profile
%% represented by spherical harmonics expansion
%% References: 
%%     [1] Evren Ozarslan's PhD Thesis,  See equations (4.17-18), (4.23-25)
%%     [2] http://en.wikipedia.org/wiki/Spherical_harmonics
%% Example:
%%     [GA] = compute_GA(coeffs);
function [GA] = compute_GA(coeffs)

%%=============================================================
%% Project:   Spherical Harmonics
%% Module:    $RCSfile: compute_GA.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2007/12/27 06:23:35 $
%% Version:   $Revision: 1.3 $
%%=============================================================

%% this formula works for both real and complex coefficients
V = sum(norm(coeffs(2:end))^2)/(9*norm(coeffs(1))^2+eps);
epsV = 1+1/(1+5000*V);
GA = 1 - 1/(1+power(250*V, epsV));