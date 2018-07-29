function [x, resvec, xvec] = dense_underdetermined_lsqr(A, b, L, tol, maxit)
% x = dense_underdetermined_lsqr(A, b, R, tol, maxit)
% [x, resvec, xvec] = dense_underdetermined_lsqr(A, b, R, tol, maxit)
%
% LSQR on a dense underdetermined matrix with a dense preconditioner L.
% Solves min(norm(x, 1)) s.t. Ax=b. A must be full rank.
% Inputs:
%   A, b
%   L - Lower triangular preconditioner. kappa(L \ A) governs
%       the convergence.
%   tol - tolerance. Stop when norm(r)/norm(b) < tol (norm(r) is
%         approximated).
%   maxit - Maximum number of iterations
% 
% Outputs:
%   x 
%   optional: resvec, xvec - values of norm(r) and norm(x).
%
% 6-December 2009, Version 1.3
% Copyright (C) 2009, Haim Avron and Sivan Toledo.
