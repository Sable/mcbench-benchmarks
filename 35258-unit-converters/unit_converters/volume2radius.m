function [r] = volume2radius(V)
% volume2radius returns the radius of a sphere of volume V.
% Chad Greene 2012
r = (3*V/(4*pi)).^(1/3);