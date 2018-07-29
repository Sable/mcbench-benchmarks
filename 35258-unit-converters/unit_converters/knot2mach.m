function [mach] = knot2mach(knot)
% Convert speed from knots to mach (at standard temperature and pressure!)
% Useful for very fast boats. 
% Chad A. Greene 2012
mach = knot*0.00149983803045;