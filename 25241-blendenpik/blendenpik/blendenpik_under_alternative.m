function [x, timing] = blendenpik_under_alternative(A, b, params)
% [x, timing] = blendenpik_under(A, b, params)
%
% Alternative function for solving the equation 
% x = arg min norm(A * x - b, 2) using Blendenpik, where A has 
% more columns than rows. Less stable than the regular version.
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

[m, n] = size(A);
AT = A';
t0 = wtime;
frut_D = sign(randn(n, 1));
B = fast_unitary_transform(AT, frut_D, params.type);
nn = size(B, 1);
frut_D(n+1:nn) = 0;
frut_time = wtime - t0;
disp(sprintf('\t\tRandom unit diagonal + unitary transformation time: %.2f sec', frut_time));
timing.precond_timing.timing.frut_time = frut_time;

t0 = wtime;
t = params.gamma * m / nn;
s = rand(nn, 1);
SB = B(find(s < t), :);
sample_time = wtime - t0;
disp(sprintf('\t\tRandom sampling time: %.2f sec', sample_time));
timing.precond_timing.sample_time = sample_time;

t0 = wtime;
[Y, tau] = mex_dgeqrf(SB); 
qr_time = wtime - t0;
disp(sprintf('\t\tQR on random sample time: %.2f sec', qr_time));
timing.qr_time = qr_time;
    
timing.preprocess_total_time = wtime - t1;
disp(sprintf('\tPreprocessing time: %.2f sec', timing.preprocess_total_time));

%% One solution
t1 = wtime;
y = mex_dtrsm(Y, b, 1.0, 'L', 'U', 'T', 'N');
ssz = size(Y, 1);
p0 = mex_dormqr(Y, tau, [y; zeros(ssz-m, 1)], 'L', 'N');
p1 = zeros(nn, 1); p1(s < t) = p0;
p2 = fast_unitary_transform(p1, frut_D, ['I' params.type]);
p = p2(1:n);
timing.find_non_min_time = wtime - t1;
disp(sprintf('\tFind a non-minimal solution: %.2f sec', timing.find_non_min_time));

%% LSQR
t1 = wtime;
R = triu(Y(1:m, 1:m)); 
% clear Y;
% clear SB
% clear tau;
if (~params.lsvec)
    if (~params.use_full_lsqr)
        [x0, timing.lsqr_its] = dense_lsqr(AT, p, R, params.tol, params.maxit);
    else
        [x0, timing.lsqr_its] = dense_full_lsqr(AT, p, R, params.tol, params.maxit);
    end
else
    [x0, timing.lsqr_its, timing.lsvec, timing.resvec] = dense_lsqr(AT, p, R, params.tol, params.maxit);
end
timing.lsqr_time = wtime - t1;
disp(sprintf('\tLSQR time: %.2f sec', timing.lsqr_time));

%% Mult by AT to get final solution
t1 = wtime;
x = AT * x0;
timing.multAT_time = wtime - t1;
disp(sprintf('\tMultiply by A'' time: %.2f sec', timing.multAT_time));
timing.total_time = wtime - tstart;
disp(sprintf('Total time: %.2f sec', timing.total_time));
