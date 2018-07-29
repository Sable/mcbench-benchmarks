function dist = posdist(lat1,lon1,lat2,lon2,method)
% function dist = posdist(lat1,lon1,lat2,lon2,method)
% calculate distance between two points on earth's surface
% given by their latitude-longitude pair.
% Input lat1,lon1,lat2,lon2 are in decimal degrees
% Eastern longitudes and northern latitudes postive,
% western longitudes and southern latitudes negative.
% Input method is great circle ('s') or cartesian ('c'). Default is great circle.
% Cartesian method uses plane approximation,
% only for points within several tens of kilometers (angles in rads):
% d =
% sqrt(R_equator^2*(lat1-lat2)^2 + R_polar^2*(lon1-lon2)^2*cos((lat1+lat2)/2)^2)
% Great circle method calculates spheric geodesic distance for points farther apart,
% but ignores flattening of the earth:
% d =
% R_aver * acos(cos(lat1)cos(lat2)cos(lon1-lon2)+sin(lat1)sin(lat2))
% Output dist is in km.
% Returns NaN if input argument(s) is/are out of bounds
% Flora Sun, University of Toronto, Jun 12, 2004.
% Modified to allow input of arrays
% by Jakob Tougaard, Aarhus University, Mar 11, 2012.
 
if nargin < 4
    dist = NaN;
    disp('Number of input arguments error! distance = NaN');
    return;
end

%Check for illegal input
outofbounds=abs(lat1)>90|abs(lon1)>180|abs(lat2)>90|abs(lon2)>180;

if lon1 < 0
    lon1 = lon1 + 360;
end
if lon2 < 0
    lon2 = lon2 + 360;
end

% Default method is 's' (great circle).
if nargin == 4
    method = 's';
end
if method ~= 's'
    km_per_deg_la = 111.3237;
    km_per_deg_lo = 111.1350;
    km_la = km_per_deg_la * (lat1-lat2);
    % Always calculate the shorter arc.
    if abs(lon1-lon2) > 180
        dif_lo = abs(lon1-lon2)-180;
    else
        dif_lo = abs(lon1-lon2);
    end
    km_lo = km_per_deg_lo .* dif_lo .* cos((lat1+lat2)*pi/360);
    dist = sqrt(km_la.^2 + km_lo.^2);
else
    R_aver = 6374;
    deg2rad = pi/180;
    lat1 = lat1 * deg2rad;
    lon1 = lon1 * deg2rad;
    lat2 = lat2 * deg2rad;
    lon2 = lon2 * deg2rad;
    dist = R_aver * acos(cos(lat1).*cos(lat2).*cos(lon1-lon2) + sin(lat1).*sin(lat2));
end

dist(outofbounds)=NaN; %out of bounds input returns error

