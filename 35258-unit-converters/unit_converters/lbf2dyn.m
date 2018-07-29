function [dyn] = lbf2dyn(lbf)
% Convert force from pounds-force to dyne. 
% Chad A. Greene 2012
dyn = lbf*444822.16;