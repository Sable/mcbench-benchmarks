function vopt  = min_by_random_search( fnc, region )
% function vopt  = min_by_random_search( fnc, region )
%
% Minimization of a function by iterative random search.
% Written by Dr. Yoash Levron, February 2013.
%
% This function implements a minimization algorithm,
% based on iterative random search.
% At each iteration, the function randomize vectors
% in the search region, and finds the one that minimizes
% the target function. Then, a smaller search
% region is defined around this minimizer. The process
% repeats itself, shrinking the search region until convergence.
%
% This algorithm converges slower than gradient based
% algorithm, but it has several advantages:
% a)  It does not require a specific derivative.
% b)  It converges to a global optimum, even if
%      the function holds many local ones.
%
% The algorithm works well with functions of relatively low
% dimension: up to about 10-20 variables. If the dimension
% is too high, the function may fail to locate a global minimum.
% A useful test is to run the function a few times, checking
% if it locates the same optimum.
%
%%% inputs:
% fnc - A handle to the target function to be minimized.
%
% region - 2*N matix specifying the region of search.
%                It specifies a range for each of the function variables.
%                region(1,n) - is the low bound for variable n
%                region(2,n) - is the high bound for variable n
%
%%% outputs:
% vopt - (N*1), the minimizing vector.

% number of variables
N = size(region,2);

% optimization parameters
tol = 1e-15;   % relative tolerance
M = 100^N; % number of vectors to randomize.
step = 0.5;  % in the range [0-1]. size of new region in comparison to old one.

%%% limit the number of points
Max_Array_size = 5e6;
if (M > Max_Array_size)
    M = Max_Array_size;
    'Warning - reducing number of samples due to memory limit'
    beep;
end

% evaluate tolerance
MT = 1e4;
x = rand(N,MT);
x = diag(region(2,:) - region(1,:))*x; % strech
x = x + (region(1,:).') * ones(1,MT) ;  % offset
Z = abs(feval(fnc, x));
med = median(Z);
abs_tol = abs(med * tol);  % absolute tolerance to stop the search

% start the iterative search
Val = inf;
lastVal = -inf;

while (abs(Val - lastVal) > abs_tol)
    region
    %%% randomize vectors within the region
    x = rand(N,M);
    x = diag(region(2,:) - region(1,:))*x; % strech
    x = x + (region(1,:).') * ones(1,M) ;  % offset
    Z = feval(fnc, x);
    
    %%% find the optimal solution within the current resolution
    ii = find(Z == min(Z));  ii = ii(1);
    vopt = x(:,ii);
    lastVal = Val;
    Val = feval(fnc, vopt);
    
    %%% refine the search region, around the optimal vector
    for n = 1:N
        width = (region(2,n) - region(1,n)) * step;
        low = vopt(n) - width/2;
        high = vopt(n) + width/2;
        if (low < region(1,n))
            low = region(1,n);
            high = region(1,n) + width;
        elseif (high > region(2,n))
            high = region(2,n);
            low = high - width;
        end
        region(:,n) = [low ; high];
    end
    
end


end

