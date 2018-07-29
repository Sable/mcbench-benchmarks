function [atm] = psi2atm(psi)
% Convert pressure from pounds-per-square-inch to atmospheres.
% Chad Greene 2012
atm = psi/14.696;