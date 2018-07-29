function [kip] = dyn2kip(dyn)
% Convert force from dyne to kip. 
% Chad A. Greene 2012
kip = dyn*2.2480894387e-9;