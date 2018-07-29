% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Differential Evolution (DE) by Storner and Price (1).
% DE is an optimization method that does not use the
% gradient of the problem. This is the DE/rand/1/bin variant.
% Literature references:
% (1) R. Storn and K. Price. Differential evolution - a simple
%     and efficient heuristic for global optimization over
%     continuous spaces. Journal of Global Optimization,
%     11:341-359, 1997.
% Parameters:
%     problem; name or handle of optimization problem, e.g. @myproblem.
%     data; data-struct, see e.g. the file myproblemdata.m
%     parameters; behavioural parameters for optimizer,
%                 see file deparameters.m
% Returns:
%     bestX; best found position in the search-space.
%     bestFitness; fitness of bestX.
%     evaluations; number of fitness evaluations performed.
function [bestX, bestFitness, evaluations] = de(problem, data, parameters)

    % Copy data contents to local variables for convenience.
    n = data.Dim;
    acceptableFitness = data.AcceptableFitness;
    maxEvaluations = data.MaxEvaluations;
    lowerBound = data.LowerBound;
    upperBound = data.UpperBound;

    % Behavioural parameters for this optimizer.
    np = parameters(1);       % Population size
    cr = parameters(2);       % Crossover probability.
    f = parameters(3);        % Differential weight.

    % Initialize population.
    x = initpopulation(np, n, data.LowerInit, data.UpperInit);

    % Compute fitness for all agents in population.
    fitness = zeros(1, np); % Pre-allocate for efficiency.
    for i=1:np
        fitness(i) = feval(problem, x(i,:), data);
    end

    % Determine fitness and index of best agent.
    [bestFitness, bestIndex] = min(fitness);

    % Perform optimization iterations until acceptable fitness
    % is achieved or the maximum number of fitness evaluations
    % has been performed.
    evaluations = np; % Fitness evaluations above count as iterations.
    while (evaluations < maxEvaluations) && (bestFitness > acceptableFitness)

        % Pick random and distinct agents from population.
        indices = randperm(np);
        i = indices(1);        % Agent to update.
        a = indices(2);        % Other agent a.
        b = indices(3);        % Other agent b.
        c = indices(4);        % Other agent c.

        % Pick random index.
        R = randindex(n);

        % Copy old agent as a basis for the new agent.
        y = x(i,:);

        % Compute new agent using DE formula.
        for j=1:n
            if (j==R) || (rand(1,1) < cr)
                y(j) = x(i,j) + f * (x(b,j) - x(c,j));
            end
        end

        % Bound position to search-space.
        y = bound(y, lowerBound, upperBound);

        % Compute fitness.
        newFitness = feval(problem, y, data);

        % Update agent if fitness improvement.
        if newFitness < fitness(i)
            % Update fitness.
            fitness(i) = newFitness;

            % Update agent position.
            x(i,:) = y;

            % Update population's best, if improvement.
            if newFitness < bestFitness
                bestFitness = newFitness;
                bestIndex = i;
            end
        end

        % Increment counter.
        evaluations = evaluations + 1;
    end

    % Set best found solution (bestFitness already set).
    bestX = x(bestIndex,:);
end

% ------------------------------------------------------
