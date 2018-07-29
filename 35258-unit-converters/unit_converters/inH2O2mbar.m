function [mbar] = inH2O2mbar(inH2O)
% Convert pressure from inches of water column at 4 degrees to millibar
% Chad Greene 2012
mbar = inH2O*2.49089;