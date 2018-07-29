function [ftH2O] = Torr2ftH2O(Torr)
% Convert pressure from torr (same as mmHg) to feet of water at 4 degrees C
% Chad Greene 2012
ftH2O = Torr*0.0446033;