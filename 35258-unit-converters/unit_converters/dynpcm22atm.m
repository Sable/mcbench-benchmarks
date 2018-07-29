function [atm] = dynpcm22atm(dynpcm2)
% Convert pressure from dynes per square centimeter to standard atmospheres
% Chad Greene 2012
atm = dynpcm2*9.86923e-7;