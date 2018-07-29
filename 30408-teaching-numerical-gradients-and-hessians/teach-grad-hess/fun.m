% fun.m
%
% [y, NFV] = fun(X, NFV)
%
% Test objective function for use with the numerical gradient and Hessian
% functions, and the test script sym_hess.m.
%
% Inputs:
%	-> X: Point at which to evaluate the function.
%	-> NFV: Accumulator to keep track of number of function
%		evaluations.
%
% Outputs:
%	-> y: Value of function at X.
%	-> NFV: Accumulator incremented by the number of function
%		evaluations which have taken place.
%
% Created by: Brendan C. Wood
% Created on: February 14, 2011
%
% Copyright (c) 2011, Brendan C. Wood <b.wood@unb.ca>
%

function [y, NFV] = fun(X, NFV)

y = 2*X(1)^5 -3*X(1)*X(3) + 4*X(2)^2 - 9*X(2)*X(3)^2 + 6*X(1)*X(2)*X(3);
NFV = NFV + 1;
