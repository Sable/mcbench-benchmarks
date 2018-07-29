function [kWh] = ftlb2kWh(ftlb)
% Convert energy or work from foot-pounds to kilowatt-hours.
% Chad A. Greene 2012
kWh = ftlb*3.7661608333e-7;