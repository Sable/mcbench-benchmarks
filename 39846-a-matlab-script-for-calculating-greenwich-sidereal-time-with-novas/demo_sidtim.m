% demo_sidtim.m        January 14, 2012

% this script demonstrates how to interact
% interact with the NOVAS sidtim.m function

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

global inutate imode lmode psicor epscor

% set corrections to zero

psicor = 0;

epscor = 0;

% initialize mode flags

imode = 2;

lmode = 2;

% initialize nutation algorithm

inutate = 1;

%%%%%%%%%%%%%%%%%%%%%%
% set calculation mode
%%%%%%%%%%%%%%%%%%%%%%

% set mode = 0 for cio-based method, full accuracy
% set mode = 1 for cio-based method, reduced accuracy
% set mode = 2 for equinox-based method, full accuracy
% set mode = 3 for equinox-based method, reduced accuracy

setmod(2);

clc; home;
   
fprintf('\ndemo_sidtim - demonstrates how to use the NOVAS sidtim.m function\n');

mode = getmod;

if (mode == 0)
    
    fprintf('\ncio-based method, full accuracy\n');
    
end

if (mode == 1)
    
    fprintf('\ncio-based method, reduced accuracy\n');
    
end

if (mode == 2)
    
    fprintf('\nequinox-based method, full accuracy\n');
    
end

if (mode == 3)
    
    fprintf('\nequinox-based method, reduced accuracy\n');
    
end

% UTC calendar date

month = 4;
day = 24;
year = 2008;

% UTC epoch

utc_hr = 10;
utc_min = 36.0;
utc_sec = 18.0;

jdutc = julian(month, day + utc_hr / 24.0d0 + utc_min / 1440.0 ...
    + utc_sec / 86400.0, year);
   
% number of leap seconds

leaps = 33.0;

% UT1 - UTC in seconds

ut1utc = -0.387845d0;

% define and set value of delta-t (seconds)

deltat = 32.184d0 + leaps - ut1utc;

setdt(deltat);

% compute tt julian date

jdtt = jdutc + (leaps + 32.184d0) / 86400.0;

% compute ut1 julian date

jdut1 = jdutc + ut1utc / 86400.0d0;

% compute apparent sidereal time

k = 1;

gast = sidtim (jdut1, 0.0d0, k);

% print results

[cdstr, utstr] = jd2str(jdutc);

fprintf('\nUTC calendar date         ');

disp(cdstr);

fprintf('\nUTC time                  ');

disp(utstr);

fprintf('\n\nUTC Julian date             %14.8f \n', jdutc);

fprintf('\nUT1 Julian date             %14.8f \n', jdut1);

fprintf('\nTT Julian date              %14.8f \n', jdtt);

fprintf('\n\napparent sidereal time  %14.8f hours\n', gast);

fprintf('\napparent sidereal time  %14.8f degrees\n', 360.0 * (gast / 24.0));

fprintf('\n\nnumber of leap seconds  %14.8f \n', leaps);

fprintf('\nUT1 - UTC               %14.8f seconds\n', ut1utc);

fprintf('\ndelta-t                 %14.8f seconds\n\n', deltat);



