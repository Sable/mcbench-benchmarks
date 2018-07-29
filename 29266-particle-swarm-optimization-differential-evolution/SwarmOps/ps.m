% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Pattern Search (PS), an early variant was originally
% due to Fermi and Metropolis at the Los Alamos nuclear
% laboratory as described by Davidon (1). It is also
% sometimes called compass search. This is a slightly
% different variant by Pedersen (2). It works especially
% well when only few optimization iterations are allowed.
% Literature references:
% (1) W.C. Davidon. Variable metric method for minimization.
%     SIAM Journal on Optimization, 1(1):1-17, 1991
% (2) M.E.H. Pedersen. Tuning & Simplifying Heuristical
%     Optimization. PhD Thesis, University of Southampton,
%     2010.
% Parameters:
%     problem; name or handle of optimization problem, e.g. @myproblem.
%     data; data-struct, see e.g. the file myproblemdata.m
%     parameters; behavioural parameters for optimizer (none.)
% Returns:
%     bestX; best found position in the search-space.
%     bestFitness; fitness of bestX.
%     evaluations; number of fitness evaluations performed.
function [bestX, bestFitness, evaluations] = ps(problem, data, parameters)

    % Copy data contents to local variables for convenience.
    n = data.Dim;
    acceptableFitness = data.AcceptableFitness;
    maxEvaluations = data.MaxEvaluations;
    lowerBound = data.LowerBound;
    upperBound = data.UpperBound;

    % Initialize the range-vector to full search-space.
    d = upperBound-lowerBound;

    % Initialize x with random position in search-space.
    x = initagent(n, data.LowerInit, data.UpperInit);

    % Compute fitness of initial position.
    fitness = feval(problem, x, data);

    % Perform optimization iterations until acceptable fitness
    % is achieved or the maximum number of fitness evaluations
    % has been performed.
    evaluations=1;
    while (evaluations < maxEvaluations) && (fitness > acceptableFitness)

        idx = randindex(n);            % Pick random index from {1, ..., n}
        t = x(idx);                    % Save old element.
        x(idx) = x(idx) + d(idx);      % Make new element.

        % Bound to search-space.
        x(idx) = bound(x(idx), lowerBound(idx), upperBound(idx));

        % Compute new fitness.
        newFitness = feval(problem, x, data);

        % If improvement to fitness, update.
        if newFitness < fitness
            fitness = newFitness;
        else
            x(idx) = t;                % Otherwise restore the position,
            d(idx) = d(idx) * -0.5;    % reduce search-range and invert direction.
        end

        % Increment counter.
        evaluations = evaluations + 1;
    end

    % Copy best found position and fitness.
    bestX = x;
    bestFitness = fitness;
end

% ------------------------------------------------------
