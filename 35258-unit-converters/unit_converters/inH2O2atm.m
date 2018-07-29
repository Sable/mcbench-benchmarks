function [atm] = inH2O2atm(inH2O)
% Convert pressure from inches of water column at 4 degrees to atmospheres
% Chad Greene 2012
atm = inH2O*0.00245832;