function [X,names]=sphr
% [X,names]=sphr defines spherical coordinates
syms r t p real; names=[r t p]; 
X=[r*sin(t)*cos(p);r*sin(t)*sin(p);r*cos(t)];