function [x, y, z] = torus (a, n, r, kpi)
% TORUS Generate a torus.
% torus (r, n, a, kpi) generates a plot of a
% torus with central radius a and
% lateral radius r.
% n controls the number of facets
% on the surface.
% kpi makes it possible to draw a whole torus,
% or e.g. half of it.
%
% This script is a modification of a 
% program from:

% MATLAB Primer, 6th Edition
% Kermit Sigmon and Timothy A. Davis
% Section 11.5, page 65.

theta = -pi * (0:2:kpi*n)/n ;
phi = 2*pi* (0:2:n)'/n ;
x = (a + r*cos(phi)) * cos(theta) ;
y = (a + r*cos(phi)) * sin(theta) ;
z = r * sin(phi) * ones(size(theta)) ;