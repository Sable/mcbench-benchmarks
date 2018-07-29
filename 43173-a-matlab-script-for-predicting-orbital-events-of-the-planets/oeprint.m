function oeprint(mu, oev)

% print six classical orbital elements
% (orbital period in days, sma in kilometers)

% input

%  mu      = gravitational constant (km^3/sec^2)
%  oev(1)  = semimajor axis (km)
%  oev(2)  = orbital eccentricity (non-dimensional)
%            (0 <= eccentricity < 1)
%  oev(3)  = orbital inclination (radians)
%            (0 <= inclination <= pi)
%  oev(4)  = argument of periapsis (radians)
%            (0 <= argument of periapsis <= 2 pi)
%  oev(5)  = right ascension of ascending node (radians)
%            (0 <= raan <= 2 pi)
%  oev(6)  = true anomaly (radians)
%            (0 <= true anomaly <= 2 pi)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rtd = 180 / pi;

% unload orbital elements array

sma = oev(1);
ecc = oev(2);
inc = oev(3);
argper = oev(4);
raan = oev(5);
tanom = oev(6);

arglat = mod(tanom + argper, 2.0 * pi);

period = 2.0 * pi * sma * sqrt(sma / mu) / 86400.0;

% print orbital elements

fprintf ('\n      sma (km)        eccentricity     inclination (deg)    argper (deg)');

fprintf ('\n %12.10e  %12.10e  %12.10e  %12.10e \n', sma, ecc, inc * rtd, argper * rtd);

fprintf ('\n     raan (deg)     true anomaly (deg)   arglat (deg)       period (days)');

fprintf ('\n %12.10e  %12.10e  %12.10e  %12.10e \n', raan * rtd, tanom * rtd, arglat * rtd, period);



