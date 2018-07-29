%type4transform.m
%written by: Duncan Po
%Date: June 8/2002
% utility file used in contourlet2tree.m
% usage: x = type4transform(y,z)
% combines y and z to give x

function x = type4transform(y,z)

row = size(y,1);
col = size(y,2);
y = y.';
z = z.';
y = reshape(y, col*2, row/2);
z = reshape(z, col*2, row/2);
x = [y; z];
x = reshape(x, col, 2*row);
x = x.';

