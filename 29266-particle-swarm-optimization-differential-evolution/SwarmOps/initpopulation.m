% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Initialize a population of agents with uniformly random
% positions.
% Parameters:
%     numAgents; number of agents in population.
%     dim; dimensionality of search-space.
%     lower; lower boundary of search-space.
%     upper; upper boundary of search-space.
% Returns:
%     x; random position.
function x = initpopulation(numagents, dim, lower, upper)
    % Preallocate array for efficiency.
    x = zeros(numagents,dim);

    for i=1:numagents
        x(i,:) = initagent(dim, lower, upper);
    end
end

% ------------------------------------------------------
