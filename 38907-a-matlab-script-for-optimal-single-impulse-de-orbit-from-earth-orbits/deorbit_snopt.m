% deorbit_snopt.m      July 17, 2013

% optimal single impulse deorbit from Earth orbits

% shooting method with SNOPT NLP algorithm

% control variables

%  maneuver true anomaly
%  x-component of deorbit delta-v vector
%  y-component of deorbit delta-v vector
%  z-component of deorbit delta-v vector
%  flight time from maneuver to entry interface

% objective function

%  deorbit delta-v magnitude

% mission constraints

%  geodetic altitude at entry interface
%  relative flight path angle at entry interface

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

global mu req flat omega j2 jdate0 oevpo jdatei

global alttar fpatar rei vei dtof

dtr = pi / 180.0;

rtd = 180.0 / pi;

% earth gravitational constant (km**3/sec**2)

mu = 398600.4415;

% equatorial radius of the Earth (kilometers)

req = 6378.1363;

% earth flattening factor (non-dimensional)

flat = 1.0 / 298.257;

% earth inertial rotation rate (radians/second)

omega = 7.292115486e-5;

% earth j2 gravitational constant (non-dimensional)

j2 = 0.00108263;

% request file name and read data

clc; home;

[filename, pathname] = uigetfile('*.in', 'Please select the input file to read');

[fid, ta_lower, ta_upper] = readdata(filename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up and solve deorbit targeting problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('\n\nplease wait, solving EI targeting problem ...\n\n');

% compute initial guess for deorbit delta-v vector (kilometers/second)

[dvg, dtof] = deltav_guess(oevpo, alttar, fpatar);

% load initial guesses for control variables

xg(1) = oevpo(6);

xg(2) = dvg(1);

xg(3) = dvg(2);

xg(4) = dvg(3);

xg(5) = dtof;

xg = xg';

% lower and upper bounds for deorbit true anomaly (radians)

xlwr(1) = ta_lower;

xupr(1) = ta_upper;

% lower and upper bounds for components of
% deorbit delta-v vector (kilometers/second)

dvm = norm(dvg);

xlwr(2:4) = -(dvm + 0.1 * dvm);

xupr(2:4) = +(dvm + 0.1 * dvm);

% lower and upper bounds for flight time
% from maneuver to entry interface (seconds)

xlwr(5) = dtof - 30.0;

xupr(5) = dtof + 30.0;

xlwr = xlwr';

xupr = xupr';

% bounds on objective function

flow(1) = 0.0d0;

fupp(1) = +Inf;

% geodetic altitude at entry interface equality constraint

flow(2) = 0.0d0;
fupp(2) = 0.0d0;

% relative flight path angle at entry interface equality constraint

flow(3) = 0.0d0;
fupp(3) = 0.0d0;

flow = flow';

fupp = fupp';

% set no derivatives option for SNOPT

snseti('derivative option', 0);

% solve NLP problem using SNOPT

[x, f, inform, xmul, fmul] = snopt(xg, xlwr, xupr, flow, fupp, 'deorbit_shoot');

% final deorbit delta-v (kilometers/second)

deorb_dv = x(2:4);

% print results

[cdstr, utstr] = jd2str(jdate0);

fprintf('\n\n****************************************');
fprintf('\nsingle impulse deorbit from Earth orbits');
fprintf('\n****************************************\n');

fprintf('\ntime and conditions prior to deorbit maneuver');
fprintf('\n---------------------------------------------\n');

fprintf('\ncalendar date      ');

disp(cdstr);

fprintf('\nUTC time           ');

disp(utstr);

oevwrk1 = oevpo;

oevwrk1(6) = x(1);

oeprint1(mu, oevwrk1);

[reci, veci] = orb2eci(mu, oevwrk1);

svprint(reci, veci);

fprintf('\ndeorbit delta-v vector and magnitude');
fprintf('\n------------------------------------\n');

fprintf('\nx-component of delta-v      %12.6f  meters/second', 1000.0 * deorb_dv(1));

fprintf('\ny-component of delta-v      %12.6f  meters/second', 1000.0 * deorb_dv(2));

fprintf('\nz-component of delta-v      %12.6f  meters/second', 1000.0 * deorb_dv(3));

fprintf('\n\ntotal delta-v               %12.6f  meters/second\n', 1000.0 * norm(deorb_dv));

upeci = deorb_dv / norm(deorb_dv);

fprintf('\n\ndeorbit delta-v pointing angles');
fprintf('\n-------------------------------\n');

[pitch, yaw] = ueci2angles(reci, veci, upeci);

fprintf('\npitch angle                 %12.6f  degrees', rtd * pitch);

fprintf('\n\nyaw angle                   %12.6f  degrees\n', rtd * yaw);

fprintf('\n\ntime and conditions after deorbit maneuver');
fprintf('\n------------------------------------------\n');

fprintf('\ncalendar date      ');

disp(cdstr);

fprintf('\nUTC time           ');

disp(utstr);

% velocity vector after maneuver (kilometers/second)

vecti = veci + x(2:4);

oevwrk = eci2orb1(mu, reci, vecti);

oeprint1(mu, oevwrk);

svprint(reci, vecti);

fprintf('\ntime and conditions at entry interface');
fprintf('\n--------------------------------------\n');

[cdstr, utstr] = jd2str(jdatei);

fprintf('\ncalendar date      ');

disp(cdstr);

fprintf('\nUTC time           ');

disp(utstr);

oev = eci2orb1(mu, rei, vei);

oeprint1(mu, oev);

svprint(reci, vei);

% compute relative flight path coordinates

gast = gast1(jdatei);

fpc = eci2fpc1(gast, rei, vei);

fprintf('\nrelative flight path coordinates at entry interface\n');
fprintf('---------------------------------------------------\n\n');

fprintf('east longitude            %14.8f  degrees \n\n', rtd * fpc(1));

fprintf('geocentric declination    %14.8f  degrees \n\n', rtd * fpc(2));

fprintf('flight path angle         %14.8f  degrees \n\n', rtd * fpc(3));

fprintf('relative azimuth          %14.8f  degrees \n\n', rtd * fpc(4));

fprintf('position magnitude        %14.8f  kilometers \n\n', fpc(5));

fprintf('velocity magnitude        %14.8f  kilometers/second \n\n', fpc(6));

% compute geodetic coordinates

[alt, lat] = geodet1 (fpc(5), fpc(2));

fprintf('\ngeodetic coordinates at entry interface\n');
fprintf('---------------------------------------\n\n');

fprintf('geodetic latitude         %14.8f  degrees \n\n', rtd * lat);

fprintf('geodetic altitude         %14.8f  kilometers \n\n', alt);

% flight time from maneuver to entry interface (minutes)

tof3 = 1440.0 * (jdatei - jdate0);

fprintf('\nflight time from maneuver to EI  %14.8f  minutes \n\n', tof3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create trajectory graphics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compute orbital period of initial orbit

period1 = 2.0 * pi * oevwrk1(1) * sqrt(oevwrk1(1) / mu);

deltat1 = period1 / 300;

simtime1 = -deltat1;

% create graphics data for initial orbit

for i = 1:1:301
    
    simtime1 = simtime1 + deltat1;
    
    % compute initial orbit "normalized" position vector
    
    [rwrk, vwrk] = twobody2 (mu, simtime1, reci, veci);
    
    rp1_x(i) = rwrk(1) / req;
    
    rp1_y(i) = rwrk(2) / req;
    
    rp1_z(i) = rwrk(3) / req;
    
end

% define ode45 options

options = odeset('RelTol', 1.0e-8, 'AbsTol', 1.0e-10);

% create graphics data for de-orbit trajectory

[twrk, ysol] = ode45(@j2eqm, [0 60.0 * tof3], [reci vecti], options);

rwrk = ysol(:, 1:3) / req;

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

% plot de-orbit trajectory

plot3(rwrk(:, 1), rwrk(:, 2), rwrk(:, 3), '-b', 'LineWidth', 1.5);

plot3(rwrk(end, 1), rwrk(end, 2), rwrk(end, 3), 'ob');

xlabel('X coordinate (ER)', 'FontSize', 12);

ylabel('Y coordinate (ER)', 'FontSize', 12);

zlabel('Z coordinate (ER)', 'FontSize', 12);

title('Optimal Single Impulse De-orbit', 'FontSize', 16);

axis equal;

view(-75, 20);

rotate3d on;

print('-depsc', 'deorbit_snopt.eps');

saveas(h, 'deorbit_snopt.fig');
