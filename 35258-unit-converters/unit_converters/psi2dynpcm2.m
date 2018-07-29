function [dynpcm2] = psi2dynpcm2(psi)
% Convert pressure from pounds-per-square-inch to dyne per centimeter squared.
% Chad Greene 2012
dynpcm2 = psi*68947.6;