function [hPa] = inH2O2hPa(inH2O)
% Convert pressure from inches of water column at 4 degrees to hectopascals
% Chad Greene 2012
hPa = inH2O*2.49089;