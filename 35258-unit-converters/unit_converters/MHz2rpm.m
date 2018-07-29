function [rpm] = MHz2rpm(MHz)
% Convert frequency from megahertz to revolutions per minute.
% Chad A. Greene 2012
rpm = MHz*60*1e+6;