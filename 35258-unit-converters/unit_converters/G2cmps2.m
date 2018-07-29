function [cmps2] = G2cmps2(G)
% Convert acceleration from average acceration due to Earth's gravity to 
% centimeters per second-squared
% Chad A. Greene 2012
cmps2 = G*9.80665e+2; 
end