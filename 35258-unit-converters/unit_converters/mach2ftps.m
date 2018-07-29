function [ftps] = mach2ftps(mach)
% Convert speed from mach (at standard temperature and pressure!) to 
% feet per second. 
% Chad A. Greene 2012
ftps = mach*1125.32808399;