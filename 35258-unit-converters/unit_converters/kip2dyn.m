function [dyn] = kip2dyn(kip)
% Convert force from kip to dyne. 
% Chad A. Greene 2012
dyn = kip*444822160;