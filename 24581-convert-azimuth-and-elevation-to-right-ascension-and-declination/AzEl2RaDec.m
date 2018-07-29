function [RA DEC] = AzEl2RaDec(Az,El,lat,lon,time)
% Programed by Darin C. Koblick 6/16/2009
%--------------------------------------------------------------------------
% Updated:                                                      Date:
% - quadrant check bug fix                                  1/22/2010
% - vectorized for speed                                    1/22/2010
%--------------------------------------------------------------------------
% External Function Call Sequence:
% [RA DEC] = AzEl2RaDec(0,0,0,-104,'1992/08/20 12:14:00')
%
% Worked Example pg. 262 Vallado
% [RA DEC] = AzEl2RaDec(210.8250667,23.8595052,39.007,-104.883,'1994/05/14 13:11:20.59856')
% [alpha_t,delta_t] = AzEl2RaDec(Beta,el,phi,lamda,'yyyy/mm/dd hh:mm:ss')
%
% Function Description:
%--------------------------------------------------------------------------
% AzEl2RaDec will take the Azimuth and Elevation in the local horizon
% reference frame, site latitude and longitude as well as a time in GMT
% and output the Right Ascension and Declination in the topocentric coordinate frame.
%
% Inputs:                                                       Format:
%--------------------------------------------------------------------------
% Local Azimuth Angle   (degrees)                               [N x 1]
% Local Elevation Angle (degrees)                               [N x 1]
% Lat (Site Latitude in degrees -90:90 -> S(-) N(+))            [N x 1]
% Lon (Site Longitude in degrees -180:180 W(-) E(+))            [N x 1]
% UTC (Coordinated Universal Time YYYY/MM/DD hh:mm:ss)          [N x 1]
%
% Outputs:                                                      Format:
%--------------------------------------------------------------------------
% Topocentric Right Ascension (Degrees)   [N x 1]
% Topocentric Declination Angle (Degrees)                       [N x 1]
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
ThetaGMST = mod((mod(ThetaGMST,86400.*(ThetaGMST./abs(ThetaGMST)))./240),360);
ThetaLST = ThetaGMST + lon;

%Algorithm 28
DEC = asind(sind(El).*sind(lat)+cosd(El).*cosd(lat).*cosd(Az));
LHA = atan2(-sind(Az).*cosd(El)./cosd(DEC), ...
    (sind(El)-sind(DEC).*sind(lat))./(cosd(DEC).*cosd(lat))).*(180/pi);
RA = mod(ThetaLST-LHA,360);

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