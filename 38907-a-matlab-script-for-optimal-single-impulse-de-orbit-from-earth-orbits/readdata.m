function [fid, ta_lower, ta_upper] = readdata(filename)

% NOTE: all angular elements are returned in radians

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global jdate0 gst0 oevpo alttar fpatar

dtr = pi / 180.0;

% open data file

fid = fopen(filename, 'r');

% check for file open error

if (fid == -1)
    clc; home;
    fprintf('\n\n error: cannot find this file!!');
    keycheck;
    return;
end

% read 49 lines of data file

for i = 1:1:49

    cline = fgetl(fid);

    switch i
        case 8
            % month, day, year

            tl = size(cline);

            ci = findstr(cline, ',');

            % extract month, day and year

            month = str2double(cline(1:ci(1)-1));

            day = str2double(cline(ci(1)+1:ci(2)-1));

            year = str2double(cline(ci(2)+1:tl(2)));
        case 11
            % UTC epoch

            utstr = cline;

            tl = size(utstr);

            ci = findstr(utstr, ',');

            % extract hours, minutes and seconds

            utc_hr = str2double(utstr(1:ci(1)-1));

            utc_min = str2double(utstr(ci(1)+1:ci(2)-1));

            utc_sec = str2double(utstr(ci(2)+1:tl(2)));
        case 18
            % semimajor axis (kilometers)
            
            oevpo(1) = str2double(cline);
        case 21
            % orbital eccentricity
            
            oevpo(2) = str2double(cline);
        case 24
            % orbital inclination
            
            oevpo(3) = dtr * str2double(cline);           
        case 27
            % argument of perigee

            oevpo(4) = dtr * str2double(cline);
        case 30
            % RAAN

            oevpo(5) = dtr * str2double(cline);
        case 33
            % true anomaly

            oevpo(6) = dtr * str2double(cline);
        case 36
            % lower bound on true anomaly

            ta_lower = dtr * str2double(cline);
        case 39
            % upper bound on true anomaly

            ta_upper = dtr * str2double(cline);
        case 46
            % EI geodetic altitude

            alttar = str2double(cline);
        case 49
            % EI flight path angle

            fpatar = dtr * str2double(cline);     
    end
end

status = fclose(fid);

day = day + utc_hr / 24.0 + utc_min / 1440.0 + utc_sec / 86400.0;

jdate0 = julian(month, day, year);

gst0 = gast1(jdate0);


