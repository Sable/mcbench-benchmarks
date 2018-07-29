function [mph] = mach2mph(mach)
% Convert speed from mach (at standard temp and pressure!) to miles per hour. 
% Chad A. Greene 2012
mph = mach*767.2691481747;