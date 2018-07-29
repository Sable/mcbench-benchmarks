function [alt, lat] = geodet1 (rmag, dec)

% geodetic latitude and altitude

% series solution

% input

%  rmag = geocentric radius (kilometers)
%  dec  = geocentric declination (radians)
%         (+north, -south; -pi/2 <= dec <= +pi/2)

% output

%  alt = geodetic altitude (kilometers)
%  lat = geodetic latitude (radians)
%        (+north, -south; -pi/2 <= lat <= +pi/2)

% global constants

%  req  = equatorial radius (kilometers)
%  flat = flattening factor (non-dimensional)

% reference: NASA TN D-7522

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global req flat

n = req / rmag;
o = flat * flat;
    
a = 2 * dec;
p = sin(a);
q = cos(a);
    
a = 4 * dec;
r = sin(a);
s = cos(a);
    
% geodetic latitude (radians)

lat = dec + flat * n * p + o * n * r * (n - 0.25);
    
% geodetic altitude (kilometers)

alt = rmag + req * (flat * 0.5 * (1.0 - q) + o * (0.25 * n - 0.0625) * (1.0 - s) - 1.0);


