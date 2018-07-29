function [MW] = hpe2MW(hpe)
% Convert power from electrical horsepower to megawatts.
% Chad A. Greene 2012
MW = hpe*746e-4;
