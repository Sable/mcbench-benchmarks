function [X,Y,Z]=cylin0(r,t,z)
% [X,Y,Z]=cylin0(r,t,z) defines cylindrical
% coordinates (r,t,z)
X=r.*cos(t); Y=r.*sin(t); Z=z;