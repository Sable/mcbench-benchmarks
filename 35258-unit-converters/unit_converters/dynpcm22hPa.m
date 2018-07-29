function [hPa] = dynpcm22hPa(dynpcm2)
% Convert pressure from dynes per square centimeter to hectopascals
% Chad Greene 2012
hPa = dynpcm2*0.00100000;