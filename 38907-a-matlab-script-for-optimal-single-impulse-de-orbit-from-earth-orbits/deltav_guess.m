function [dv, dtof] = deltav_guess(oev1, alttar, fpatar)

% initial guess for de-orbit delta-v vector and flight time

% input

%  oev1   = classical orbital elements of initial orbit
%  alttar = "target" altitude at EI (kilometers)
%  fpatar = "target" flight path angle at EI (radians)

% output

%  dv   = de-orbit delta-v vector (km/sec)
%  dtof = flight time from maneuver to EI (seconds)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global mu req

cfpae = cos(fpatar);

if (oev1(2) < 1.0d-10)

    % initial circular orbit

    [r1, v1] = orb2eci(mu, oev1);

    rmag1 = norm(r1);

    rentry = req + alttar;

    % determine deorbit delta-v

    sigma = rmag1 / rentry;

    % local circular velocity at entry altitude

    vlce = sqrt(mu / rentry);

    % required de-orbit delta-v (kilometers/second)

    deltav = vlce * sqrt(1.0 / sigma) ...
        * (1.0 - sqrt(2.0 * (sigma - 1.0) / ((sigma / cfpae)^2 - 1.0)));

    vmag1 = norm(v1);

    vunit1 = v1 / vmag1;

    % compute velocity vector after delta-v

    vmag2 = vmag1 - deltav;

    v2 = vmag2 * vunit1;

    % orbital elements after maneuver

    r2 = r1;

    oev2 = eci2orb1(mu, r2, v2);

    sma2 = oev2(1);

    ecc2 = oev2(2);

    % true anomaly on deorbit trajectory at entry interface (radians)

    tmp1 = mu * (2.0 * sma2 * rentry - rentry^2 - sma2^2 * (1.0 - ecc2^2));

    tmp2 = sma2 * rentry^2;

    rdot = -sqrt(tmp1 / tmp2);

    sta = (rdot / ecc2) * sqrt(sma2 * (1.0 - ecc2^2) / mu);

    cta = sma2 * (1.0 - ecc2^2) / (ecc2 * rentry) - (1.0 / ecc2);

    ta2 = atan3(sta, cta);

    % flight time from impulse to entry (seconds)

    dtof = tof1(mu, sma2, ecc2, pi, ta2);

else

    % initial elliptical orbit

    [r1, v1] = orb2eci(mu, oev1);

    rp = oev1(1) * (1.0 - oev1(2));

    ra = oev1(1) * (1.0 + oev1(2));

    rentry = req + alttar;

    % local circular velocity at entry altitude (kilometers/second)

    vlce = sqrt(mu / rentry);

    % required deorbit delta-v (kilometers/second)

    alpha1 = ra / rentry;

    beta1 = rp / rentry;

    tmp1 = sqrt(2.0 * beta1 / (alpha1 * (alpha1 + beta1)));

    tmp2 = sqrt(2.0 * (alpha1 - 1.0) / (alpha1 * (alpha1^2 - cfpae^2)));

    deltav = vlce * (tmp1 - tmp2 * cfpae);

    % compute unit velocity vector prior to impulse

    vmag1 = norm(v1);

    vunit1 = v1 / vmag1;

    % compute velocity vector after delta-v

    vmag2 = vmag1 - deltav;

    v2 = vmag2 * vunit1;

    % orbital elements after maneuver

    r2 = r1;

    oev2 = eci2orb1(mu, r2, v2);

    sma2 = oev2(1);

    ecc2 = oev2(2);

    % true anomaly on deorbit trajectory at entry interface (radians)

    tmp1 = mu * (2.0 * sma2 * rentry - rentry^2 - sma2^2 * (1.0 - ecc2^2));

    tmp2 = sma2 * rentry^2;

    rdot = -sqrt(tmp1 / tmp2);

    sta = (rdot / ecc2) * sqrt(sma2 * (1 - ecc2^2) / mu);

    cta = sma2 * (1.0 - ecc2^2) / (ecc2 * rentry) - (1.0 / ecc2);

    ta2 = atan3(sta, cta);

    % flight time from maneuver to entry interface (seconds)

    dtof = tof1(mu, sma2, ecc2, pi, ta2);
    
end

% compute unit velocity vector prior to maneuver

vmag1 = norm(v1);

vunit1 = v1 / vmag1;

% de-orbit delta-v vector (kilometers/second)

dv = -deltav * vunit1;
