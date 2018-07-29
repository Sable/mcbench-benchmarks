function [mach] = mps2mach(mps)
% Convert speed from meters per second to mach number (at STP!)
% Chad A. Greene 2012
mach = mps*0.002915451895044;