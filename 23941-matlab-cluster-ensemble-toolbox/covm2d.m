function A = covm2d(theta,sx,sy)
%COVM2D 2-D covariance matrix.
% A = COVM2D(THETA,C) returns a 2-D covariance matrix given an angle,
% THETA, and scale factors, sx and sy. The columns of the orthogonal martix
% associated with the rotation by THETA represent the eigenvectors of the
% covariance matrix and the scale factors, sx and sy, represent the
% eigenvalues of the covariance matrix.
%
% Copyright (2009) Sandia Corporation. Under the terms of Contract 
% DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government retains 
% certain rights in this software.

% orthognal rotation matrix (eigenvectr matrix)
Q = [cos(theta) -sin(theta); sin(theta) cos(theta)];

% covariance matrix
A = Q*[sx 0; 0 sy]*Q';
