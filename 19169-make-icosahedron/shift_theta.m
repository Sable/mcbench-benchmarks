function [x1, y1, z1]=shift_theta(x,y,z, theta)
% % spherical, rectangular, coordinates
% % 
% % Syntax;
% % 
% % [x1, y1, z1]=shift_theta(x,y,z, theta);  
% % 
% % ***********************************************************
% % 
% % Description
% % 
% % rotates matrices, x, y,and z theta radians about the z-axis.
% % 
% % ***********************************************************
% % 
% % Input Variables
% % 
% % x, y, and z, are matrices of rectangular coordinates.
% % 
% % theta is the angle in radians.  
% % 
% % ***********************************************************
% % 
% % Output Variables
% % 
% % x1, y1, z1, are the rotated matrices in rectangular coordinates.
% % 
% % ***********************************************************
% % 
%
% Example
% 
% theta1=0:(pi/50):(2*pi);
% x=cos(theta1);
% y=sin(theta1);
% z=(1:length(x)).^3;
%
% theta=pi/2;
%
% [x1, y1, z1]=shift_theta(x, y, z, 1*theta);
% [x2, y2, z2]=shift_theta(x, y, z, 2*theta);
% [x3, y3, z3]=shift_theta(x, y, z, 3*theta);
% 
% plot3(x, y, z, 'k');
% hold on;
% plot3(x1, y1, z1, 'r');
% plot3(x2, y2, z2, 'b');
% plot3(x3, y3, z3, 'g');
% 
% % 
% % ***********************************************************
% % 
% % This program was written by Edward L. Zechmann 
% % 
% %     date     January 2007  
% % 
% % modified 11   March   2008  added examples
% % 
% % ***********************************************************
% % 
% % Feel free to modify this code.

[rho1, theta1, phi1]=spherical_angle_ed(x, y, z);    

theta1=theta1+theta;

[x1, y1, z1]=spherical_to_rectangular(rho1, theta1, phi1);

