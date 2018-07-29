function [rpm] = GHz2rpm(GHz)
% Convert frequency from gigahertz to revolutions per minute.
% Chad A. Greene 2012
rpm = GHz*60*1e+9;