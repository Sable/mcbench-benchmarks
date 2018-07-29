function output = inside_hex(pos,radius,center,rotation)
% check if the position(s) are inside a hexagon
%
% pos: coordinates of the positions, size (#positions, 2);
% radius: radius or edge length of the hexagon
% center: of the hexagon, by default is [0 0]
% rotation: of the hexagon, by default is 0 degree
% output: a bool vector of size (#positions, 1); true if inside.
%
% by Yuanye Wang, Powerwave Technologies
% yuanye.wang@pwav.com

if nargin == 2, center = [0 0]; rotation = 0; elseif nargin == 3, rotation = 0; end

if any(center ~= [0 0])
    pos = pos - repmat(center,size(pos,1),1);
end

if rotation ~= 0 % cell is rotated, rotate pos backwards
    theta = -rotation / 180 * pi;
    x = pos(:,1);
    y = pos(:,2);
    pos(:,1) = x * cos(theta) - y * sin(theta);
    pos(:,2) = x * sin(theta) + y * cos(theta);
end
pos = abs(pos); % due to symmetry, we look at only the 1st quadrant

check_1 = (pos(:,1) <= radius & pos(:,2) <= radius*sqrt(3)/2);
check_2 = (pos(:,2) <= sqrt(3) * (radius - pos(:,1)));
output = check_1 & check_2;
