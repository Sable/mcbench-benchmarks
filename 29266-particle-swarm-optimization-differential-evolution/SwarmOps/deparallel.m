% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Differential Evolution (DE) by Storner and Price (1).
% DE is an optimization method that does not use the
% gradient of the problem. This is a parallelized version
% of the DE/rand/1/bin variant.
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
function [bestX, bestFitness, evaluations] = deparallel(problem, data, parameters)

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
    y = zeros(np, n); % To be used later.

    % Compute fitness for all agents in population. (Parallel)
    fitness = zeros(1, np); % Pre-allocate for efficiency.
    newFitness = zeros(1, np); % To be used later.
    parfor i=1:np
        fitness(i) = feval(problem, x(i,:), data);
    end

    % Determine fitness and index of best agent.
    [bestFitness, bestIndex] = min(fitness);

    % Perform optimization iterations until acceptable fitness
    % is achieved or the maximum number of fitness evaluations
    % has been performed.
    evaluations = np; % Fitness evaluations above count as iterations.
    while (evaluations < maxEvaluations) && (bestFitness > acceptableFitness)

        % Update agent positions. (Non-parallel)
        for i=1:np
            % Pick random agents from population. Note that DE
            % normally uses distinct agents so that a, b, and c
            % are distinct from each other and from i, the agent
            % currently being updated. But it is awkward to program
            % and apparently not necessary.
            indices = randperm(np);
            a = indices(1);        % Other agent a.
            b = indices(2);        % Other agent b.
            c = indices(3);        % Other agent c.

            % Pick random index.
            R = randindex(n);

            % Copy old agent as a basis for the new agent.
            y(i,:) = x(i,:);

            % Compute new agent using DE formula.
            for j=1:n
                if (j==R) || (rand(1,1) < cr)
                    y(i,j) = x(i,j) + f * (x(b,j) - x(c,j));
                end
            end

            % Bound position to search-space.
            y(i,:) = bound(y(i,:), lowerBound, upperBound);
        end

        % Compute fitness. (Parallel)
        parfor i=1:np
            newFitness(i) = feval(problem, y(i,:), data);
        end

        % Update agents if fitness improvement. (Non-parallel)
        for i=1:np
            if newFitness(i) < fitness(i)
                % Update fitness.
                fitness(i) = newFitness(i);

                % Update agent position.
                x(i,:) = y(i,:);

                % Update population's best, if improvement.
                if newFitness(i) < bestFitness
                    bestFitness = newFitness(i);
                    bestIndex = i;
                end
            end
        end

        % Increment counter.
        evaluations = evaluations + np;
    end

    % Set best found solution (bestFitness already set).
    bestX = x(bestIndex,:);
end

% ------------------------------------------------------
