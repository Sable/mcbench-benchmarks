% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Initialize an agent with a uniformly random position.
% Parameters:
%     dim; dimensionality of search-space.
%     lower; lower boundary of search-space.
%     upper; upper boundary of search-space.
% Returns:
%     x; random position.
function x = initagent(dim, lower, upper)
    x = rand(1, dim).*(upper-lower) + lower;
end

% ------------------------------------------------------
