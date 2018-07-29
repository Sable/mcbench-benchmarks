function [rpm] = THz2rpm(THz)
% Convert frequency from terahertz to revolutions per minute.
% Chad A. Greene 2012
rpm = THz*60*1e+12;