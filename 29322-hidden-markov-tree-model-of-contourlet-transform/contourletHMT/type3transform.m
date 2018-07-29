%type3transform.m
%written by: Duncan Po
%Date: June 8/2002
% utility file used in contourlet2tree.m
% usage: x = type3transform(y,z)
% combines y and z to give x
 
function x = type3transform(y,z)

row = size(y,1);
col = size(y,2);
x = [y z];
x = x.';
x = reshape(x, col, 2*row);
x = x.';
