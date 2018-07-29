function [Az El] = SolarAzEl(UTC,Lat,Lon,Alt)
%% Revision History:
% Programed by Darin C. Koblick 2/17/2009
%
%              Darin C. Koblick 4/16/2013 Vectorized for Speed
%                                         Allow for MATLAB Datevec input in
%                                         addition to a UTC string.
%                                         Cleaned up comments and code to
%                                         avoid warnings in MATLAB editor.
%
%--------------------------------------------------------------------------
% External Function Call Sequence:
%[Az El] = SolarAzEl('1991/05/19 13:00:00',50,10,0)
%% Function Description:
% SolarAzEl will ingest a Universal Time, and specific site location on earth
% it will then output the solar Azimuth and Elevation angles relative to that
% site.
%
%% Input Description:
% UTC/DateVec:          [N x 1]         (Coordinated Universal Time 
%                                        yyyy/mm/dd HH:MM:SS) or MATLAB
%                                        Date vector if input is a double 
%                                        instead of a cell
%
% Lat:                  [N x 1]         (Site Latitude in degrees 
%                                       -90:90 -> S(-) N(+))
%
% Lon:                  [N x 1]         (Site Longitude in degrees 
%                                        -180:180 W(-) E(+))
%
% Alt:                  [N x 1]         Altitude of the site above sea 
%                                       level (km)
%
%% Output Description:
%Az                     [N x 1]         Azimuth location of the sun (deg)
%El                     [N x 1]         Elevation location of the sun (deg)
%
%
%% Source References:
%Solar Position obtained from:
%http://stjarnhimlen.se/comp/tutorial.html#5
%% Begin Code Sequence

%compute JD from UTC or datevec
if ischar(UTC)
    jd = juliandate(UTC,'yyyy/mm/dd HH:MM:SS');
else
    [y,mo,d,h,mi,s] = datevec(UTC);
    jd = juliandate(datestr([y,mo,d,h,mi,s],'yyyy/mm/dd HH:MM:SS'),'yyyy/mm/dd HH:MM:SS');
end
d = jd-2451543.5;

% Keplerian Elements for the Sun (geocentric)
w = 282.9404+4.70935e-5*d; %    (longitude of perihelion degrees)
%a = 1.000000;%                  (mean distance, a.u.)
e = 0.016709-1.151e-9.*d;%       (eccentricity)
M = mod(356.0470+0.9856002585.*d,360);%   (mean anomaly degrees)
L = w + M;                     %(Sun's mean longitude degrees)
oblecl = 23.4393-3.563e-7.*d;  %(Sun's obliquity of the ecliptic)

%auxiliary angle
E = M+(180/pi).*e.*sin(M.*(pi/180)).*(1+e.*cos(M.*(pi/180)));

%rectangular coordinates in the plane of the ecliptic (x axis toward
%perhilion)
x = cos(E.*(pi/180))-e;
y = sin(E.*(pi/180)).*sqrt(1-e.^2);

%find the distance and true anomaly
r = sqrt(x.^2 + y.^2);
v = atan2(y,x).*(180/pi);

%find the longitude of the sun
lon = v + w;

%compute the ecliptic rectangular coordinates
xeclip = r.*cos(lon.*(pi/180));
yeclip = r.*sin(lon.*(pi/180));
zeclip = 0.0;

%rotate these coordinates to equitorial rectangular coordinates
xequat = xeclip;
yequat = yeclip.*cos(oblecl.*(pi/180))+zeclip*sin(oblecl.*(pi/180));
zequat = yeclip.*sin(23.4406.*(pi/180))+zeclip*cos(oblecl.*(pi/180));

%convert equatorial rectangular coordinates to RA and Decl:
r = sqrt(xequat.^2 + yequat.^2 + zequat.^2)-(Alt./149598000); %roll up the altitude correction
RA = atan2(yequat,xequat).*(180/pi);
delta = asin(zequat./r).*(180/pi);

%Following the RA DEC to Az Alt conversion sequence explained here:
%http://www.stargazing.net/kepler/altaz.html

%Find the J2000 value
%J2000 = jd - 2451545.0;
hourvec = datevec(UTC);
UTH = hourvec(:,4) + hourvec(:,5)/60 + hourvec(:,6)/3600;

%Calculate local siderial time
GMST0=mod(L+180,360)./15;
SIDTIME = GMST0 + UTH + Lon./15;

%Replace RA with hour angle HA
HA = (SIDTIME.*15 - RA);

%convert to rectangular coordinate system
x = cos(HA.*(pi/180)).*cos(delta.*(pi/180));
y = sin(HA.*(pi/180)).*cos(delta.*(pi/180));
z = sin(delta.*(pi/180));

%rotate this along an axis going east-west.
xhor = x.*cos((90-Lat).*(pi/180))-z.*sin((90-Lat).*(pi/180));
yhor = y;
zhor = x.*sin((90-Lat).*(pi/180))+z.*cos((90-Lat).*(pi/180));

%Find the h and AZ 
Az = atan2(yhor,xhor).*(180/pi) + 180;
El = asin(zhor).*(180/pi);
end

function jd = juliandate(varargin)
% This sub function is provided in case juliandate does not come with your 
% distribution of Matlab
[year month day hour min sec] = datevec(datenum(varargin{:}));
idx = month <= 2;
year(idx) = year(idx)-1;
month(idx) = month(idx)+12;
jd = floor( 365.25*(year + 4716.0)) + floor( 30.6001*( month + 1.0)) + 2.0 - ...
    floor( year/100.0 ) + floor( floor( year/100.0 )/4.0 ) + day - 1524.5 + ...
    (hour + min/60 + sec/3600)/24;
end