function [mach] = kmph2mach(kmph)
% Convert speed from miles per hour to mach number (at STP!)
% Chad A. Greene 2012
mach = kmph*0.0008098477486233;