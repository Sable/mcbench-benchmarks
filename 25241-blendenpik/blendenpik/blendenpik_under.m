function [x, timing] = blendenpik_under(A, b, params)
% [x, timing] = blendenpik_under(A, b, params)
%
% Solve the equation x = arg min norm(A * x - b, 2)
% using Blendenpik, where A has more columns than rows.
% 
% "params" - parameters governning the method.
%    params.type - type of mixing transform. Optional values: 'DCT', 'DHT', 'WHT'.
%                  Default is DHT.
%    params.gamma - gamma * m columns will be sampled (A is m-by-n). 
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

if (~isfield(params, 'type'));
    params.type = 'DHT';
end

if (~isfield(params, 'gamma'))
    params.gamma = 4;
end

if (~isfield(params, 'preprocess_steps'))
    params.preprocess_steps = 1;
end

if (~isfield(params, 'tol'))
    params.tol = 1e-14;
end

if (~isfield(params, 'maxit'))
    params.maxit = 1000;
end

if (~isfield(params, 'maxcond'))
    params.maxcond = 1 / (5 * eps);
end

if (~isfield(params, 'lsvec'))
    params.lsvec = false;
end

if (~isfield(params, 'slight_coherence'))
    params.slight_coherence = 0;
end

if (~isfield(params, 'use_full_lsqr'))
    params.use_full_lsqr = false;
end

tstart = wtime;

%% Build preconditioner
t1 = wtime;
[R, flag, timing.precond_timing] = random_sample_precond(A', params);
L = R';
timing.precond_total_time = wtime - t1;
disp(sprintf('\tBuilding preconditioner time: %.2f sec', timing.precond_total_time));

%% Solve
if (flag)  
    t1 = wtime;
    if (~params.lsvec)
        if (~params.use_full_lsqr)
            [x, timing.lsqr_its] = dense_underdetermined_lsqr(A, b, L, params.tol, params.maxit);
            %[x, timing.lsqr_its] = lsqr(L \ A, L \ b, params.tol, params.maxit);
        else
            error('Full LSQR for underdetermined systems not supported');
        end
    else
        [x, timing.lsqr_its, timing.resvec, timing.xvec] = dense_underdetermined_lsqr(A, ...
                                                          b, R, params.tol, params.maxit);
    end
    timing.lsqr_time = wtime - t1;
    disp(sprintf('\tLSQR time: %.2f sec', timing.lsqr_time));

    % Check for convergence
    %t1 = wtime;
    %r = A * x - b;
    %tau = norm(A' * r) / (norm(r) * mex_dlange(A));
    %disp(sprintf('\tBackward error: %.2e sec', tau));
    %if (tau > params.tol)
    %    disp('WARNING: Backward error is not below threshold!');
    %end 
    %timing.check_time = wtime - t1;
    %disp(sprintf('\tConvergence test time: %.2f sec', timing.check_time));
else
    disp(sprintf('Failed to get a full rank preconditioner. Using LAPACK.'));
    [x, timing.lapack_time] = lapack_solve_ls(A, b);
end



timing.total_time = wtime - tstart;
disp(sprintf('Total time: %.2f sec', timing.total_time));

