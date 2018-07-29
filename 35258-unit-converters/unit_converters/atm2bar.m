function [bar] = atm2bar(atm)
% Convert pressure from standard atmospheres to bar
% Chad Greene 2012
bar = atm*1.01325;