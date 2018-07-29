function dtof = tof1(mu, sma, ecc, tanom1, tanom2)

% time of flight between two true anomalies

% input

%  mu     = gravitational constant (km**3/sec**2)
%  sma    = semimajor axis (kilometers)
%  ecc    = eccentricity (non-dimensional)
%  tanom1 = initial true anomaly (radians)
%  tanom2 = final true anomaly (radians)

% output

%  dtof = time-of-flight between tanom1 and tanom2 (seconds)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pi2 = 2 * pi;

% orbital period (seconds)

tau = pi2 * sqrt(sma * sma * sma / mu);

% seconds per radian

spr = tau / pi2;

dtof1 = spr * (2 * atan((sqrt((1 - ecc) / (1 + ecc))* tan(0.5 * tanom1))) ...
     - ecc * sqrt(1 - ecc * ecc) * sin(tanom1) / (1 + ecc * cos(tanom1)));

  
dtof2 = spr * (2 * atan((sqrt((1 - ecc) / (1 + ecc))* tan(0.5 * tanom2))) ...
     - ecc * sqrt(1 - ecc * ecc) * sin(tanom2) / (1 + ecc * cos(tanom2)));
  
% time of flight (seconds)
  
dtof = dtof2 - dtof1;

% if necessary, make positive

if (dtof < 0)
   dtof = dtof + tau;
end
