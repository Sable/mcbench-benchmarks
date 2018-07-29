function [ftH2O] = inH2O2ftH2O(inH2O)
% Convert pressure from inches of water column at 4 degrees to feet of
% very similar water
% Chad Greene 2012
ftH2O = inH2O/12;