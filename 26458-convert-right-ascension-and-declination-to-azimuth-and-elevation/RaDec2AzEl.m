function [Az El] = RaDec2AzEl(Ra,Dec,lat,lon,time)
% Programed by Darin C. Koblick 01/23/2010
%--------------------------------------------------------------------------
% External Function Call Sequence:
% [Az El] = RaDec2AzEl(0,0,0,-104,'1992/08/20 12:14:00')
%
% Worked Example: pg. 262 Vallado
%[Az El] = RaDec2AzEl(294.9891115,-20.8235624,39.007,-104.883,'1994/05/14 13:11:20.59856')
%[210.7514  23.9036] = RaDec2AzEl(294.9891115,-20.8235624,39.007,-104.883,'1994/05/14 13:11:20.59856')
%
% Worked Example: http://www.stargazing.net/kepler/altaz.html
% [Az El] = RaDec2AzEl(344.95,42.71667,52.5,-1.91667,'1997/03/14 19:00:00')
% [311.92258 22.40100] = RaDec2AzEl(344.95,42.71667,52.5,-1.91667,'1997/03/14 19:00:00')
%
% [Beta,el] = RaDec2AzEl(alpha_t,delta_t,phi,lamda,'yyyy/mm/dd hh:mm:ss')
%
% Function Description:
%--------------------------------------------------------------------------
% RaDec2AzEl will take the Right Ascension and Declination in the topocentric 
% reference frame, site latitude and longitude as well as a time in GMT
% and output the Azimuth and Elevation in the local horizon
% reference frame.
%
% Inputs:                                                       Format:
%--------------------------------------------------------------------------
% Topocentric Right Ascension (Degrees)                         [N x 1]
% Topocentric Declination Angle (Degrees)                       [N x 1]
% Lat (Site Latitude in degrees -90:90 -> S(-) N(+))            [N x 1]
% Lon (Site Longitude in degrees -180:180 W(-) E(+))            [N x 1]
% UTC (Coordinated Universal Time YYYY/MM/DD hh:mm:ss)          [N x 1]
%
% Outputs:                                                      Format:
%--------------------------------------------------------------------------
% Local Azimuth Angle   (degrees)                               [N x 1]
% Local Elevation Angle (degrees)                               [N x 1]
%
%
% External Source References:
% Fundamentals of Astrodynamics and Applications 
% D. Vallado, Second Edition
% Example 3-5. Finding Local Siderial Time (pg. 192) 
% Algorithm 28: AzElToRaDec (pg. 259)
% -------------------------------------------------------------------------

%Example 3-5
[yyyy mm dd HH MM SS] = datevec(datenum(time,'yyyy/mm/dd HH:MM:SS'));
JD = juliandate(yyyy,mm,dd,HH,MM,SS);
T_UT1 = (JD-2451545)./36525;
ThetaGMST = 67310.54841 + (876600*3600 + 8640184.812866).*T_UT1 ...
+ .093104.*(T_UT1.^2) - (6.2*10^-6).*(T_UT1.^3);
ThetaGMST = mod((mod(ThetaGMST,86400*(ThetaGMST./abs(ThetaGMST)))/240),360);
ThetaLST = ThetaGMST + lon;

%Equation 4-11 (Define Siderial Time LHA)
LHA = mod(ThetaLST - Ra,360);

%Equation 4-12 (Elevation Deg)
El = asind(sind(lat).*sind(Dec)+cosd(lat).*cosd(Dec).*cosd(LHA));

%Equation 4-13 / 4-14 (Adaptation) (Azimuth Deg)
%Az = mod(atand(-(sind(LHA).*cosd(Dec)./(cosd(lat).*sind(Dec) - sind(lat).*cosd(Dec).*cosd(LHA)))),360);
Az = mod(atan2(-sind(LHA).*cosd(Dec)./cosd(El),...
    (sind(Dec)-sind(El).*sind(lat))./(cosd(El).*cosd(lat))).*(180/pi),360);


function jd = juliandate(year, month, day, hour, min, sec) 
YearDur = 365.25;
for i = length(month):-1:1
    if (month(i)<=2)
        year(i)=year(i)-1;
        month(i)=month(i)+12;
    end
end
A = floor(YearDur*(year+4716));
B = floor(30.6001*(month+1));
C = 2;
D = floor(year/100);
E = floor(floor(year/100)*.25);
F = day-1524.5;
G = (hour+(min/60)+sec/3600)/24;
jd =A+B+C-D+E+F+G;