function [nmps2] = G2nmps2(G)
% Convert acceleration from average acceration due to Earth's gravity to 
% nanometers per second-squared
% Chad A. Greene 2012
nmps2 = G*9.80665e+9; 
end