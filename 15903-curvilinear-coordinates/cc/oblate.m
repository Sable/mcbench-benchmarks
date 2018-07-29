function [X,names]=oblate
% [X,names]=oblate defines oblate spheroidal coordinates
syms e t p real; names=[e,t,p];
X=[cosh(e)*sin(t)*cos(p);
   cosh(e)*sin(t)*sin(p);
   sinh(e)*cos(t)];