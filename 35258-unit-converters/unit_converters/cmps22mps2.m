function [mps2] = cmps22mps2(cmps2)
% Convert acceleration from centimeters per square centimeter to meters
% per second-squared.
% Chad A. Greene 2012
mps2 = cmps2*1e-2; 
end