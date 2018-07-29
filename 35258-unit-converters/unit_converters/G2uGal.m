function [uGal] = G2uGal(G)
% Convert acceleration from average acceration due to Earth's gravity to 
% microgalileos 
% Chad A. Greene 2012
uGal = G*9.80665e+8; 
end