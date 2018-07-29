function [ftH2O] = dynpcm22ftH2O(dynpcm2)
% Convert pressure from dynes per square centimeter to feet of water at 4C
% Chad Greene 2012
ftH2O = dynpcm2*0.0000334553;