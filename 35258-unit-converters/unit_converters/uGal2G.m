function [G] = uGal2G(uGal)
% Convert acceleration from microgals to average acceleration due to 
% Earth's gravity. 
% Chad A. Greene 2012
G = uGal/(9.80665e+8); 
end