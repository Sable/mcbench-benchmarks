function [theta1, theta2] = xy2theta(x, y, l1, l2)
% Position to Angle Conversion for 2 link SCARA robot
%
% [Inputs]
%	x		    : x coordinate of the edge of link2 [m]
%   y			: y coordinate of the edge of link2 [m]
%	l1          : link1 length [m]
%	l2          : link2 length [m]
% [Outputs]
%	theta1      : angle1 [deg]
%   theta2      : angle2 [deg]

tmp = x.^2 + y.^2 - l2^2;
tmp1 = tmp + l1^2;
tmp2 = tmp - l1^2;

% theta
theta1 = atan2(y, x) - atan2(sqrt(abs(4 * l1^2 * (x.^2 + y.^2) - tmp1.^2)), tmp1);
theta2 = atan2(sqrt(abs(4 * l1^2 * l2^2 - tmp2.^2)), tmp2);

% rad to deg conversion
theta1 = theta1 * 180 / pi;
theta2 = theta2 * 180 / pi;
