function [X,Y,Z]=sphr0(r,t,p)
% [X,Y,Z]=sphr0(r,t,p) defines spherical
% coordinates (r,t,p)
X=r.*sin(t).*cos(p); Y=r.*sin(t).*sin(p); 
Z=r.*cos(t);