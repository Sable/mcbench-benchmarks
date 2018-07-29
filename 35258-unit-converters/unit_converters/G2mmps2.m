function [mmps2] = G2mmps2(G)
% Convert acceleration from average acceration due to Earth's gravity to 
% millimeters per second-squared
% Chad A. Greene 2012
mmps2 = G*9.80665e+3; 
end