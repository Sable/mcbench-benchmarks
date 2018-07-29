function om_constants

% astrodynamic and utility constants

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global dtr rtd mu mmu smu omega req flat j2 aunit

dtr = pi / 180.0;

rtd = 180.0 / pi;

% earth gravitational constant (km**3/sec**2)

mu = 398600.436233;

% moon gravitational constant (km**3/sec**2)

mmu = 4902.800076;

% sun gravitational constant (km**3/sec**2)

smu = 132712440040.944;

% earth inertial rotation rate (radians/second)

omega = 7.292115486e-5;

% earth equatorial radius (kilometers)

req = 6378.1363;

% earth flattening factor (non-dimensional)

flat = 1.0 / 298.257;

% earth oblateness gravity coefficient (non-dimensional)

j2 = 0.00108263;

% astronomical unit (kilometers)

aunit = 149597870.691;

