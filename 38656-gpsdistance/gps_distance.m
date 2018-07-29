% Program to calculate surface distance between two points
% on Earth given the latitude and longitude
% The input is c.sencond out=gps_distance(lat1,lon1,lat2,lon2)

function out=gps_distance(lat1,lon1,lat2,lon2)

latrad1 = lat1*pi/180;
lonrad1 = lon1*pi/180;
latrad2 = lat2*pi/180;
lonrad2 = lon2*pi/180;

londif = abs(lonrad2-lonrad1);

raddis = acos(sin(latrad2)*sin(latrad1)+cos(latrad2)*cos(latrad1)*cos(londif));

 nautdis = raddis * 3437.74677;
% statdis = nautdis * 1.1507794;
stdiskm = nautdis * 1.852;
out=stdiskm*1000;
