function [uGal] = ftps22uGal(ftps2)
% Convert acceleration from feet per square-second to microgalilelos.
% Chad A. Greene 2012
uGal = ftps2*30480000; 