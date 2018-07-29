%% "Spirograph" Code
%  Jonathan Jamieson - September 2013
%  unigamer@gmail.com
%  www.jonathanjamieson.com


function [global_x,global_y] = Local2Global(local_x,local_y,origin_x,origin_y,theta)
% Conversion
%   +ve theta is clockwise, -ve theta is anticlockwise

x_rot = local_x*cos(theta)+local_y*sin(theta);
y_rot = -local_x*sin(theta)+local_y*cos(theta);

global_x = origin_x+x_rot;
global_y = origin_y+y_rot;

end

