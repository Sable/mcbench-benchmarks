function oeprint1(mu, oev)

% print six classical orbital elements
% and orbital period in minutes

% input

%  mu     = gravitational constant (km**3/sec**2)
%  oev(1) = semimajor axis (kilometers)
%  oev(2) = orbital eccentricity (non-dimensional)
%           (0 <= eccentricity < 1)
%  oev(3) = orbital inclination (radians)
%           (0 <= inclination <= pi)
%  oev(4) = argument of perigee (radians)
%           (0 <= argument of perigee <= 2 pi)
%  oev(5) = right ascension of ascending node (radians)
%           (0 <= raan <= 2 pi)
%  oev(6) = true anomaly (radians)
%           (0 <= true anomaly <= 2 pi)

% Orbital Mechanics with Matlab

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

if (sma > 0.0)
    period = 2.0d0 * pi * sma * sqrt(sma / mu);
else
    period = 99999.9;
end

% print orbital elements

fprintf ('\n        sma (km)              eccentricity          inclination (deg)         argper (deg)');

fprintf ('\n %+16.14e  %+16.14e  %+16.14e  %+16.14e \n', sma, ecc, inc * rtd, argper * rtd);

fprintf ('\n       raan (deg)          true anomaly (deg)         arglat (deg)            period (min)');

fprintf ('\n %+16.14e  %+16.14e  %+16.14e  %+16.14e \n', raan * rtd, tanom * rtd, arglat * rtd, period / 60);



