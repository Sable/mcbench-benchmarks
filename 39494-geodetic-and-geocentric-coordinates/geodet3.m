function recf = geodet3 (lat, long, alt)

% convert geodetic coordinates to ecf position vector

% input

%  lat  = geodetic latitude (radians)
%         (+north, -south; -pi/2 <= lat <= +pi/2)
%  long = geodetic longitude (radians)
%  alt  = geodetic altitude (kilometers)

% output

%  recf = ecf position vector (kilometers)

% global constants

%  req  = equatorial radius (kilometers)
%  flat = flattening factor (non-dimensional)

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global req flat

% eccentricity squared

esqr = 2.0 * flat - flat * flat;

n = req / sqrt(1 - esqr * sin(lat) * sin(lat));

% ecf position vector components

recf(1) = (n + alt) * cos(lat) * cos(long);

recf(2) = (n + alt) * cos(lat) * sin(long);

recf(3) = (n * (1 - esqr) + alt) * sin(lat);



