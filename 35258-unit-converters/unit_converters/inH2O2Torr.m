function [Torr] = inH2O2Torr(inH2O)
% Convert pressure from inches of water column at 4 degrees to torr
% Chad Greene 2012
Torr = inH2O*1.86832;