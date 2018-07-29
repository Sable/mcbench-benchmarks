function [mps] = mach2mps(mach)
% Convert speed from mach (at standard temperature and pressure!) to 
% meters per second. 
% Chad A. Greene 2012
mps = mach*343;