function [uGal] = mps22uGal(mps2)
% Convert acceleration from meters per square-second to microgalileos
% Chad A. Greene 2012
uGal = mps2*1e+8; 