% demo_triaxial     May 25, 2008

% this scriot demonstrates how to interact
% with the triaxial.m function which calculates
% the geodetic altitude of a spacecraft
% relative to a triaxial ellipsoid

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

global flat

% conversion factor - degrees to radians

dtr = pi / 180.0;

% Earth gravitational constant (km**3/sec**2)

mu = 398600.4415;

% Earth equatorial radius (kilometers)

req = 6378.1363;

% Earth flattening factor

flat = 1.0 / 298.257;

% classical orbital elements

oev(1) = 8000.0d0;
oev(2) = 0.015d0;
oev(3) = 28.5d0 * dtr;
oev(4) = 120.0d0 * dtr;
oev(5) = 45.0d0 * dtr;
oev(6) = 30.0d0 * dtr;

% compute eci state vector

[rsc, vsc] = orb2eci(mu, oev);

% compute geodetic altitude

alt = triaxial(rsc);

clc; home;

fprintf('\n\nprogram demo_triaxial');

fprintf('\n\naltitude relative to a triaxial ellipsoid');
fprintf('\n-----------------------------------------');

fprintf('\n\naltitude =  %14.8f kilometers\n', alt);

oeprint1(mu, oev);



