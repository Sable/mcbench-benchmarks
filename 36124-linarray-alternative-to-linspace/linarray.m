function outputarray = linarray(start,spacing,numpoints)
% outputarray = linarray(start,spacing,numpoints)
% 
% The function linarray generates an row vector based on a start value, a
% spacing, and a number of points.  For example: linarray(1,.1,5) returns:
% [1.0000    1.1000    1.2000    1.3000    1.4000]
%
% 3/2/11 (c) James F. Mack

outputarray = [start:spacing:start+(numpoints-1)*spacing];