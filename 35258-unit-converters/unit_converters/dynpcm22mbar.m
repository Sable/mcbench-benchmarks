function [mbar] = dynpcm22mbar(dynpcm2)
% Convert pressure from dynes per square centimeter to millibar
% Chad Greene 2012
mbar = dynpcm2*0.00100000;