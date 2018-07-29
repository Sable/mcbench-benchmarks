% demo_fpeqm       May 28, 2008

% this script demonstrates how to interact with
% the flight path equations of motion function

% STS maximum crossrange example

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

global rkcoef ad76

global tdata aoadata bankdata

global req mu omega mass sref

% define angular conversion factors

rtd = 180.0 / pi;

dtr = pi / 180.0;

% radius of the earth (kilometers)

req = 6378.14;

% gravitational constant of the earth (km**3/second**2)

mu = 398600.4415;

% earth rotation rate (radians/second)

omega = 7.2921151467d-5;

% initialize rkf78 function

rkcoef = 1;

% ---------------------------------
% define propulsion characteristics
% ---------------------------------

% aerodynamic reference area (km**2)

sref = 2.499091776e-4;

% read atmospheric density data

[fid, ad76] = read76;

% ------------------------------
% read flight controls data file
% ------------------------------

m = csvread('sts_cr.csv');

tdata = m(:, 1);

aoadata = dtr * m(:, 2);

bankdata = dtr * m(:, 3);

ndata = size(tdata);

% --------------------------------------
% define initial flight path coordinates
% --------------------------------------

% altitude (kilometers)

xalt = 121.92;

% relative velocity (kilometers/second)

vrel = 7.80288;

% geographic declination (degrees)

dec = 0.0d0;

% geographic longitude (degrees)

elon = 0.0d0;

% azimuth (degrees)

azim = 90.0d0;

% flight path angle (degrees)

fpa = -2.39780555815067d0;

% vehicle mass (kilograms)

mass = 92079.25;

% -------------------------------
% load initial integration vector
% -------------------------------

% geocentric altitude (kilometers)

yi(1) = xalt;

% longitude (radians)

yi(2) = dtr * elon;

% geocentric declination

yi(3) = dtr * dec;

% relative speed (kilometers/second)

yi(4) = vrel;

% flight path angle (radians)

yi(5) = dtr * fpa;

% flight azimuth (radians)

yi(6) = dtr * azim;

fprintf('\n\nprogram demo_fpeqm\n');

fprintf('\ninitial flight path coordinates');
fprintf('\n-------------------------------');

fprintf('\n\naltitude           %14.4f meters', 1000.0 * yi(1));

fprintf('\nvelocity           %14.4f meters/second', 1000.0 * yi(4));

fprintf('\ndeclination        %14.4f degrees', rtd * yi(3));

fprintf('\nlongitude          %14.4f degrees', rtd * yi(2));

fprintf('\nazimuth            %14.4f degrees', rtd * yi(6));

fprintf('\nflight path angle  %14.4f degrees\n\n', rtd * yi(5));

% data generation step size (seconds)

deltat = 5.0d0;

% final simulation time (seconds)

tfinal = tdata(end);

% number of differential equations

neq = 6;

% truncation error tolerance

tetol = 1.0d-10;

tf = 0.0d0;

nplot = 0;

% integrate equations of motion and create data arrays

while (1)

    h = 1.0d0;

    ti = tf;

    tf = ti + deltat;

    if (tf > tfinal)
        tf = tfinal;
    end

    % evaluate lift and drag coefficients

    alt = yi(1);

    alpha = interp1(tdata, aoadata, ti, 'cubic');

    bank = interp1(tdata, bankdata, ti, 'cubic');

    yf = rkf78 ('fpeqms', neq, ti, tf, h, tetol, yi);

    % load data arrays for plotting

    nplot = nplot + 1;

    % simulation time (seconds)

    xplot(nplot) = ti;

    % altitude (meters)

    yplot1(nplot) = 1000.0 * alt;

    % angle-of-attack (degrees)

    yplot2(nplot) = rtd * alpha;

    % bank angle (degrees)

    yplot3(nplot) = rtd * bank;

    % longitude (degrees)

    yplot4(nplot) = rtd * yf(2);

    % declination (degrees)

    yplot5(nplot) = rtd * yf(3);

    % velocity (meters/second)

    yplot6(nplot) = 1000.0 * yf(4);

    % flight path angle (degrees)

    yplot7(nplot) = rtd * yf(5);

    % azimuth (degrees)

    yplot8(nplot) = rtd * yf(6);

    if (tf == tfinal)
        break
    end

    % reload integration vector

    yi = yf;
end

fprintf('\n\nfinal flight path coordinates');
fprintf('\n-----------------------------');

fprintf('\n\naltitude           %14.4f meters', 1000.0 * yf(1));

fprintf('\nvelocity           %14.4f meters/second', 1000.0 * yf(4));

fprintf('\ndeclination        %14.4f degrees', rtd * yf(3));

fprintf('\nlongitude          %14.4f degrees', rtd * yf(2));

fprintf('\nazimuth            %14.4f degrees', rtd * yf(6));

fprintf('\nflight path angle  %14.4f degrees\n\n', rtd * yf(5));

% plot altitude

plot(xplot, yplot1);

title('STS Maximum Crossrange', 'FontSize', 16);

xlabel('simulation time (seconds)', 'FontSize', 12);

ylabel('altitude (meters)', 'FontSize', 12);

grid;

print -depsc -tiff -r300 demo_fpeqm1.eps;

% plot speed

figure;

plot(xplot, yplot6);

title('STS Maximum Crossrange', 'FontSize', 16);

xlabel('simulation time (seconds)', 'FontSize', 12);

ylabel('speed (meters/second)', 'FontSize', 12);

grid;

print -depsc -tiff -r300 demo_fpeqm2.eps;

% plot flight path angle

figure;

plot(xplot, yplot7);

title('STS Maximum Crossrange', 'FontSize', 16);

xlabel('simulation time (seconds)', 'FontSize', 12);

ylabel('flight path angle (degrees)', 'FontSize', 12);

grid;

print -depsc -tiff -r300 demo_fpeqm3.eps;

% plot azimuth angle

figure;

plot(xplot, yplot8);

title('STS Maximum Crossrange', 'FontSize', 16);

xlabel('simulation time (seconds)', 'FontSize', 12);

ylabel('azimuth angle (degrees)', 'FontSize', 12);

grid;

print -depsc -tiff -r300 demo_fpeqm4.eps;

% plot declination

figure;

plot(xplot, yplot5);

title('STS Maximum Crossrange', 'FontSize', 16);

xlabel('simulation time (seconds)', 'FontSize', 12);

ylabel('declination (degrees)', 'FontSize', 12);

grid;

print -depsc -tiff -r300 demo_fpeqm5.eps;

% plot longitude

figure;

plot(xplot, yplot4);

title('STS Maximum Crossrange', 'FontSize', 16);

xlabel('simulation time (seconds)', 'FontSize', 12);

ylabel('longitude (degrees)', 'FontSize', 12);

grid;

print -depsc -tiff -r300 demo_fpeqm6.eps;

% plot declination versus longitude

figure;

plot(yplot4, yplot5);

title('STS Maximum Crossrange', 'FontSize', 16);

xlabel('longitude (degrees)', 'FontSize', 12);

ylabel('declination (degrees)', 'FontSize', 12);

grid;

print -depsc -tiff -r300 demo_fpeqm7.eps;

% plot angle-of-attack

figure;

plot(xplot, yplot2);

title('STS Maximum Crossrange', 'FontSize', 16);

xlabel('simulation time (seconds)', 'FontSize', 12);

ylabel('angle-of-attack (degrees)', 'FontSize', 12);

grid;

print -depsc -tiff -r300 demo_fpeqm8.eps;

% plot bank angle

figure;

plot(xplot, yplot3);

title('STS Maximum Crossrange', 'FontSize', 16);

xlabel('simulation time (seconds)', 'FontSize', 12);

ylabel('bank angle (degrees)', 'FontSize', 12);

grid;

print -depsc -tiff -r300 demo_fpeqm9.eps;
