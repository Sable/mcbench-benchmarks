function [x, w] = cgl(np, a, b)

% computes nodes and weights of the
% Chebyshev-Gauss-Lobatto quadrature formula

% input

%  np   = number of nodes
%  a, b = extrema of the interval

% output

%  x(np, 1) = cgl nodes
%  w(np, 1) = cgl weights

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = np - 1;

ww = pi / n;

w = ww * ones(np, 1);

x(1:np, 1) = -cos((0:n)' * ww);

w(1) = 0.5 * w(1);

w(np) = w(1);

bma = 0.5 * (b - a);

bpa = 0.5 * (b + a);

x = bpa + bma * x;

w = w * bma;