function [X,names]=notort
% [X,names]=notort is a special non-orthogonal
% coordinate system chosen to have all metric
% tensor components nonzero.
syms r t p real; names=[r t p];
X=r*p*[sin(t)*cos(p); sin(t)*sin(p); cos(t)/4];