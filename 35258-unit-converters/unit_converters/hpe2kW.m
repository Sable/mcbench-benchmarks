function [kW] = hpe2kW(hpe)
% Convert power from electrical horsepower to kilowatts.
% Chad A. Greene 2012
kW = hpe*.746;
