function [x, y, z]=splat(r, theta, phi)
% % mapping, delaunay, flat projection
% % 
% % Syntax;
% % 
% % [x, y, z]=splat(r, theta, phi);
% % 
% % ***********************************************************
% % 
% % Description
% % 
% % Program maps the spherical coordinates r, theta, and phi from a 
% % sphere to a flat plane to aid in triangularization of hemispherical 
% % coordinates.  
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
% [x10, y10, z]=splat(r, theta, phi);
% TRI = delaunay(x10, y10);
%
% figure(1);
% h=trisurf(TRI,x,y,z, 'FaceColor', [1 1 1], 'EdgeColor', 0.5*[1 1 1],...
% 'LineWidth', 1 );
% hold on;
% plot3(x,y,z, '-r', 'Linewidth', 3 );
%
% TRI2 = delaunay(x, y);
%
% figure(2);
% h=trisurf(TRI2,x,y,z, 'FaceColor', [1 1 1], 'EdgeColor', 0.5*[1 1 1],...
% 'LineWidth', 1 );
% hold on;
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

x=r.*phi.*cos(theta);
y=r.*phi.*sin(theta);
z=r.*cos(phi);
