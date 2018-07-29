%type4detransform.m
%written by: Duncan Po
%Date: June 27/2002
% utility file used in tree2contourlet.m
% usage: [x,y] = type4detransform(z)
% decomposes z into x and y
 
function [x,y] = type4detransform(z)

row = size(z,1);
col = size(z,2);
z = z.';
z = reshape(z, col*4, row/4);
x = z(1:(col*2), :);
y = z((col*2+1):col*4,:); 
x = reshape(x, col, row/2);
y = reshape(y, col, row/2);
x = x.';
y = y.';
