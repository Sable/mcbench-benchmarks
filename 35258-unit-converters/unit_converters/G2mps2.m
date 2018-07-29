function [mps2] = G2mps2(G)
% Convert acceleration from average acceration due to Earth's gravity to 
% meters per second-squared
% Chad A. Greene 2012
mps2 = G*9.80665; 
end