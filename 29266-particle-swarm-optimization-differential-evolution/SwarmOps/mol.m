% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Many Optimizing Liaisons (MOL) optimization method is a
% simplification of PSO originally by Eberhart et al. (1, 2).
% MOL does not have any attraction to the particle's own best
% known position. It is similar to the "Social Only" PSO
% suggested by Kennedy (3) and was studied more thoroguhly
% by Pedersen et al. (4) who found it to sometimes outperform
% PSO and have behavioural parameters that were easier to tune.
% Literature references:
% (1) J. Kennedy and R. Eberhart. Particle swarm optimization.
%     In Proceedings of IEEE International Conference on Neural
%     Networks, volume IV, pages 1942-1948, Perth, Australia, 1995
% (2) Y. Shi and R.C. Eberhart. A modified particle swarm optimizer.
%     In Proceedings of the IEEE International Conference on
%     Evolutionary Computation, pages 69-73, Anchorage, AK, USA, 1998.
% (3) J. Kennedy. The particle swarm: social adaptation of knowledge,
%     In: Proceedings of the IEEE International Conference on
%     Evolutionary Computation, Indianapolis, USA, 1997.
% (4) M.E.H. Pedersen and A.J. Chipperfield. Simplifying particle swarm
%     optimization. Applied Soft Computing, volume 10, pages 618-628, 2010. 
% Parameters:
%     problem; name or handle of optimization problem, e.g. @myproblem.
%     data; data-struct, see e.g. the file myproblemdata.m
%     parameters; behavioural parameters for optimizer,
%                 see file molparameters.m
% Returns:
%     bestX; best found position in the search-space.
%     bestFitness; fitness of bestX.
%     evaluations; number of fitness evaluations performed.
function [bestX, bestFitness, evaluations] = mol(problem, data, parameters)

    % Copy data contents to local variables for convenience.
    n = data.Dim;
    acceptableFitness = data.AcceptableFitness;
    maxEvaluations = data.MaxEvaluations;
    lowerBound = data.LowerBound;
    upperBound = data.UpperBound;

    % Behavioural parameters for this optimizer.
    s = parameters(1);        % Swarm-size
    omega = parameters(2);    % Inertia weight.
    phiG = parameters(3);     % Swarm's best weight.

    % Initialize the velocity boundaries.
    range = upperBound-lowerBound;
    lowerVelocity = -range;
    upperVelocity = range;

    % Initialize swarm.
    x = initpopulation(s, n, data.LowerInit, data.UpperInit);    % Particle positions.
    v = initpopulation(s, n, lowerVelocity, upperVelocity);      % Velocities.

    % Determine swarm's best-known position and its fitness.
    bestFitness = Inf;
    for i=1:s
        % Compute fitness for i'th agent.
        fitness = feval(problem, x(i,:), data);

        % If improvement, update best-known position and fitness.
        if fitness < bestFitness
            bestFitness = fitness;
            bestX = x(i,:);
        end
    end

    % Perform optimization iterations until acceptable fitness
    % is achieved or the maximum number of fitness evaluations
    % has been performed.
    evaluations = s; % Fitness evaluations above count as iterations.
    while (evaluations < maxEvaluations) && (bestFitness > acceptableFitness)

        % Pick index for a random particle from the swarm.
        i = randindex(s);

        % Pick random weight.
        rG = rand(1, 1);

        % Update velocity for i'th particle.
        v(i,:) = omega * v(i,:) + rG * phiG * (bestX - x(i,:));

        % Bound velocity.
        v(i,:) = bound(v(i,:), lowerVelocity, upperVelocity);

        % Update position for i'th particle.
        x(i,:) = x(i,:) + v(i,:);

        % Bound position to search-space.
        x(i,:) = bound(x(i,:), lowerBound, upperBound);

        % Compute fitness.
        fitness = feval(problem, x(i,:), data);

        % Update swarm's best-known position.
        if fitness < bestFitness
            % Update swarm's best-known fitness.
            bestFitness = fitness;

            % Update swarm's best-known position.
            % This must be copied because the particles
            % will continue to move in the search-space.
            bestX = x(i,:);
        end

        % Increment counter.
        evaluations = evaluations + 1;
    end
end

% ------------------------------------------------------
