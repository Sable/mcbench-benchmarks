function [hPa] = atm2hPa(atm)
% Convert pressure from standard atmospheres to hectopascals
% Chad Greene 2012
hPa = atm*1013.25;