function [R, flag, timing, x0] = random_sample_precond(A, params, b)
% [R, flag, timing] = random_sample_precond(A, params)
%
% Builds a least-squares preconditioners for A based on 
% random sampling.
% 
% "params" - parameters governning the method.
%    params.type - type of mixing transform. Optional values: 'DCT', 'DHT', 'WHT'.
%                  Default is DHT.
%    params.gamma - gamma * n rows will be sampled (A is m-by-n). 
%                   Default is 4.
%    params.preprocess_steps - number of mixing steps to do in advance. 
%                               Default is 1.
%    params.maxcond - maximum condition number of the preconditioner.
%                     Default is 1 / (5 * epsilon_machine).
%
%
% Output:
%   R - the upper triangular factor of the preconditioner.
%   flag - success flag. If this function fails then probably A is rank
%          deficient. 
%   timing - statistics on the time spent on various phases.
%          
%
% 6-December 2009, Version 1.3
% Copyright (C) 2009, Haim Avron and Sivan Toledo.

if (nargin < 2)
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

if (~isfield(params, 'maxcond'))
    params.maxcond = 1 / (5 * eps);
end

if (~isfield(params, 'slight_coherence'))
    params.slight_coherence = 0;
end

if (~isfield(params, 'improve_start_point'))
    params.improve_start_point = false;
end

[m, n] = size(A);
mm = m;
times = 0;

timing.qr_time = 0;
timing.condest_time = 0;
timing.sample_time = 0;
timing.frut_time = 0;

if (~params.improve_start_point)
    x0 = [];
end

htimes =  params.preprocess_steps;
while (true)
   
    t0 = wtime;
    for i = 1:htimes
        D = sign(randn(mm, 1));
        A = fast_unitary_transform(A, D, params.type);
        mm = size(A, 1);
        
        if (params.improve_start_point)
            b = fast_unitary_transform(b, D, params.type);
        end
    end
    frut_time = wtime - t0;
    disp(sprintf(['\t\tRandom unit diagonal + unitary transformation time: ' ...
                  '%.2f sec'], frut_time));
    timing.frut_time = timing.frut_time + frut_time;

    t0 = wtime;
    %t = params.gamma * n / m;
    t = params.gamma * n / mm;
    s = rand(mm, 1);
    rows = find(s < t);
    R = A(rows, :);
    sample_time = wtime - t0;
    disp(sprintf('\t\tRandom sampling time: %.2f sec', sample_time));
    timing.sample_time = timing.sample_time + sample_time;

    if (params.slight_coherence > 0)
        R = [R; max(max(R))* rand(params.slight_coherence, n)];
    end
    
    t0 = wtime;
    if (~params.improve_start_point)
        R = mex_dgeqrf(R);  
        R = triu(R(1:n, 1:n));  
    else
        [R, tau] = mex_dgeqrf(R); 
        Qtb = mex_dormqr(R, tau, b(rows), 'L', 'T');
        R = triu(R(1:n, 1:n));  
        x0 = R \ Qtb(1:n);
    end

    qr_time = wtime - t0;
    disp(sprintf('\t\tQR on random sample time: %.2f sec', qr_time));
    timing.qr_time = timing.qr_time + qr_time;
    
    % Check if complete
    t0 = wtime;
    ce = mex_dtrcon(R);
    condest_time = wtime - t0;
    disp(sprintf('\t\tCondition estimation: %.2f sec', condest_time));
    timing.condest_time = timing.condest_time + condest_time;
    
    times = times + 1;
    
    if (ce > (1/ params.maxcond))
        flag = true;
        return;
    else
        if (times <= 3)
            disp(sprintf(['\t\tFailed to produced a non singular ' ...
                          'preocnditioner... applying one more FRUT...']));
            htimes = 1;
        else
            disp(sprintf('\t\tFailed to produced a non singular preocnditioner... too many FRUTs... giving up...'));
            flag = false;
            return;
        end
    end
end