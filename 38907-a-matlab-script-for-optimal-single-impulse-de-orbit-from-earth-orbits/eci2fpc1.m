function fpc = eci2fpc1(gast, reci, veci)

% convert inertial state vector to flight path coordinates

% input

%  gast = greenwich apparent sidereal time (radians)
%  reci = inertial position vector (kilometers)
%  veci = inertial velocity vector (kilometers/second)

% output

%  fpc(1) = east longitude (radians)
%  fpc(2) = geocentric declination (radians)
%  fpc(3) = flight path angle (radians)
%  fpc(4) = azimuth (radians)
%  fpc(5) = position magnitude (kilometers)
%  fpc(6) = velocity magnitude (kilometers/second)

% global

%  omega = inertial rotation rate (radians/second)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global omega

% compute geocentric radius

rmag = norm(reci);

% compute earth-relative position vector

c(1, 1) = cos(gast);
c(1, 2) = sin(gast);
c(1, 3) = 0.0d0;

c(2, 1) = -sin(gast);
c(2, 2) = cos(gast);
c(2, 3) = 0.0d0;

c(3, 1) = 0.0d0;
c(3, 2) = 0.0d0;
c(3, 3) = 1.0d0;

recf = c * reci';

% add earth rotation effect

vtmp(1) = veci(1) + reci(2) * omega;

vtmp(2) = veci(2) - reci(1) * omega;

vtmp(3) = veci(3);

% compute relative velocity vector and magnitude

vecf = c * vtmp';

vrel = norm(vecf);

% compute east longitude and geocentric declination

xlong = atan3(recf(2), recf(1));

decl = asin(recf(3) / rmag);

% compute flight path angle and azimuth

c(1, 1) = -sin(decl) * cos(xlong);
c(1, 2) = -sin(decl) * sin(xlong);
c(1, 3) = cos(decl);

c(2, 1) = -sin(xlong);
c(2, 2) = cos(xlong);
c(2, 3) = 0.0d0;

c(3, 1) = -cos(decl) * cos(xlong);
c(3, 2) = -cos(decl) * sin(xlong);
c(3, 3) = -sin(decl);

vr = c * vecf;

fpa = asin(-vr(3) / vrel);

azimuth = atan3(vr(2), vr(1));

% flight path coordinates

fpc(1) = xlong;

fpc(2) = decl;

fpc(3) = fpa;

fpc(4) = azimuth;

fpc(5) = rmag;

fpc(6) = vrel;


