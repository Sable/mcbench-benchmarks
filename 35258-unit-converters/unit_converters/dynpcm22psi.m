function [psi] = dynpcm22psi(dynpcm2)
% Convert pressure from dynes per square centimeter to pounds per square
% inch
% Chad Greene 2012
psi = dynpcm2*0.0000145038;