% demo_geodet     December 16, 2012

% demonstrates the geocentric-to-geodetic functions

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

global req flat

% conversion factor - degrees-to-radians

rtd = 180.0d0 / pi;

% Earth equatorial radius (kilometers)

req = 6378.1363;

% Earth flattening factor (non-dimensional)

flat = 1.0 / 298.257;

% Earth polar axis (kilometers)

rpolar = req * (1.0d0 - flat);

% eci position vector (kilometers)

reci(1) = -.586479273288D+04;
reci(2) = -.178173078828D+04;
reci(3) = -.215629990858D+04;

rmag = norm(reci);

dec = asin(reci(3) / rmag);

[alt1, lat1] = geodet1 (rmag, dec);

clc; home;

fprintf('geocentric declination    %14.8f  degrees \n\n', rtd * dec);

fprintf('geocentric radius         %14.8f  kilometers \n\n', rmag);

fprintf('\ngeodet1 function\n');
fprintf('================\n\n');

fprintf('geodetic latitude         %14.8f  degrees \n\n', rtd * lat1);

fprintf('geodetic altitude         %14.8f  kilometers \n\n', alt1);

[lat2, alt2] = geodet2(dec, rmag);

fprintf('\ngeodet2 function\n');
fprintf('================\n\n');

fprintf('geodetic latitude         %14.8f  degrees \n\n', rtd * lat2);

fprintf('geodetic altitude         %14.8f  kilometers \n\n', alt2);

[alt5, lat5] = geodet5 (req, rpolar, reci);

fprintf('\ngeodet5 function\n');
fprintf('================\n\n');

fprintf('geodetic latitude         %14.8f  degrees \n\n', rtd * lat5);

fprintf('geodetic altitude         %14.8f  kilometers \n\n', alt5);

[alt6, lat6] = geodet6 (req, rpolar, reci);

fprintf('\ngeodet6 function\n');
fprintf('================\n\n');

fprintf('geodetic latitude         %14.8f  degrees \n\n', rtd * lat6);

fprintf('geodetic altitude         %14.8f  kilometers \n\n', alt6);