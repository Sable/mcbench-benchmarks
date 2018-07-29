function [dyn] = ozf2dyn(ozf)
% Convert force from ounces force to dyne. 
% Chad A. Greene 2012
dyn = ozf*27801.385;