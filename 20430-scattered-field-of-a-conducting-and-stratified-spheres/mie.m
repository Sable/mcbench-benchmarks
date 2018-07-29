function [esTheta, esPhi] = mie(radius, frequency, theta, phi, nMax)

% Compute the complex-value scattered electric far field of a perfectly
% conducting sphere using the mie series. Follows the treatment in
% Chapter 3 of 
%
% Ruck, et. al. "Radar Cross Section Handbook", Plenum Press, 1970.
%  
% The incident electric field is in the -z direction (theta = 0) and is
% theta-polarized. The time-harmonic convention exp(jwt) is assumed, and
% the Green's function is of the form exp(-jkr)/r.
% 
% Inputs:
%   radius: Radius of the sphere (meters)
%   frequency: Operating frequency (Hz)
%   theta: Scattered field theta angle (radians)
%   phi: Scattered field phi angle (radians)
%   nMax: Maximum mode for computing Bessel functions
% Outputs:
%   esTheta: Theta-polarized electric field at the given scattering angles
%   esPhi: Phi-polarized electric field at the given scattering angles
%
%   Output electric field values are normalized such that the square of the
%   magnitude is the radar cross section (RCS) in square meters.
%
%   Author: Walton C. Gibson, email: kalla@tripoint.org

% speed of light
c = 299792458.0;

% radian frequency
w = 2.0*pi*frequency;

% wavenumber
k = w/c;

% conversion factor between cartesian and spherical Bessel/Hankel function
s = sqrt(0.5*pi/(k*radius));

% mode numbers
mode = 1:nMax; 

% compute spherical bessel, hankel functions
[J(mode)] = besselj(mode + 1/2, k*radius); J = J*s;
[H(mode)] = besselh(mode + 1/2, 2, k*radius); H = H*s;
[J2(mode)] = besselj(mode + 1/2 - 1, k*radius); J2 = J2*s;
[H2(mode)] = besselh(mode + 1/2 - 1, 2, k*radius); H2 = H2*s;
 
% derivatives of spherical bessel and hankel functions
% Recurrence relationship, Abramowitz and Stegun Page 361
kaJ1P(mode) = (k*radius*J2 - mode .* J );
kaH1P(mode) = (k*radius*H2 - mode .* H );


% Ruck, et. al. (3.2-1)
An = -((i).^mode) .* ( J ./ H ) .* (2*mode + 1) ./ (mode.*(mode + 1));

% Ruck, et. al. (3.2-2), using derivatives of bessel functions 
Bn = ((i).^(mode+1)) .* (kaJ1P ./ kaH1P) .* (2*mode + 1) ./ (mode.*(mode + 1));
 
[esTheta esPhi] = mieScatteredField(An, Bn, theta, phi, frequency);
     
return