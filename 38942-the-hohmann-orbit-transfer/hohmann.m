% hohmann.m          July 9, 2013

% Hohmann two impulse orbit transfer between
% planar and non-coplanar circular orbits

% includes three-dimensional orbit graphics
% and graphical primer vector analysis

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global rtd dtr pvi pvdi

global mu req hn1 hn2 hn3 dinc

% astrodynamic and utility constants

om_constants;

% Brent root-finding tolerance

rtol = 1.0e-8;

% request inputs

clc; home;

fprintf('\nHohmann Orbit Transfer Analysis\n');

while (1)
    
    fprintf('\n\nplease input the initial altitude (kilometers)\n');
    
    alt1 = input('? ');
    
    if (alt1 > 0.0)
        break;
    end
    
end

while (1)
    
    fprintf('\n\nplease input the final altitude (kilometers)\n');
    
    alt2 = input('? ');
    
    if (alt2 > 0.0)
        break;
    end
    
end

while (1)
    
    fprintf('\n\nplease input the initial orbital inclination (degrees)');
    fprintf('\n(0 <= inclination <= 180)\n');
    
    inc1 = input('? ');
    
    if (inc1 >= 0.0 && inc1 <= 180.0)
        break;
    end
    
end

while (1)
    
    fprintf('\n\nplease input the final orbital inclination (degrees)');
    fprintf('\n(0 <= inclination <= 180)\n');
    
    inc2 = input('? ');
    
    if (inc2 >= 0.0 && inc2 <= 180.0)
        break;
    end
    
end

% convert orbit inclinations to radians

inc1 = inc1 * dtr;

inc2 = inc2 * dtr;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% solve the orbit transfer problem %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% calculate total inclination change (radians)

dinc = abs(inc2 - inc1);

% compute geocentric radii of initial and final orbits (kilometers)

r1 = req + alt1;

r2 = req + alt2;

% compute "normalized" radii

hn1 = sqrt(2.0 * r2 / (r2 + r1));

hn2 = sqrt(r1 / r2);

hn3 = sqrt(2.0 * r1 / (r2 + r1));

% compute "local circular velocity" of initial and final orbits (km/sec)

v1 = sqrt(mu / r1);

v2 = sqrt(mu / r2);

% compute transfer orbit semimajor axis (kilometers)

smat = 0.5 * (r1 + r2);

% compute transfer orbit eccentricity (non-dimensional)

ecct = (max(r1, r2) - min(r1, r2)) / (r1 + r2);

% compute transfer orbit perigee and apogee radii and velocities

rp = smat * (1.0 - ecct);

ra = smat * (1.0 + ecct);

vt1 = sqrt(2.0 * mu * ra / (rp * (rp + ra)));

vt2 = sqrt(2.0 * mu * rp / (ra * (rp + ra)));

% compute transfer orbit period (seconds)

taut = 2.0 * pi * sqrt(smat^3 / mu);

tof = 0.5 * taut;

if (abs(dinc) == 0)
    
    % coplanar orbit transfer
    
    if (r2 > r1)
        
        % higher-to-lower transfer
        
        dv1 = vt1 - v1;
        
        dv2 = v2 - vt2;
        
    else
        
        % lower-to-higher transfer
        
        dv1 = v1 - vt2;
        
        dv2 = vt1 - v2;
        
    end
    
    dinc1 = 0;
    
    dinc2 = 0;
    
    inct = inc1;
    
else
    
    % non-coplanar orbit transfer
    
    [xroot, froot] = brent('hohmfunc', 0, dinc, rtol);
    
    % calculate delta-v's
    
    dinc1 = xroot;
    
    dinc2 = dinc - dinc1;
    
    dv1 = v1 * sqrt(1.0 + hn1 * hn1 - 2.0 * hn1 * cos(dinc1));
    
    dv2 = v1 * sqrt(hn2 * hn2 * hn3 * hn3 + hn2 * hn2 ...
        - 2.0 * hn2 * hn2 * hn3 * cos(dinc2));
    
    if (inc2 > inc1)
        
        inct = inc1 + dinc1;
        
    else
        
        inct = inc1 - dinc1;
        
    end
    
end

% print results

clc; home;

fprintf('\nHohmann Orbit Transfer Analysis');
fprintf('\n-------------------------------\n\n');

fprintf('initial orbit altitude            %10.4f kilometers \n\n', alt1);

fprintf('initial orbit radius              %10.4f kilometers \n\n', alt1 + req);

fprintf('initial orbit inclination         %10.4f degrees \n\n', inc1 * rtd);

fprintf('initial orbit velocity            %10.4f meters/second \n\n\n', 1000.0 * v1);

fprintf('final orbit altitude              %10.4f kilometers \n\n', alt2);

fprintf('final orbit radius                %10.4f kilometers \n\n', alt2 + req);

fprintf('final orbit inclination           %10.4f degrees \n\n', inc2 * rtd);

fprintf('final orbit velocity              %10.4f meters/second \n', 1000.0 * v2);

fprintf('\n\nfirst inclination change          %10.4f degrees\n\n', dinc1 * rtd);

fprintf('second inclination change         %10.4f degrees\n\n', dinc2 * rtd);

fprintf('total inclination change          %10.4f degrees\n\n\n', rtd * (dinc1 + dinc2));

fprintf('first delta-v                     %10.4f meters/second \n\n', 1000.0 * dv1);

fprintf('second delta-v                    %10.4f meters/second \n\n', 1000.0 * dv2);

fprintf('total delta-v                     %10.4f meters/second \n\n\n', 1000.0 * (dv1 + dv2));

fprintf('transfer orbit semimajor axis     %10.4f kilometers \n\n', smat);

fprintf('transfer orbit eccentricity       %10.8f \n\n', ecct);

fprintf('transfer orbit inclination        %10.4f degrees \n\n', rtd * inct);

fprintf('transfer orbit perigee velocity   %10.4f meters/second \n\n', 1000.0 * vt1);

fprintf('transfer orbit apogee velocity    %10.4f meters/second \n\n', 1000.0 * vt2);

fprintf('transfer orbit coast time         %10.4f seconds \n', tof);

fprintf('                                  %10.4f minutes \n', tof / 60.0);

fprintf('                                  %10.4f hours \n\n', tof / 3600.0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create trajectory graphics %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load orbital elements arrays, create state vectors and plot orbits

oevi(1) = r1;
oevi(2) = 0.0;
oevi(3) = inc1;
oevi(4) = 0.0;
oevi(5) = 0.0;

% determine correct true anomaly (radians)

if (alt2 > alt1)
    
    oevi(6) = 0.0;
    
else
    
    oevi(6) = 180.0 * dtr;
    
end

[ri, vi] = orb2eci(mu, oevi);

oevti(1) = smat;
oevti(2) = ecct;
oevti(3) = inct;
oevti(4) = 0.0;
oevti(5) = 0.0;

% determine correct true anomaly (radians)

if (alt2 > alt1)
    
    oevti(6) = 0.0;
    
else
    
    oevti(6) = 180.0 * dtr;
    
end

[rti, vti] = orb2eci(mu, oevti);

oevtf(1) = smat;
oevtf(2) = ecct;
oevtf(3) = inct;
oevtf(4) = 0.0;
oevtf(5) = 0.0;

% determine correct true anomaly (radians)

if (alt2 > alt1)
    
    oevtf(6) = 180.0 * dtr;
    
else
    
    oevtf(6) = 0.0;
    
end

[rtf, vtf] = orb2eci(mu, oevtf);

oevf(1) = r2;
oevf(2) = 0.0;
oevf(3) = inc2;
oevf(4) = 0.0;
oevf(5) = 0.0;

% determine correct true anomaly (radians)

if (alt2 > alt1)
    
    oevf(6) = 180.0 * dtr;
    
else
    
    oevf(6) = 0.0;
    
end

[rf, vf] = orb2eci(mu, oevf);

% compute orbital periods

period1 = 2.0 * pi * oevi(1) * sqrt(oevi(1) / mu);

period2 = 2.0 * pi * oevti(1) * sqrt(oevti(1) / mu);

period3 = 2.0 * pi * oevf(1) * sqrt(oevf(1) / mu);

deltat1 = period1 / 300;

simtime1 = -deltat1;

deltat2 = 0.5 * period2 / 300;

simtime2 = -deltat2;

deltat3 = period3 / 300;

simtime3 = -deltat3;

for i = 1:1:301
    
    simtime1 = simtime1 + deltat1;
    
    simtime2 = simtime2 + deltat2;
    
    simtime3 = simtime3 + deltat3;
    
    % compute initial orbit "normalized" position vector
    
    [rwrk, vwrk] = twobody2 (mu, simtime1, ri, vi);
    
    rp1_x(i) = rwrk(1) / req;
    
    rp1_y(i) = rwrk(2) / req;
    
    rp1_z(i) = rwrk(3) / req;
    
    % compute transfer orbit position vector
    
    [rwrk, vwrk] = twobody2 (mu, simtime2, rti, vti);
    
    rp2_x(i) = rwrk(1) / req;
    
    rp2_y(i) = rwrk(2) / req;
    
    rp2_z(i) = rwrk(3) / req;
    
    % compute final orbit position vector
    
    [rwrk, vwrk] = twobody2 (mu, simtime3, rf, vf);
    
    rp3_x(i) = rwrk(1) / req;
    
    rp3_y(i) = rwrk(2) / req;
    
    rp3_z(i) = rwrk(3) / req;
    
end

figure(1);

% create axes vectors

xaxisx = [1 1.5];
xaxisy = [0 0];
xaxisz = [0 0];

yaxisx = [0 0];
yaxisy = [1 1.5];
yaxisz = [0 0];

zaxisx = [0 0];
zaxisy = [0 0];
zaxisz = [1 1.5];

figure (1);

hold on;

grid on;

% plot earth

[x y z] = sphere(24);

h = surf(x, y, z);

colormap([127/255 1 222/255]);

set (h, 'edgecolor', [1 1 1]);

% plot coordinate system axes

plot3(xaxisx, xaxisy, xaxisz, '-g', 'LineWidth', 1);

plot3(yaxisx, yaxisy, yaxisz, '-r', 'LineWidth', 1);

plot3(zaxisx, zaxisy, zaxisz, '-b', 'LineWidth', 1);

% plot initial orbit

plot3(rp1_x, rp1_y, rp1_z, '-r', 'LineWidth', 1.5);

plot3(rp1_x(1), rp1_y(1), rp1_z(1), 'ob');

% plot transfer orbit

plot3(rp2_x, rp2_y, rp2_z, '-b', 'LineWidth', 1.5);

plot3(rp2_x(end), rp2_y(end), rp2_z(end), 'ob');

% plot final orbit

plot3(rp3_x, rp3_y, rp3_z, '-g', 'LineWidth', 1.5);

xlabel('X coordinate (ER)', 'FontSize', 12);

ylabel('Y coordinate (ER)', 'FontSize', 12);

zlabel('Z coordinate (ER)', 'FontSize', 12);

title('Hohmann Transfer: Initial, Transfer and Final Orbits', 'FontSize', 16);

axis equal;

view(50, 20);

rotate3d on;

print -depsc -tiff -r300 hohmann1.eps

%%%%%%%%%%%%%%%%%%%%%%%%
% create primer graphics
%%%%%%%%%%%%%%%%%%%%%%%%

dvi = (vti - vi)';

dvf = (vf - vtf)';

% perform primer vector initialization

pviniz(tof, rti, vti, dvi, dvf);

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
        
        [pvm, pvdm] = pvector(rti, vti, t);
        
    end
    
    % load data array
    
    x1(i) = t / 60.0;
    
    y1(i) = pvm;
    
    y2(i) = pvdm;
    
end

figure(2);

hold on;

plot(x1, y1, '-r', 'LineWidth', 1.5);

plot(x1(1), y1(1), 'or');

plot(x1(end), y1(end), 'or');

title('Primer Vector Analysis of the Hohmann Transfer', 'FontSize', 16);

xlabel('simulation time (minutes)', 'FontSize', 12);

ylabel('primer vector magnitude', 'FontSize', 12);

grid;

% create eps graphics file with tiff preview

print -depsc -tiff -r300 primer.eps;

% plot behavior of magnitude of primer derivative

figure(3);

hold on;

plot(x1, y2, '-r', 'LineWidth', 1.5);

plot(x1(1), y2(1), 'or');

plot(x1(end), y2(end), 'or');

title('Primer Vector Analysis of the Hohmann Transfer', 'FontSize', 16);

xlabel('simulation time (minutes)', 'FontSize', 12);

ylabel('primer derivative magnitude', 'FontSize', 12);

grid;

% create eps graphics file with tiff preview

print -depsc -tiff -r300 primer_der.eps;


