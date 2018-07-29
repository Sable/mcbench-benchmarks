%----------------------------- Begin Function -----------------------------
%Purpose:
%--------
%Convert a specified Julian Date Vector to Greenwhich Apparent Sidereal Time.
%
%Inputs:
%-------
%JD             [N x M x L]                         Julian Date Vector                      
%       
%
%Outputs:
%--------
%GAST           [N x M x L]                         Greenwich Apparent Sidereal
%                                                   Time in degrees from
%                                                   0-360
%
%References:
%-----------
%Approximate Sidereal Time, 
%http://www.usno.navy.mil/USNO/astronomical-applications/...
%astronomical-information-center/approx-sider-time
%
%Universal Sidereal Times, The Astronomical Almanac For The Year 2004
%
%Programed by: 
%-------------
%Darin Koblick 07-17-2010
%--------------------------------------------------------------------------
function GAST = JD2GAST(JD)
%THETAm is the mean siderial time in degrees
THETAm = JD2GMST(JD);

%Compute the number of centuries since J2000
T = (JD - 2451545.0)./36525;

%Mean obliquity of the ecliptic (EPSILONm)
% see http://www.cdeagle.com/ccnum/pdf/demogast.pdf equation 3
EPSILONm = 84381448-46.8150.*T - .00059.*(T.^2) + .001813.*(T.^3);

%Nutations in obliquity and longitude (degrees)
% see http://www.cdeagle.com/ccnum/pdf/demogast.pdf equation 4
L = 280.4665 + 36000.7698.*T;
dL = 218.3165 + 481267.8813.*T;
OMEGA = 125.04452 - 1934.136261.*T;

%Calculate nutations using the following two equations:
% see http://www.cdeagle.com/ccnum/pdf/demogast.pdf equation 5
dPSI = -17.20.*sind(OMEGA) - 1.32.*sind(2.*L) - .23.*sind(2.*dL) ...
    + .21.*sind(2.*OMEGA);
dEPSILON = 9.20.*cosd(OMEGA) + .57.*cosd(2.*L) + .10.*cosd(2.*dL) - ...
    .09.*cosd(2.*OMEGA);

%Convert the units from arc-seconds to degrees
dPSI = dPSI.*(1/3600);
dEPSILON = dEPSILON.*(1/3600);

%(GAST) Greenwhich apparent sidereal time expression in degrees
% see http://www.cdeagle.com/ccnum/pdf/demogast.pdf equation 1
GAST = mod(THETAm + dPSI.*cosd(EPSILONm+dEPSILON),360);



