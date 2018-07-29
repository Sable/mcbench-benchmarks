function [kip] = ozf2kip(ozf)
% Convert force from ounces force to kip. 
% Chad A. Greene 2012
kip = ozf*0.0000625;