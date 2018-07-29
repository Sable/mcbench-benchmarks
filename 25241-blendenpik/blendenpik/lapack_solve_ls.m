function [x, dt] = lapack_solve_ls(A, b)
% [x, dt] = lapack_solve_ls(A, b)
%
% Solve the equation x = arg min norm(A * x - b, 2)
% using LAPACK. 
% 
% Output:
%   x - solution.
%   dt - time eplased on actual computation.
%
% 6-December 2009, Version 1.3
% Copyright (C) 2009, Haim Avron and Sivan Toledo.
