% Boundary conditions for poisson.m
% 
% Form the boundaries of the Dirichlet problem in a box.
% Here gb = bottom condition, gl = left cond., gr = right, gt = top.
% Used in poisson.m.  BOUNDARY CONDITIONS MUST BE CONTINUOUS
% make sure that if any of them are zero, that they are the length of x.
function [gb,gt,gl,gr] = Form_Boundary(x,y)
% gb is for u(x,0)
% gt is for u(x,endpoint)
% gl is for u(0,y)
% gr is for u(endpoint,y)

gb = (1/2).*sin(6*pi.*x);
gt = sin(pi*2.*x);
gl = 5.*y.*(y-1);
gr = -y.*((y-1).^4);
%
% Written by M. Harper Langston - 5/10/00
% harper@cims.nyu.edu
%
