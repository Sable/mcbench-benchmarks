% phasing.m        July 21, 2013

% phasing analysis of two impulse transfer
% between coplanar circular orbits

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

global rtd dtr mu req pvi pvdi

% astrodynamic and utility constants

om_constants;

% request inputs

clc; home;

fprintf('\n   TWO IMPULSE PHASING ANALYSIS\n');

while (1)
    
    fprintf('\nplease input the initial altitude (kilometers)\n');

    alt1 = input('? ');

    if (alt1 > 0)
        break;
    end
    
end

while(1)
    
    fprintf('\nplease input the true anomaly on the initial orbit (degrees)');
    fprintf('\n(0 <= true anomaly <= 360)\n');

    tanom = input('? ');

    if (tanom >= 0 && tanom <= 360)
        break;
    end
    
end

tanom1 = dtr * tanom;

while (1)
    
    fprintf('\n\nplease input the final altitude (kilometers)\n');

    alt2 = input('? ');

    if (alt2 > 0)
        break;
    end
    
end

% compute geocentric radii of initial and final orbits (kilometers)

r1mag = req + alt1;

r2mag = req + alt2;

% radius ratio

rratio = r2mag / r1mag;

while(1)
    
    fprintf('\n\n type of initial lead angle\n');

    fprintf('\n  <1> ideal\n');

    fprintf('\n  <2> user-defined');

    fprintf('\n\n selection (1 or 2)\n');

    ila_type = input('? ');

    if (ila_type == 1 || ila_type == 2)
        break;
    end
    
end

if (ila_type == 2)
    
    while(1)
        
        fprintf('\n\nplease input the initial lead angle (degrees)\n');

        ila_deg = input('? ');

        ila = dtr * ila_deg;

        if (ila >= 0 && ila <= 2 * pi)
            break;
        end
    end
    
else
    
    % ideal hohmann lead angle

    ila = pi * (1.0 - ((1.0 + rratio) / (2.0 * rratio))^(3/2));
    
end

% keplerian mean motion

mm1 = sqrt(mu / (r1mag^3));

mm2 = sqrt(mu / (r2mag^3));

% initial true anomaly of target orbit

tanom2 = mod(tanom1 + ila, 2.0 * pi);

% orbital inclinations

inc1 = 0.0;

inc2 = 0.0;

% compute "normalized" radii

hn1 = sqrt(2.0 * r2mag / (r2mag + r1mag));

hn2 = sqrt(r1mag / r2mag);

hn3 = sqrt(2.0 * r1mag / (r2mag + r1mag));

% compute "local circular velocity" of initial and final orbits

v1mag = sqrt(mu / r1mag);

v2mag = sqrt(mu / r2mag);

% compute perigee and apogee velocities of the transfer orbit

vt1 = sqrt(2.0 * mu * r2mag / (r1mag * (r1mag + r2mag)));

vt2 = sqrt(2.0 * mu * r1mag / (r2mag * (r1mag + r2mag)));

% compute transfer orbit eccentricity

ecct = (r2mag - r1mag) / (r1mag + r2mag);

% transfer orbit semimajor axis (kilometers)

smat = (r1mag + r2mag) / 2.0;

% impulsive delta-v magnitudes (km/sec)

dv1mag = vt1 - v1mag;

dv2mag = v2mag - vt2;

% initial orbital elements and state vector of chaser orbit

oev1(1) = r1mag;
oev1(2) = 0.0;
oev1(3) = 0.0;
oev1(4) = 0.0;
oev1(5) = 0.0;
oev1(6) = tanom1;

[r1i, v1i] = orb2eci(mu, oev1);

% initial orbital elements and state vector of target orbit

oev2(1) = r2mag;
oev2(2) = 0.0;
oev2(3) = 0.0;
oev2(4) = 0.0;
oev2(5) = 0.0;
oev2(6) = tanom2;

[r2i, v2i] = orb2eci(mu, oev2);

% transfer time (seconds)

tof = pi * smat * sqrt(smat / mu);

% orbital periods (seconds)

tau1 = 2.0 * pi * r1mag * sqrt(r1mag / mu);

tau2 = 2.0 * pi * r2mag * sqrt(r2mag / mu);

% synodic period (seconds)

s = (tau1 * tau2) / (tau2 - tau1);

% ideal initial lead angle (radians)

ila_ideal = pi * (1.0 - ((1.0 + rratio) / (2.0 * rratio))^(3/2));

if (ila >= ila_ideal)
    
    delta_ila = ila - ila_ideal;
    
else
    
    delta_ila = 2.0 * pi - (ila_ideal - ila);
    
end

% required wait time (seconds)

twait = (delta_ila * s) / (2.0 * pi);

% if necessary, propagate from initial state to wait state

if (twait > 0)

    [rwait, vwait] = twobody2 (mu, twait, r1i, v1i);

else
    
    rwait = r1i;

    vwait = v1i;
    
end

oev_wait = eci2orb1(mu, rwait, vwait);

% orbital elements and state vector of transfer orbit at first impulse

oevt(1) = smat;
oevt(2) = ecct;
oevt(3) = 0.0;
oevt(4) = oev_wait(6);
oevt(5) = 0.0;
oevt(6) = 0.0;

[rtoi, vtoi] = orb2eci(mu, oevt);

mmt = sqrt(mu / (smat^3));

% compute delta-v vectors (km/sec)

for i = 1:1:3
    
    dv1(i) = vtoi(i) - vwait(i);
    
end

oev_tmp1 = oev2;

oev_tmp1(6) = mod(tanom2 + mm2 * (twait + tof), 2.0 * pi);

[r2f, v2f] = orb2eci(mu, oev_tmp1);

oev_tmp2 = oevt;

oev_tmp2(6) = pi;

[rtof, vtof] = orb2eci(mu, oev_tmp2);

for i = 1:1:3
    
    dv2(i) = v2f(i) - vtof(i);
    
end

% print results

fprintf('\n\n   TWO IMPULSE PHASING ANALYSIS \n\n');

fprintf('initial lead angle                %12.6f degrees \n\n', rtd * ila);

fprintf('ideal initial lead angle          %12.6f degrees \n\n', rtd * ila_ideal);

fprintf('\nchaser initial conditions \n');

fprintf('------------------------- \n\n');

fprintf('altitude         %12.6f kilometers \n', alt1);

oeprint1(mu, oev1);

svprint(r1i, v1i);

fprintf('\ntarget initial conditions \n');

fprintf('------------------------- \n\n');

fprintf('altitude         %12.6f kilometers \n', alt2);

oeprint1(mu, oev2);

svprint(r2i, v2i);

fprintf('\ntransfer orbit initial conditions \n');

fprintf('--------------------------------- \n');

oeprint1(mu, oevt);

svprint(rtoi, vtoi);

fprintf('\ntrajectory times \n');

fprintf('----------------\n\n');

fprintf('transfer time-of-flight           %12.6f seconds \n', tof);

fprintf('                                  %12.6f minutes \n\n', tof / 60.0);

fprintf('wait time                         %12.6f seconds \n', twait);

fprintf('                                  %12.6f minutes \n\n', twait / 60.0);

fprintf('total mission time                %12.6f seconds \n', twait + tof);

fprintf('                                  %12.6f minutes \n\n', (twait + tof) / 60.0);

fprintf('conditions at first impulse \n');

fprintf('---------------------------\n\n');

fprintf('chaser true anomaly               %12.6f degrees \n\n', rtd * mod(tanom1 + mm1 * twait, 2.0 * pi));

fprintf('target true anomaly               %12.6f degrees \n\n', rtd * mod(tanom2 + mm2 * twait, 2.0 * pi));

fprintf('transfer orbit true anomaly       %12.6f degrees \n\n\n', rtd * mod(mmt * 0.0, 2.0 * pi));

fprintf('conditions at second impulse \n');

fprintf('----------------------------\n\n');

fprintf('chaser true anomaly               %12.6f degrees \n\n', rtd * mod(tanom1 + mm1 * (twait + tof), 2.0 * pi));

fprintf('target true anomaly               %12.6f degrees \n\n', rtd * mod(tanom2 + mm2 * (twait + tof), 2.0 * pi));

fprintf('transfer orbit true anomaly       %12.6f degrees \n\n\n', rtd * mod(mmt * tof, 2.0 * pi));

fprintf('maneuver summary \n');

fprintf('----------------\n\n');

fprintf('first delta-vx                    %12.6f meters/second \n\n', 1000 * dv1(1));

fprintf('first delta-vy                    %12.6f meters/second \n\n', 1000 * dv1(2));

fprintf('first delta-vz                    %12.6f meters/second \n\n', 1000 * dv1(3));

fprintf('first deltav-magnitude            %12.6f meters/second \n\n\n', 1000 * norm(dv1));

fprintf('second delta-vx                   %12.6f meters/second \n\n', 1000 * dv2(1));

fprintf('second delta-vy                   %12.6f meters/second \n\n', 1000 * dv2(2));

fprintf('second delta-vz                   %12.6f meters/second \n\n', 1000 * dv2(3));

fprintf('second deltav-magnitude           %12.6f meters/second \n\n\n', 1000 * norm(dv2));

fprintf('total delta-v                     %12.6f meters/second \n\n\n', 1000 * (norm(dv1) + norm(dv2)));

%%%%%%%%%%%%%%%%%
% create graphics
%%%%%%%%%%%%%%%%%

figure(1);

hold on;

% plot initial location of chaser spacecraft

plot(r1i(1) / req, r1i(2) / req, 'go');

% plot initial location of target spacecraft

plot(r2i(1) / req, r2i(2) / req, 'bs');

% plot earth surface, initial and final orbits

t = 0: pi / 50: 2 * pi;

plot(sin(t), cos(t), 'Color', 'r');

plot((r1mag / req) * cos(t), (r1mag / req) * sin(t), 'Color', 'g');

plot((r2mag / req) * cos(t), (r2mag / req) * sin(t), 'Color', 'b');

plot(0.0, 0.0, '+r');

% plot location of initial impulse

plot(rwait(1) / req, rwait(2) / req, 'k*');

% propagation step size (seconds)

dtstep = 60;

tsim = real(tof);

ti = -dtstep;

x1(1) = rtoi(1) / req;

y1(1) = rtoi(2) / req;

npts = 1;

iquit = 0;

% propagate from initial impulse to final impulse

while(1)
    
    % step size guess

    if (iquit == 0)
        
        ti = ti + dtstep;

        tf = ti + dtstep;
        
    end

    % propagate from ti to tf

    [rtof, vtof] = twobody2 (mu, tf, rtoi, vtoi);

    % create graphics data

    npts = npts + 1;

    x1(npts) = rtof(1) / req;

    y1(npts) = rtof(2) / req;

    % check for end of simulation

    if (iquit == 1)
        break;
    end

    % compute "last" step size

    dt = abs(tsim - tf);

    if (dt <= dtstep)
        
        tf = tsim;
        
        iquit = 1;
        
    end
    
end

% plot transfer trajectory

plot(x1, y1, '.k');

% plot location of target at final impulse

plot(x1(end), y1(end), 'ks');

% plot location of chaser at final impulse

[rwrk, vwrk] = twobody2 (mu, tof, rwait, vwait);

plot(rwrk(1) / req, rwrk(2) / req, 'ko');

% plot location of final impulse

plot(x1(end), y1(end), 'k*');

if (twait > 0)
    
    % plot location of target at initial impulse

    [rwrk, vwrk] = twobody2 (mu, twait, r2i, v2i);

    plot(rwrk(1) / req, rwrk(2) / req, 'ks');
    
end

axis equal;

grid;

title('Two Impulse Phasing Analysis', 'FontSize', 16);

xlabel('x-component (ER)', 'FontSize', 12);

ylabel('y-component (ER)', 'FontSize', 12);

% create eps graphics file

print('-depsc', 'phasing.eps');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% primer vector graphical analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% perform primer vector initialization

pviniz(tof, rtoi, vtoi, dv1, dv2);

% number of graphic data points

npts = 300;

% plot behavior of primer vector magnitude

dt = tof / npts;

for i = 1:1:npts + 1

    t = (i - 1) * dt;

    if (t == 0)
        
        % initial value of primer magnitude and derivative

        pvm = norm(pvi);

        pvdm = dot(pvi, pvdi) / pvm;
        
    else
        
        % primer vector and derivative magnitudes at time t

        [pvm, pvdm] = pvector(rtoi, vtoi, t);
        
    end

    % load data array

    x2(i) = t;

    y2(i) = pvm;

    y3(i) = pvdm;

end

figure(2);

hold on;

plot(x2, y2, '-r');

plot(x2, y2, '.r');

title('Primer Vector Analysis', 'FontSize', 16);

xlabel('simulation time (seconds)', 'FontSize', 12);

ylabel('primer vector magnitude', 'FontSize', 12);

grid;

% create eps graphics file

print('-depsc', 'primer.eps');

% plot behavior of magnitude of primer derivative

figure(3);

hold on;

plot(x2, y3, '-r');

plot(x2, y3, '.r');

title('Primer Vector Analysis', 'FontSize', 16);

xlabel('simulation time (seconds)', 'FontSize', 12);

ylabel('primer derivative magnitude', 'FontSize', 12);

grid;

% create eps graphics file

print('-depsc', 'primer_der.eps');


