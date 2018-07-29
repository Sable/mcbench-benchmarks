function  [x,y,utmzone,utmhemi] = wgs2utm(Lat,Lon,utmzone,utmhemi)
% -------------------------------------------------------------------------
% [x,y,utmzone] = wgs2utm(Lat,Lon,Zone)
%
% Description:
%    Convert WGS84 coordinates (Latitude, Longitude) into UTM coordinates
%    (northing, easting) according to (optional) input UTM zone and
%    hemisphere.
%
% Input:
%    Lat: WGS84 Latitude scalar, vector or array in decimal degrees.  
%    Lon: WGS84 Longitude scalar, vector or array in decimal degrees. 
%    utmzone (optional): UTM longitudinal zone. Scalar or same size as Lat
%       and Lon.
%    utmhemi (optional): UTM hemisphere as a single character, 'N' or 'S',
%       or array of 'N' or 'S' characters of same size as Lat and Lon.
%
% Output:
%    x: UTM easting in meters.
%    y: UTM northing in meters.
%    utmzone: UTM longitudinal zone.
%    utmhemi: UTM hemisphere as array of 'N' or 'S' characters. 
%
% Author notes:
%    I downloaded and tried deg2utm.m from Rafael Palacios but found
%    differences of up to 1m with my reference converters in southern
%    hemisphere so I wrote my own code based on "Map Projections - A
%    Working Manual" by J.P. Snyder (1987). Quick quality control performed
%    only by comparing with LINZ converter
%    (www.linz.govt.nz/apps/coordinateconversions/) and Chuck Taylor's 
%    (http://home.hiwaay.net/~taylorc/toolbox/geography/geoutm.html) on a 
%    few test points, so use results with caution. Equations not suitable
%    for a latitude of +/- 90deg.
%
%    UPDATE: Following requests, this new version allows forcing UTM zone
%    in input.
%
% Examples:
%
%    % set random latitude and longitude arrays
%    Lat= 90.*(2.*rand(3)-1)
%    Lon= 180.*(2.*rand(3)-1)
%
%    % let the function find appropriate UTM zone and hemisphere from data 
%    [x1,y1,utmzone1,utmhemi1] = wgs2utm(Lat,Lon)
%
%    % forcing unique UTM zone and hemisphere for all data entries
%    % note: resulting easting and northing are way off the usual values
%    [x2,y2,utmzone2,utmhemi2] = wgs2utm(Lat,Lon,60,'S')
%
%    % forcing different UTM zone and hemisphere for each data entry
%    % note: resulting easting and northing are way off the usual values
%    utmzone = floor(59.*rand(3))+1
%    utmhemi = char(78 + 5.*round(rand(3)))
%    [x3,y3,utmzone3,utmhemi3] = wgs2utm(Lat,Lon,utmzone,utmhemi)
%
% Author: 
%   Alexandre Schimel
%   MetOcean Solutions Ltd
%   New Plymouth, New Zealand
%
% Version 2:
%   February 2011
%-------------------------------------------------------------------------

%% Argument checking
if ~sum(double(nargin==[2,4]))
    error('Wrong number of input arguments');return
end
n1=size(Lat);
n2=size(Lon);
if (n1~=n2)
    error('Lat and Lon should have same size');return
end
if exist('utmzone','var') && exist('utmhemi','var')
    n3=size(utmzone);
    n4=size(utmhemi);
    if (sort(n3)~=sort(n4))
        error('utmzone and utmhemi should have same size');return
    end
    if max(n3)~=1 && max(n3)~=max(n1)
        error('utmzone should have either same size as Lat and Long, or size=1');return
    end
end

% expand utmzone and utmhemi if needed
if exist('utmzone','var') && exist('utmhemi','var')
    n3=size(utmzone);
    n4=size(utmhemi);
    if n3==[1 1]
        utmzone = utmzone.*ones(size(Lat));
        utmhemi = char(utmhemi.*ones(size(Lat)));
    end
end
    
%% coordinates in radians
lat = Lat.*pi./180;
lon = Lon.*pi./180;

%% WGS84 parameters
a = 6378137;           %semi-major axis
b = 6356752.314245;    %semi-minor axis
% b = 6356752.314140;  %GRS80 value, originally used for WGS84 before refinements
e = sqrt(1-(b./a).^2); % eccentricity

%% UTM parameters
% lat0 = 0;                % reference latitude, not used here
if exist('utmzone','var')
    Lon0 = 6.*utmzone-183; % reference longitude in degrees
else
    Lon0 = floor(Lon./6).*6+3; % reference longitude in degrees
end
lon0 = Lon0.*pi./180;      % in radians
k0 = 0.9996;               % scale on central meridian

FE = 500000;              % false easting
if exist('utmhemi','var')
    FN = double(utmhemi=='S').*10000000;
else
    FN = (Lat < 0).*10000000; % false northing 
end

%% Equations parameters
eps = e.^2./(1-e.^2);  % e prime square
% N: radius of curvature of the earth perpendicular to meridian plane
% Also, distance from point to polar axis
N = a./sqrt(1-e.^2.*sin(lat).^2); 
T = tan(lat).^2;                
C = ((e.^2)./(1-e.^2)).*(cos(lat)).^2;
A = (lon-lon0).*cos(lat);                            
% M: true distance along the central meridian from the equator to lat
M = a.*(  ( 1 - e.^2./4 - 3.*e.^4./64 - 5.*e.^6./256 )  .* lat         ...
         -( 3.*e.^2./8 + 3.*e.^4./32 + 45.*e.^6./1024 ) .* sin(2.*lat) ...
         +( 15.*e.^4./256 + 45.*e.^6./1024 )            .* sin(4.*lat) ...
         -(35.*e.^6./3072 )                             .* sin(6.*lat) );

%% easting
x = FE + k0.*N.*(                                  A       ...
                 + (1-T+C)                      .* A.^3./6 ...
                 + (5-18.*T+T.^2+72.*C-58.*eps) .* A.^5./120 );
               
%% northing 
% M(lat0) = 0 so not used in following formula
y = FN + k0.*M + k0.*N.*tan(lat).*(                                     A.^2./2  ...
                                   + (5-T+9.*C+4.*C.^2)              .* A.^4./24 ...
                                   + (61-58.*T+T.^2+600.*C-330.*eps) .* A.^6./720 );
                                 
%% UTM zone
if exist('utmzone','var') && exist('utmhemi','var')
    utmzone = utmzone;
    utmhemi = utmhemi;
else 
   utmzone = floor(Lon0./6)+31;
   utmhemi = char( 83.* (Lat < 0) + 78.* (Lat >= 0) );
end
