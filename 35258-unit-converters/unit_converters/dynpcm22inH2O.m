function [inH2O] = dynpcm22inH2O(dynpcm2)
% Convert pressure from dynes per square centimeter to inches of water at 4C
% Chad Greene 2012
inH2O = dynpcm2*0.000401463;