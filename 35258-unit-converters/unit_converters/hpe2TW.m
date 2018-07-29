function [TW] = hpe2TW(hpe)
% Convert power from electrical horsepower to terawatts.
% Chad A. Greene 2012
TW = hpe*746e-10;
