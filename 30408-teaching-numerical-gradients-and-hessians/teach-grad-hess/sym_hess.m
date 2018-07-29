% sym_hess.m
%
% Test script to compute the Hessian of an objective function both
% numerically and symbolically, in order to compare methods.
%
% Created by: Brendan C. Wood
% Created on: February 14, 2011
%
% Copyright (c) 2011, Brendan C. Wood <b.wood@unb.ca>
%

% clear workspace and command window
clear
clc

% tolerance (setting the tolerance too small may result in round-off error)
h = 1e-4;

% point of interest
X = [2, -1, 3]';

% define symbolic variables, store in symbolic array
syms('x1','x2','x3')
x_sym = sym('x_sym', [length(X), 1]);
x_sym(1) = 'x1';
x_sym(2) = 'x2';
x_sym(3) = 'x3';

% define symbolic objective function (same as in fun.m)
f = 2*x1^5 - 3*x1*x3 + 4*x2^2 - 9*x2*x3^2 + 6*x1*x2*x3;

% define symbolic array for derivatives and for Hessian
df_sym = sym('df_sym', [length(X), 1]);
H = sym('H', length(X));

% for each dimension in objective function
for i=1:length(X)
    % calculate symbolic derivative with respect to variable i
    df_sym(i) = diff(f, x_sym(i));
    
    % for each dimension in objective function
    for j=1:length(X)
        % calculate second derivative with respect to variable j
        H(i,j) = diff(df_sym(i), x_sym(j));
    end
end

% substitute numerical point of interest into symbolic matrix
H_sym = subs(H, x_sym, X)

% calculate Hessian with pure numerical method (num_hess.h)
[H_num, NFV] = num_hess(@fun, X, 0, h)
