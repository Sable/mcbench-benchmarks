function [rho, theta, phi]=spherical_angle_ed(x, y, z)  
% % spherical, rectangular, coordinates
% % 
% % Syntax;
% % 
% % [rho, theta, phi]=spherical_angle_ed(x, y, z);  
% % 
% % ***********************************************************
% % 
% % Description
% % 
% % Program maps the rectangular coordinates, x, y, and z to   
% % spherical coordinates r, theta, and phi.
% % 
% % theta is set to 0 at the top and bottom points.
% % 
% % ***********************************************************
% % 
% % Input Variables
% % 
% % x, y, and z, are matrices of rectangular coordinates.
% % 
% % ***********************************************************
% % 
% % Output Variables
% % 
% % r, theta, phi, are matrices of spherical coordinates.
% % 
% % ***********************************************************
% % 
% Example
% 
% x=1:100;
% y=x.^2;
% z=x.^3;
% [rho, theta, phi]=spherical_angle_ed(x, y, z);
%
% % ***********************************************************
% % 
% % This program was written by Edward L. Zechmann 
% % 
% %     date     January 2007  
% % 
% % modified 11   March   2008  Fixed a bug.  Added comments.  
% % 
% % ***********************************************************
% % 
% % Feel free to modify this code.
% % 

rho=sqrt(x.^2+y.^2+z.^2);
r=sqrt(x.^2+y.^2);
    
buf=size(x);
n=buf(1);
m=buf(2);
theta=zeros(n, m);
phi=zeros(n, m);

for e1=1:n;
    for e2=1:m;
        if abs(y(e1, e2))< 10^(-13) && abs(x(e1, e2)) < 10^(-13)
            theta(e1, e2)=0;
        else
            theta(e1, e2) = atan2(y(e1, e2),x(e1, e2));
        end
    	phi(e1, e2) = atan2(r(e1, e2), z(e1, e2));
        
    end
end
