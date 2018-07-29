function [X,names]=cylin
% [X,names]=cylin defines cylindrical coordinates
syms r t z real; names=[r t z];
X=[r*cos(t); r*sin(t); z];