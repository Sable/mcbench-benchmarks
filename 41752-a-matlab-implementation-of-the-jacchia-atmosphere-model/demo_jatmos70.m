% demo_jatmos70        May 15, 2013

% this script demonstrates how to interact with
% the j70iniz and jatmos70 functions which compute
% the properties of the atmosphere using the Jacchia
% 1970 model with MET modifications

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

rtd = 180.0 / pi;

dtr = pi / 180.0;

% initialize the algorithm

j70iniz;

% algorithm inputs

%  indata(1)  = geodetic altitude (kilometers)
%  indata(2)  = geodetic latitude (radians)
%  indata(3)  = geographic longitude (radians)
%  indata(4)  = calendar year (all digits)
%  indata(5)  = calendar month
%  indata(6)  = calendar day
%  indata(7)  = utc hours
%  indata(8)  = utc minutes
%  indata(9)  = geomagnetic index type
%               (1 = indata(12) is Kp, 2 = indata(12) is Ap)
%  indata(10) = solar radio noise flux (jansky)
%  indata(11) = 162-day average F10 (jansky)
%  indata(12) = geomagnetic activity index

indata(1) = 303.04166;
indata(2) = -21.0 * dtr;
indata(3) = 36.0 * dtr;
indata(4) = 1979;
indata(5) = 6;
indata(6) = 3;
indata(7) = 0;
indata(8) = 0;
indata(9) = 2;
indata(10) = 60.07;
indata(11) = 109.56;
indata(12) = 9.3;

day = indata(6) + indata(7) / 24.0 + indata(8) / 1440.0;

jdate = julian(indata(5), day, indata(4));

[cdstr, utstr] = jd2str(jdate);

% compute atmospheric properties

outdata = jatmos70(indata);

% algorithm outputs

%  outdata(1)  = exospheric temperature (deg K)
%  outdata(2)  = temperature at altitude (deg K)
%  outdata(3)  = N2 number density (per meter-cubed)
%  outdata(4)  = O2 number density (per meter-cubed)
%  outdata(5)  = O number density (per meter-cubed)
%  outdata(6)  = A number density (per meter-cubed)
%  outdata(7)  = He number density (per meter-cubed)
%  outdata(8)  = H number density (per meter-cubed)
%  outdata(9)  = average molecular weight
%  outdata(10) = total density (kilogram/meter-cubed)
%  outdata(11) = log10(total density)
%  outdata(12) = total pressure (pascals)

% print results

clc; home;

fprintf('\ndemo_jatmos70\n\n');

fprintf('\ncalendar date       ');

disp(cdstr);

fprintf('\nuniversal time       ');

disp(utstr);

fprintf('\n\ngeodetic altitude            %12.4f kilometers \n', indata(1));

fprintf('\ngeodetic latitude            %12.4f degrees \n', rtd * indata(2));

fprintf('\neast longitude               %12.4f degrees \n', rtd * indata(3));

fprintf('\nsolar radio noise flux       %12.4f jansky \n', indata(10));

fprintf('\n162-day average F10          %12.4f jansky \n', indata(11));

fprintf('\ngeomagnetic activity index   %12.4f \n', indata(12));

fprintf('\n\nexospheric temperature       %12.4f degrees K\n', outdata(1));

fprintf('\ntemperature                  %12.4f degrees K\n', outdata(2));

fprintf('\ntotal density             %12.8e kg/m**3\n', outdata(10));

fprintf('\ntotal pressure            %12.8e pascals\n', outdata(12));

fprintf('\naverage molecular weight  %12.8e \n\n', outdata(9));

