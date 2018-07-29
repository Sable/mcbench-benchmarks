function [dyn] = kN2dyn(kN)
% Convert force from kilonewtons to dyne. 
% Chad A. Greene 2012
dyn = kN*100000000;