function [knot] = mach2knot(mach)
% Convert speed from mach (at standard temp and pressure!) to knots. 
% Chad A. Greene 2012
knot = mach*666.7386609071;