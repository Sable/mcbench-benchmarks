function [kmph] = mach2kmph(mach)
% Convert speed from mach (at standard temperature and pressure!) to 
% kilometers per hour. 
% Chad A. Greene 2012
kmph = mach*1234.8;