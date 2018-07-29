function [x, resvec, lsvec] = dense_overdetermined_lsqr(A, b, R, tol, maxit)
% x = dense_overdetermined_lsqr(A, b, R, tol, maxit)
% [x, resvec, lsvec] = dense_overdetermined_lsqr(A, b, R, tol, maxit)
%
% LSQR on a dense overdetermined matrix with a dense preconditioner R.
% Solves x = arg min (A*x - b)
% Inputs:
%   A, b
%   R - Upper triangular preconditioner. kappa(A * inv(R)) governs
%       the convergence.
%   tol - tolerance. Stop when 
%      norm(inv(R') * A' * r) / (norm(A * inv(R), 'fro') * norm(r)) < tol
%   maxit - Maximum number of iterations
% 
% Outputs:
%   x 
%   optional: resvec, lsvec - values of norm(A' * r) and norm(r).
%
% 6-December 2009, Version 1.3
% Copyright (C) 2009, Haim Avron and Sivan Toledo.
