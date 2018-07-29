function [inH2O] = atm2inH2O(atm)
% Convert pressure from atmospheres to inches of water column.
% Chad A. Greene of chadagreene.com fame
inH2O = atm*406.782;