function [nmps2] = mps22nmps2(mps2)
% Convert acceleration from meters per square-second to nanometers per 
% second squared. 
% Chad A. Greene 2012
nmps2 = mps2*1e+9; 