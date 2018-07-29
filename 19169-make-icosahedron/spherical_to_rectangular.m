function [x, y, z]=spherical_to_rectangular(r, theta, phi)
% % spherical, rectangular, coordinates
% % 
% % Syntax;
% % 
% % [x, y, z]=spherical_to_rectangular(r, theta, phi);
% % 
% % ***********************************************************
% % 
% % Description
% % 
% % Program maps the spherical coordinates r, theta, and phi from a 
% % sphere to rectangular coordinates.  
% % 
% % ***********************************************************
% % 
% % Input Variables
% % 
% % r, theta, phi, are matrices of spherical coordinates.
% % 
% % ***********************************************************
% % 
% % Output Variables
% % 
% % x, y, and z, are matrices of rectangular coordinates.
% % 
% % ***********************************************************
% % 
% Example
% 
% phi=pi/4:pi/320:pi/2;
% theta=0:(pi/16):(5*pi);
% r=ones(size(phi));
% [x, y, z]=spherical_to_rectangular(r, theta, phi);
% plot3(x,y,z, '-r', 'Linewidth', 3 );
% 
% % ***********************************************************
% % 
% % This program was written by Edward L. Zechmann 
% % 
% %     date     January 2007  
% % 
% % modified 11   March   2008  added comments
% % 
% % ***********************************************************
% % 
% % Feel free to modify this code.
% % 

x=r.*sin(phi).*cos(theta);
y=r.*sin(phi).*sin(theta);
z=r.*cos(phi);
