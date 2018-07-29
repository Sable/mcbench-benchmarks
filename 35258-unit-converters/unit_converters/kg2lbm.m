function [lbm] = kg2lbm(kg)
% Convert mass from kilograms to pounds-mass.  Yes, pounds-mass is a very
% stupid unit. 
% Chad A. Greene
lbm = kg/.45359237;