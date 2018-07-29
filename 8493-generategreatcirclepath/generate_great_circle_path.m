function [lats, lons]=generate_great_circle_path(lat1,lon1,lat2,lon2,delta_ft)
% [lats, lons]=generate_great_circle_path(lat1,lon1,lat2,lon2,delta_ft)
%   Generate a great circle "trajectory" from [lat1,lon1] to [lat2, lon2].
%   Resulting points will be seperated by approximately delta_ft feet.
%   By default, delta_ft = 100 feet.  All lat/lon inputs & outputs are in
%   degrees.
%
%   Example:
%    % Generate traj from New York to London
%       lat1=40.77; lon1=-73.98;   % New York
%       lat2=51.5;  lon2=-0.16667; % London
%       [lats lons]=generate_great_circle_path(lat1,lon1,lat2,lon2);
%    % Show the earth (thanks to Mathworks)
%       figure; earthmap; axis equal; hold on; view([-114 26])
%    % earthmap x,y,z -> (lat,lon) mappings are x->(0,-180), y->(0,-90), z->(90,0)
%       Xtraj=cos(lats*pi/180).*cos(lons*pi/180-pi);
%       Ytraj=cos(lats*pi/180).*sin(lons*pi/180-pi);
%       Ztraj=sin(lats*pi/180);
%       plot3(Xtraj,Ytraj,Ztraj,'r','linewidth',2);
%
%    Author: Jeff Barton, 
%            The Johns Hopkins University Applied Physics Laboratory
%    Date:   September 16, 2005

% Define approximate spacing
if ~exist('delta_ft')
    delta_ft=100; % Default spacing: about 100 feet
end

% Input degrees, but work with radians
LAT1 = lat1*pi/180; % rads
LON1 = lon1*pi/180; % rads
LAT2 = lat2*pi/180; % rads
LON2 = lon2*pi/180; % rads

% Using the right-handed coordinate frame with Z toward (lat,lon)=(0,0) and 
% Y toward (lat,lon)=(90,0), the unit_radial of a (lat,lon) is given by:
% 
%               [ cos(lat)*sin(lon) ]
% unit_radial = [     sin(lat)      ]
%               [ cos(lat)*cos(lon) ]
unit_radial_1 = [cos(LAT1)*sin(LON1); sin(LAT1); cos(LAT1)*cos(LON1)];
unit_radial_2 = [cos(LAT2)*sin(LON2); sin(LAT2); cos(LAT2)*cos(LON2)];

% Define the vector that is normal to both unit_radial_1 & unit_radial_2
normal_vec = cross(unit_radial_1,unit_radial_2);  
unit_normal = normal_vec / sqrt(sum(normal_vec.^2));  

% Define the vector that is tangent to the great circle flight path at
% (lat1,lon1)
tangent_1_vec = cross(unit_normal,unit_radial_1);
unit_tangent_1 = tangent_1_vec / sqrt(sum(tangent_1_vec.^2));

% Determine the total arc distance from 1 to 2 
total_arc_angle_1_to_2 = acos( dot(unit_radial_1,unit_radial_2) ); % radians

% Determine the set of arc angles to use 
% (approximately spaced by delta_ft feet)
R0 = 20902255; % feet, radius of a circle having approximately the surface area of the earth
angs2use = linspace(0,total_arc_angle_1_to_2,ceil(total_arc_angle_1_to_2/(delta_ft/R0))); % radians
M=length(angs2use);

% Now find the unit radials of the entire "trajectory"
%                                                              [ cos(angs2use(m)) -sin(angs2use(m)) 0 ]   [ 1 ]
% unit_radial_m = [unit_radial_1 unit_tangent_1 unit_normal] * [ sin(angs2use(m))  cos(angs2use(m)) 0 ] * [ 0 ]
%                                                              [        0                 0         1 ]   [ 0 ]
% equals...
%                                                              [ cos(angs2use(m)) ]
% unit_radial_m = [unit_radial_1 unit_tangent_1 unit_normal] * [ sin(angs2use(m)) ]
%                                                              [        0         ]
% equals...
%
% unit_radial_m = [unit_radial_1*cos(angs2use(m)) + unit_tangent_1*sin(angs2use(m)) + 0]
%
% unit_radials is a 3xM array of M unit radials
unit_radials = [unit_radial_1 *ones(1,M)] .* [ones(3,1)*cos(angs2use)] ...
             + [unit_tangent_1*ones(1,M)] .* [ones(3,1)*sin(angs2use)];

% Convert to latitudes and longitudes
LATS = asin(unit_radials(2,:));
LONS = atan2(unit_radials(1,:),unit_radials(3,:));

% Output degrees
lats = LATS(:)*180/pi;
lons = LONS(:)*180/pi;
   

         