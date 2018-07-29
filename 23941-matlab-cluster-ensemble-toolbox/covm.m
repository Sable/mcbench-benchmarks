function A = covm(Q,D)
%COVM Covariance matrix.
% A = COVM(Q,D) returns a covariance matrix given an orthogonal matrix, Q,
% and a diagonal matrix, D.  The columns of the orthogonal martix, Q,
% represent the eigenvectors of the covariance matrix and the diagonal
% elements of the diagonal matrix, D, represent the eigenvalues of the
% covariance matrix.
%
% Copyright (2009) Sandia Corporation. Under the terms of Contract 
% DE-AC04-94AL85000 with Sandia Corporation, the U.S. Government retains 
% certain rights in this software.

% covariance matrix
A = Q*D*Q';
