function [MPa] = inH2O2MPa(inH2O)
% Convert pressure from inches of water column at 4 degrees to megapascals
% Chad Greene 2012
MPa = inH2O*0.000249089;