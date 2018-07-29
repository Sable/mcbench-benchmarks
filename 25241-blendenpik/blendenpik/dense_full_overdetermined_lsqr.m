function [x, resvec, lsvec] = dense_full_overdetermined_lsqr(A, b, R, tol, maxit)
% x = dense_full_overdetermined_lsqr(A, b, R, tol, maxit)
% [x, resvec, lsvec] = dense_full_overdetermined_lsqr(A, b, R, tol, maxit)
%
% Same as dense_overdetermined_lsqr, only uses full orthogonalization.
%
% 6-December 2009, Version 1.3
% Copyright (C) 2009, Haim Avron and Sivan Toledo.
