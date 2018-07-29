function [Torr] = dynpcm22Torr(dynpcm2)
% Convert pressure from dynes per square centimeter to torr
% Chad Greene 2012
Torr = dynpcm2*0.000750062;