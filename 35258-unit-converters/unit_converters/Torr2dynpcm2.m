function [dynpcm2] = Torr2dynpcm2(Torr)
% Convert pressure from torr (same as mmHg) to dynes per square centimeter
% Chad Greene 2012
dynpcm2 = Torr*1333.22;