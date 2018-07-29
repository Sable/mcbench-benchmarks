function [rpm] = kHz2rpm(kHz)
% Convert frequency from kilohertz to revolutions per minute.
% Chad A. Greene 2012
rpm = kHz*60*1e+3;