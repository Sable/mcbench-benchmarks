function [mGal] = G2mGal(G)
% Convert acceleration from average acceration due to Earth's gravity to 
% milligalileos 
% Chad A. Greene 2012
mGal = G*9.80665e+5; 
end