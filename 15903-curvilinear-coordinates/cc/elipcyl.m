function [X,names]=elipcyl 
% [X,names]=elipcyl defines elliptic
% cylinder coordinates
syms et ps z real; names=[et ps z];
X=[cosh(et)*cos(ps); 
   sinh(et)*sin(ps); z];