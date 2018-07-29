% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Local Unimodal Sampling (LUS) optimizer by Pedersen (1).
% Performs localized sampling of the search-space with a
% sampling range that initially covers the entire
% search-space and is decreased exponentially as optimization
% progresses. LUS works especially well for optimization
% problems where only short runs can be performed.
% Literature references:
% (1) M.E.H. Pedersen. Tuning & Simplifying Heuristical
%     Optimization. PhD Thesis, University of Southampton,
%     2010.
% Parameters:
%     problem; name or handle of optimization problem, e.g. @myproblem.
%     data; data-struct, see e.g. the file myproblemdata.m
%     parameters; behavioural parameters for optimizer,
%                 see file lusparameters.m
% Returns:
%     bestX; best found position in the search-space.
%     bestFitness; fitness of bestX.
%     evaluations; number of fitness evaluations performed.
function [bestX, bestFitness, evaluations] = lus(problem, data, parameters)

    % Copy data contents to local variables for convenience.
    n = data.Dim;
    acceptableFitness = data.AcceptableFitness;
    maxEvaluations = data.MaxEvaluations;
    lowerBound = data.LowerBound;
    upperBound = data.UpperBound;

    % Behavioual parameters for this optimizer.
    gamma = parameters(1);

    % Derived behavioural parameters for this optimizer.
    q = 0.5 ^ (1/(gamma*n));

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

        % Sample new position y from the bounded surroundings
        % of the current position x.
        y = samplebounded(n, x, d, lowerBound, upperBound);

	% Compute new fitness.
        newFitness = feval(problem, y, data);

        if newFitness < fitness
            fitness = newFitness;    % If improvement to fitness, update.
            x = y;
        else
            d = q * d;               % Otherwise decrease the search-range.
        end

	% Increment counter.
        evaluations = evaluations + 1;
    end

    % Copy best found position and fitness.
    bestX = x;
    bestFitness = fitness;
end

% ------------------------------------------------------
