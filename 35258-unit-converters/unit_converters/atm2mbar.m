function [mbar] = atm2mbar(atm)
% Convert pressure from standard atmospheres to millibar
% Chad Greene 2012
mbar = atm*1013.25;