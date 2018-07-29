function [Pa] = atm2Pa(atm)
% Convert pressure from atmospheres to pascals.
% Chad A. Greene 2012, it's www.chadagreene.com if you're painfully bored.
Pa = atm*101325;