function [ozf] = dyn2ozf(dyn)
% Convert force from dyne to ounces (force). 
% Chad A. Greene 2012
ozf = dyn*0.000035969431019;