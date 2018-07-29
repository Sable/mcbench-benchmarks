%% Evaluate the spherical harmonic function of degree l and order m 
%% at (theta,phi) where ¦È and phi represent colatitude and longitude, respectively. 
%% The spherical coordinates used in here are consistent with those used by physicists, 
%% but differ from those employed by mathematicians (see spherical coordinates). 
%% In particular, the colatitude ¦È, or polar angle, ranges from 0 <= theta <= pi and 
%% the longitude phi, or azimuth, ranges from 0 <= phi < 2pi. 

%% Reference: 
%%     Spherical harmonics 
%%     http://en.wikipedia.org/wiki/Spherical_harmonics
%%
%% Example:
%%      [Ylm] = compute_Ylm(l,m,theta,phi)
function [Ylm] = compute_Ylm(L, M, THETA, PHI)

%%=============================================================
%% Project:   Spherical Harmonics
%% Module:    $RCSfile: compute_Ylm.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2007/12/27 06:23:35 $
%% Version:   $Revision: 1.3 $
%%=============================================================

Plm = legendre(L,cos(THETA));

if L~=0
  Plm = squeeze(Plm(M+1,:,:));
end

a1 = ((2*L+1)/(4*pi));
a2 = factorial(L-M)/factorial(L+M);
C = sqrt(a1*a2);

Ylm = C*Plm.*exp(i*M*PHI);