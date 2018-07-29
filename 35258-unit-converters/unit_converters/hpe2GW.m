function [GW] = hpe2GW(hpe)
% Convert power from electrical horsepower to gigawatts.
% Chad A. Greene 2012
GW = hpe*746e-7;
