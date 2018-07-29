function alt = triaxial(rsc)

% geodetic altitude relative
% to a triaxial ellipsoid

% input

%  rsc = geocentric position vector (kilometers)

% output

%  alt = geodetic altitude (kilometers)

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global flat cx cy cz vcon ucon caxis

% semi-axes

aaxis = 6378.138;
baxis = 6367.0;
caxis = aaxis * (1 - flat);

ucon = aaxis * aaxis - caxis * caxis;

vcon = baxis * baxis - caxis * caxis;

cx = (aaxis * caxis * rsc(1)) ^ 2;
cy = (baxis * caxis * rsc(2)) ^ 2;
cz = caxis ^ 2 * rsc(3);

g = sqrt((rsc(1) / aaxis) ^ 2 + (rsc(2) / baxis) ^ 2 + ...
         (rsc(3) / caxis) ^ 2);

zp0 = rsc(3) / g;

% bracketing interval

zp1 = zp0 - 10;

zp2 = zp0 + 10;

rtol = 1.0e-8;

zp = brent('trifunc', zp1, zp2, rtol);

xp = (aaxis ^ 2 * rsc(1) * zp) / (caxis ^ 2 * rsc(3) + ucon * zp);

yp = (baxis ^ 2 * rsc(2) * zp) / (caxis ^ 2 * rsc(3) + vcon * zp);

dx = rsc(1) - xp;
dy = rsc(2) - yp;
dz = rsc(3) - zp;

alt = sqrt(dx ^ 2 + dy ^ 2 + dz ^ 2);



