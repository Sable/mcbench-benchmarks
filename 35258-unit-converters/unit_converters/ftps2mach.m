function [mach] = ftps2mach(ftps)
% Convert speed from feet per second to mach number (at STP!)
% Chad A. Greene 2012
mach = ftps*0.0008886297376093 ;