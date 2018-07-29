function [B, tau] = mex_dgeqrf(A)
% B = mex_dgeqrf(A)
%
% Interface to LAPACK's DGEQRF function.
% Upper part of B is the triangular factor.
%          
% 6-December 2009, Version 1.3
% Copyright (C) 2009, Haim Avron and Sivan Toledo.