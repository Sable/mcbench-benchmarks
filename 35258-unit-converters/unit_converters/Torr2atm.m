function [atm] = Torr2atm(Torr)
% Convert pressure from torr (same as mmHg) to atmospheres
% Chad Greene 2012
atm = Torr*0.00131579;