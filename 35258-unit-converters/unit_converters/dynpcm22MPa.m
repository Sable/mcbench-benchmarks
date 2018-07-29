function [MPa] = dynpcm22MPa(dynpcm2)
% Convert pressure from dynes per square centimeter to megapascals
% Chad Greene 2012
MPa = dynpcm2*1.00000e-7;