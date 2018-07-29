function [X,Y,Z]=cone0(z,t,p) 
% [X,Y,Z]=cone0 defines a non-orthogonal
% coordinate system using a conical surface
% with a planar base
X=z.*tan(t).*cos(p); Y=z.*tan(t).*sin(p); Z=z;