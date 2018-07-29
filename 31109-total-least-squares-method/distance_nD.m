function [d] = distance_nD(Point1, Point2)
%
% Euclidean distance between two points in nD
% Inputs:
% - Point1: array of Point1 coordinates
% - Point2: array of Point2 coordinates
% Output:
% - d: Euclidean distance in nD dimension
%
% Authors:
% Ivo Petras (ivo.petras@tuke.sk)
% Dagmar Bednarova (dagmar.bednarova@tuke.sk)
%
% Date: 20/05/2009
%
kx = length(Point1); ky = length(Point2);
if kx ~= ky
   disp('Incompatible Point1 and Point2.'); 
   close all;
end
%
suma=0;
m = length(Point1);
for I = 1:m
    dist(I) = (Point1(I)-Point2(I)).^2;
    suma=suma+dist(I);
end
d=sqrt(suma);