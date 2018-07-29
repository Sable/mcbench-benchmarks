function [x, timing] = blendenpik(A, b, params)
% [x, timing] = blendenpik(A, b, params)
%
% Solve the equation x = arg min norm(A * x - b, 2)
% using Blendenpik. 
% 
% "params" - parameters governning the method.
%    params.type - type of mixing transform. Optional values: 'DCT', 'DHT', 'WHT'.
%                  Default is DHT.
%    params.gamma - gamma * min(n,m) rows/columns will be sampled (A is m-by-n). 
%                   Default is 4.
%    params.preprocess_steps - number of mixing steps to do in advance. 
%                               Default is 1.
%    params.maxcond - maximum condition number of the preconditioner.
%                     Default is 1 / (5 * epsilon_machine).
%    params.tol - convergence thershold for LSQR.
%                 Default is 1e-14.
%    params.maxit - maximum number of LSQR iterations.
%                   Default is 1000.
%    params.lsvec - whether to output in "timing" the LSQR residuals.
%                   Default is false.
%    params.use_full_lsqr - whether to use LSQR with full
%                           orthogonalization. Useful for 
%                           preprocess_steps=0.
%                           Default is false.
%
% Output:
%   x - the solution.
%   timing - statistics on the time spent on various phases.
%          
% 6-December 2009, Version 1.3
% Copyright (C) 2009, Haim Avron and Sivan Toledo.

if (nargin < 3)
    params = struct;
end
    
[m, n] = size(A);
if (m >= n)
    x = blendenpik_over(A, b, params);
else
    x = blendenpik_under(A, b, params);
end