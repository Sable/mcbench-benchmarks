% num_grad.m
%
% [df, NFV] = num_grad(func, X, NFV, h)
%
% Function to compute the numerical gradient of an arbitrary objective
% function.
%
% Inputs:
%	-> func: Function handle for which numerical derivative is to 
%		be obtained.
%	-> X: Point of interest about which derivative is to be
%		obtained.
%	-> NFV: Accumulator to keep track of number of function
%		evaluations.
%	-> h: Tolerance for differentiation.
%
% Outputs:
%	-> df: Numerical derivative of function func (vector of size
%		n=length(X)).
%	-> NFV: Accumulator incremented by the number of function
%		evaluations which have taken place.
%
% Created by: Brendan C. Wood
% Created on: February 14, 2011
%
% Copyright (c) 2011, Brendan C. Wood <b.wood@unb.ca>
%

function [df, NFV] = num_grad(func, X, NFV, h)

df = zeros(length(X), 1);

% for each dimension of objective function
for i=1:length(X)
    % vary variable i by a small amount (left and right)
    x1 = X;
    x2 = X;
    x1(i) = X(i) - h;
    x2(i) = X(i) + h;
    
    % evaluate the objective function at the left and right points
    [y1, NFV] = func(x1, NFV);
    [y2, NFV] = func(x2, NFV);
    
    % calculate the slope (rise/run) for dimension i
    df(i) = (y2 - y1) / (2*h);
end
