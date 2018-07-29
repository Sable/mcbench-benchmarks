function [x,y]=polarstereo_fwd(phi,lambda,a,e,phi_c,lambda_0)
%POLARSTEREO_FWD transforms lat/lon data to map coordinates for a polar stereographic system
%   [X,Y]=POLARSTEREO_FWD(LAT,LONG,EARTHRADIUS,ECCENTRICITY,LAT_TRUE,LON_POSY) 
%   X and Y are the map coordinates (scalars, vectors, or matrices of equal size).
%   LAT and LON are in decimal degrees with negative numbers (-) for S and W. 
%   EARTHRADIUS is the radius of the earth defined in the projection
%       (default is 6378137.0 m, WGS84)
%   ECCENTRICITY is the earth's misshapenness 
%       (default is 0.08181919)
%   LAT_TRUE is the latitude of true scale in degrees, aka standard parallel 
%       (default is -70). Note that some NSIDC data use 70 and some use 71.
%   LON_POSY is the meridian in degrees along the positive Y axis of the map 
%       (default is 0)
%   
%   The National Snow and Ice Data Center (NSIDC) and Scientific Committee
%   on Antarctic Research (SCAR) use a version of the polar stereographic
%   projection that Matlab does not have. This file does transformations to
%   map coordinates from geographic coordinates to facilitate
%   comparisons with other datasets.
%
%   Equations from: Map Projections - A Working manual - by J.P. Snyder. 1987 
%   http://kartoweb.itc.nl/geometrics/Publications/Map%20Projections%20-%20A%20Working%20manual%20-%20by%20J.P.%20Snyder.pdf
%   See the section on Polar Stereographic, with a south polar aspect and
%   known phi_c not at the pole.
%
%   See also: MINVTRAN, MFWDTRAN.
%
%   Written by Andy Bliss, 9/12/2011

%   Changes since version 01:
%       1. Split into two functions and vectorized code.

%%%%%%%%%%%%%
%some standard info
%%%%%%%%%%%%%
%WGS84 - radius: 6378137.0 eccentricity: 0.08181919
%   in Matlab: axes2ecc(6378137.0, 6356752.3142)
%Hughes ellipsoid - radius: 6378.273 km eccentricity: 0.081816153
%   Used for SSM/I  http://nsidc.org/data/polar_stereo/ps_grids.html
%International ellipsoid (following Snyder) - radius: 6378388.0 eccentricity: 0.0819919 

%{
%check the code using Snyder's example. Should get x=-1540033.6; y=-560526.4;
phi=-75; lambda=150;
[x,y]=polarstereo_fwd(phi,lambda,6378388.0,0.0819919,-71,-100);
x,y

%%%%%%%%%%%%
%check with AntDEM
%%%%%%%%%%%%
%http://nsidc.org/data/docs/daac/nsidc0304_0305_glas_dems.gd.html
% Center Point of Corner Grid Cell
%x	y	Latitude	Longitude
test=[-2812000.0  2299500.0   -57.3452815 -50.7255753
    2863500.0   2299500.0   -57.0043684 51.2342036
    -2812000.0  -2384000.0  -56.8847122 -130.2911169
    2863500.0   -2384000.0  -56.5495152  129.7789915];
[x,y]=polarstereo_fwd(test(:,3),test(:,4),6378137.0,axes2ecc(6378137.0, 6356752.3),-70,0);
figure,hold on,plot(test(:,1),test(:,2),'.'),plot(x,y,'r+')
[test(:,1) test(:,1)-x],[test(:,2) test(:,2)-y]
%error is less than half a meter (probably just round-off error).

%%%%%%%%%%%%
%check with Greenland
%%%%%%%%%%%%
%projected from the WGS 84 Ellipsoid, with 70° N as the latitude of true scale and a rotation of 45.
test=[-890000.0 -629000.0 79.9641229 -99.7495626 %center point of cell
    1720000.0 -629000.0 73.2101234 24.9126514
    -890000.0 -3410000.0 58.2706251 -59.6277136
    1720000.0 -3410000.0 55.7592932 -18.2336765];
[x,y]=polarstereo_fwd(test(:,3),test(:,4),6378273,0.081816153,70,-45); %slightly off
[x2,y2]=polarstereo_fwd(test(:,3),test(:,4),6378137.0,0.08181919,70,-45); %correct
figure,hold on,plot(test(:,1),test(:,2),'.'),plot(x,y,'r+'),plot(x2,y2,'gx')
[test(:,1) test(:,1)-x test(:,1)-x2],[test(:,2) test(:,2)-y test(:,2)-y2]
%error is less than half a meter (probably just round-off error).
%}

%%%%%%%%%%%%
%input checking
%%%%%%%%%%%%
if nargin < 3 || isempty(a)
    a=6378137.0; %radius of ellipsoid, WGS84
end
if nargin < 4 || isempty(e)
    e=0.08181919; %eccentricity, WGS84
end
if nargin < 5 || isempty(phi_c)
    phi_c=-70; %standard parallel, latitude of true scale
end
if nargin < 6 || isempty(lambda_0)
    lambda_0=0; %meridian along positive Y axis
end
%convert to radians
phi=deg2rad(phi);
phi_c=deg2rad(phi_c);
lambda=deg2rad(lambda);
lambda_0=deg2rad(lambda_0);

%if the standard parallel is in S.Hemi., switch signs.
if phi_c < 0 
    pm=-1; %plus or minus, north lat. or south
    phi=-phi;
    phi_c=-phi_c;
    lambda=-lambda;
    lambda_0=-lambda_0;
else
    pm=1;
end

%this is not commented very well. See Snyder for details.
t=tan(pi/4-phi/2)./((1-e*sin(phi))./(1+e*sin(phi))).^(e/2);
% t_alt=sqrt((1-sin(phi))./(1+sin(phi)).*((1+e*sin(phi))./(1-e*sin(phi))).^e);
t_c=tan(pi/4 - phi_c/2)./((1-e*sin(phi_c))./(1+e*sin(phi_c))).^(e/2);
m_c=cos(phi_c)./sqrt(1-e^2*(sin(phi_c)).^2);
rho=a*m_c*t/t_c; %true scale at lat phi_c

m=cos(phi)./sqrt(1-e^2*(sin(phi)).^2);
x=pm*rho.*sin(lambda-lambda_0);
y=-pm*rho.*cos(lambda - lambda_0);
k=rho./(a*m);


