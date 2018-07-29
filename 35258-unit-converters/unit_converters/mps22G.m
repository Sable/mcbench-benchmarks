function [G] = mps22G(mps2)
% Convert acceleration from meters per square-second to average
% acceleration due to Earth's gravity. 
% Chad A. Greene 2012
G = mps2*0.1019716213; 