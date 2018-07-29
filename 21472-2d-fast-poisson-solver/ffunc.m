% function, f for poisson.m
%
% Assume x and y of same length.
% f is returned as a matrix, analyzed at all interior points of the grid
% if f = 0, make sure f is a matrix of zeros, the size of x, NOT JUST ONE VALUE = 0!
function f = ffunc(x,y)
f = exp(x.*y);
%
% Written by M. Harper Langston - 5/10/00
% harper@cims.nyu.edu
%
