function ydot = fpeqms(t, y)

% flight path equations of motion

% rotating, spherical earth

% input

%  y(1) = altitude (kilometers)
%  y(2) = longitude (radians)
%  y(3) = geocentric declination (radians)
%  y(4) = relative velocity (kilometers/second)
%  y(5) = relative flight path angle (radians)
%  y(6) = relative azimuth (radians)

% output

%  ydot = equations of motion vector

% global

%  req   = Earth equatorial radius (kilometers)
%  mu    = Earth gravitational constant (km**3/sec**2)
%  omega = Earth inertial rotation rate (radians/second)
%  mass  = vehicle mass (kilograms)
%  sref  = aerodynamic reference area (cubic kilometers)

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global tdata aoadata bankdata

global req mu omega mass sref

% altitude (kilometers)

alt = y(1);

% longitude (radians)

elon = y(2);

% declination (radians)

dec = y(3);

% relative speed (kilometers/second)

vrel = y(4);

% flight path angle (radians)

fpa = y(5);

% flight azimuth (radians)

azim = y(6);

% geocentric radius (kilometers)

rmag = req + alt;

% compute gravitational force (spherical earth)

grav = mu / (rmag * rmag);

% atmospheric density (kg/km**3)

rhodns = atmos76 (alt);

% compute dynamic pressure (newtons)

qdyn = 0.5 * rhodns * vrel^2;

% compute lift and drag force
      
alpha = interp1(tdata, aoadata, t, 'spline');
    
bank = interp1(tdata, bankdata, t, 'spline');
    
[clift, cdrag] = aerodyn(alpha);

lift = qdyn * clift * sref;

drag = qdyn * cdrag * sref;

% compute common trigonometric terms

sfpa = sin(fpa);
cfpa = cos(fpa);

sazim = sin(azim);
cazim = cos(azim);

sbank = sin(bank);
cbank = cos(bank);

sdec = sin(dec);
cdec = cos(dec);

% evaluate equations of motion

hdot = vrel * sfpa;

elondot = vrel * cfpa * sazim / (rmag * cdec);

decdot = vrel * cfpa * cazim / rmag;


tmp1 = omega^2 * rmag * cdec * (sfpa * cdec - sdec * cfpa * cazim);

tmp2 = -drag / mass;

tmp3 = -grav * sfpa;

vdot = tmp1 + tmp2 + tmp3;


tmp1 = vrel * cfpa / rmag;

tmp2 = 2.0 * omega * sazim * cdec;

tmp3 = omega^2 * (rmag / vrel) * cdec * (cazim * sfpa * sdec ...
    + cfpa * cdec);

tmp4 = (lift * cbank) / (mass * vrel);

tmp5 = -grav * cfpa / vrel;

gamdot = tmp1 + tmp2 + tmp3 + tmp4 + tmp5;


tmp1 = (vrel / rmag) * tan(dec) * sazim * cfpa;

tmp2 = 2.0 * omega * (sdec - cazim * cdec * tan(fpa));

tmp3 = (rmag / (vrel * cfpa)) * omega^2 * sazim * cdec * sdec;

tmp4 = (lift * sbank) / (mass * vrel * cfpa);

azidot = tmp1 + tmp2 + tmp3 + tmp4;

% load equations of motion vector

ydot(1) = hdot;

ydot(2) = elondot;

ydot(3) = decdot;

ydot(4) = vdot;

ydot(5) = gamdot;

ydot(6) = azidot;


