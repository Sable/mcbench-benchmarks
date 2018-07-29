%% "Spirograph" Code
%  Jonathan Jamieson - September 2013
%  unigamer@gmail.com
%  www.jonathanjamieson.com

function [local_x,local_y] = Global2Local(global_x,global_y,origin_x,origin_y,theta)
% Conversion
%   +ve theta is clockwise, -ve theta is anticlockwise


local_x = (global_y-origin_y-(global_x*cos(theta)/sin(theta))+(origin_x*cos(theta)/sin(theta)))/(-(cos(theta)^2/sin(theta))-sin(theta));
local_y = (global_y-origin_y+(global_x*sin(theta)/cos(theta))-(origin_x*sin(theta)/cos(theta)))/((sin(theta)^2/cos(theta))+cos(theta));

if theta == 0; % This is neccessary because sin(0) = 0 and consequently local_x tries a division by zero and returns NaN (not a number)
    
    local_x = global_x-origin_x;
    
end

end