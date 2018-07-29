%type3detransform.m
%written by: Duncan Po
%Date: June 27/2002
% utility file used in tree2contourlet.m
% usage [x,y] = type3detransform(z)
% decomposes z into x and y

function [x,y] = type3detransform(z)

row = size(z,1);
col = size(z,2);
z = z.';
z = reshape(z, col*2, row/2);
z = z.';
x = z(:, 1:col);
y = z(:,(col+1):(2*col));
