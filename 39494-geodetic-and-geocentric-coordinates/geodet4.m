function [rmag, dec] = geodet4 (lat, alt)

% geodetic to geocentric coordinates

% input

%  lat  = geodetic latitude (radians)
%         (+north, -south; -pi/2 <= lat <= +pi/2)
%  alt  = geodetic altitude (kilometers)

% output

%  rmag = geocentric position magnitude (kilometers)
%  dec  = geocentric declination (radians)
%         (+north, -south; -pi/2 <= dec <= +pi/2)

% global constants

%  req  = equatorial radius (kilometers)
%  flat = flattening factor (non-dimensional)

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global req flat

% "normalize" altitude

hhat = alt / req;

hp1 = hhat + 1;

% calculate trig terms

s2lat = sin(2 * lat);

c2lat = cos(2 * lat);

s4lat = sin(4 * lat);

c4lat = cos(4 * lat);

% geocentric distance (kilometers)

rho = hp1 + (0.5 * (c2lat - 1)) * flat ...
      + ((1/(4 * hp1) + (1/16)) * (1 - c4lat)) * flat * flat;

rmag = req * rho;

% geocentric declination (radians)

dec = lat + (-s2lat/hp1) * flat  ...
      + (-s2lat/(2 * (hp1 * hp1)) + (1/(4 * hp1 * hp1) + 1/(4 * hp1))...
      * s4lat) * flat * flat;
       



