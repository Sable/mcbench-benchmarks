function [kPa] = dynpcm22kPa(dynpcm2)
% Convert pressure from dynes per square centimeter to kilopascals
% Chad Greene 2012
kPa = dynpcm2*0.000100000;