function [f, g] = deorbit_shoot(x)

% objective function and EI equality constraints

% input

%  x(1) = current value of maneuver true anomaly (radians)
%  x(2) = x-component of deorbit delta-v vector (kilometers/second)
%  x(3) = y-component of deorbit delta-v vector (kilometers/second)
%  x(4) = z-component of deorbit delta-v vector (kilometers/second)
%  x(5) = flight time from maneuver to EI (seconds)

% output

%  f(1) = objective function (deorbit delta-v magnitude)
%  f(2) = EI geodetic altitude constraint error (kilometers)
%  f(3) = EI relative flight path angle constraint error (radians)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global mu omega jdate0 gst0 oevpo

global alttar fpatar rei vei jdatei

% compute current state vector prior to deorbit delta-v

oewrk = oevpo;

oewrk(6) = x(1);

[rpo, vpo] = orb2eci(mu, oewrk);

% current state vector after deorbit delta-v

ri = rpo;

vi = vpo + x(2:4);

% current guess for flight time (seconds)

tof = x(5);

% propagate from maneuver to current guess for time at EI

options = odeset('RelTol', 1.0e-8, 'AbsTol', 1.0e-10);

[twrk, ysol] = ode45(@j2eqm, [0 tof], [ri vi], options);

% extract state vector of the spacecraft at entry interface

rei = ysol(length(twrk), 1:3);

vei = ysol(length(twrk), 4:6);

% scalar objective function (deorbit delta-v magnitude)

f(1) = norm(x(2:4));

% julian date at entry interface

jdatei = jdate0 + tof / 86400.0;

% greenwich apparent sidereal time at entry interface (radians)

gast = mod(gst0 + omega * tof, 2.0 * pi);

% compute relative flight path coordinates at entry interface

fpc = eci2fpc1(gast, rei, vei);

% compute geodetic coordinates at entry interface

rmag = fpc(5);

dec = fpc(2);

[alt, lat] = geodet1 (rmag, dec);

% geodetic altitude error at entry interface (kilometers)
    
f(2) = alt - alttar;

% relative flight path angle error at entry interface (radians)

f(3) = fpc(3) - fpatar;

% transpose objective function

f = f';

% no derivatives

g = [];
