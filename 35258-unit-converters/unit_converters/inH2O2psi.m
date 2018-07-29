function [psi] = inH2O2psi(inH2O)
% Convert pressure from inches of water column at 4 degrees to pounds per
% square inch
% Chad Greene 2012
psi = inH2O*0.0361273;