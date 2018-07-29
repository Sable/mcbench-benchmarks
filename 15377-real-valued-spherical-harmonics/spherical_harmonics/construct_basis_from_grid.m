%% Construct spherical harmonics basis evaluated at grid points
function [basis, azimuth, elevation] = construct_basis_from_grid(degree, gridsize, dl, real_or_complex)
%%=============================================================
%% Project:   Spherical Harmonics
%% Module:    $RCSfile: construct_basis_from_grid.m,v $
%% Language:  MATLAB
%% Author:    $Author: bjian $
%% Date:      $Date: 2007/12/27 06:23:35 $
%% Version:   $Revision: 1.4 $
%%=============================================================

n = gridsize(1)*gridsize(2);
thet = linspace(0,2*pi,gridsize(1));  % Azimuthal/Longitude/Circumferential
ph  = linspace(-pi/2,  pi/2,gridsize(2));  % Altitude /Latitude /Elevation

%% now theta and phi are mesh, with gridsize(2) rows and gridsize(1)
%% columns
[azimuth, elevation] = meshgrid(thet,ph);


%theta = zeros(gridsize(1)*gridsize(2),1);
%phi = zeros(gridsize(1)*gridsize(2),1);

%% NOTE: spherical harmonic' convention: PHI - azimuth, THETA - polar angle
%theta = pi/2 - theta;  % convert to interval [0, PI]

theta_vec = reshape(azimuth, n, 1);
phi_vec = reshape(elevation,n,1);
pts = zeros(n,3);
for k=1:n
    [x,y,z] = sph2cart(theta_vec(k), phi_vec(k),1);
    pts(k,:) = [x y z];
end
basis = construct_SH_basis (degree, pts, dl, real_or_complex);
