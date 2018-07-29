function [MPa] = atm2MPa(atm)
% Convert pressure from atmospheres to megapascals.
% Chad A. Greene of chadagreene.com fame
MPa = atm*0.101325;