function [x, y] = theta2xy(theta1, theta2, l1, l2)
% Angle to Position Conversion for 2 link SCARA robot
%
% [Inputs]
%	theta1      : angle1 [deg]
%   theta2      : angle2 [deg]
%	l1          : link1 length [m]
%	l2          : link2 length [m]
% [Outputs] 
%	x		    : x coordinate of the edge of link2 [m]
%   y			: y coordinate of the edge of link2 [m]

% deg to rad conversion
theta1 = theta1 * pi / 180;
theta2 = theta2 * pi / 180;

% position
x = l1 * cos(theta1) + l2 * cos(theta1 + theta2);
y = l1 * sin(theta1) + l2 * sin(theta1 + theta2);
