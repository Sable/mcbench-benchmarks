% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Ackley benchmark problem.
% Parameters:
%     x; the position in the search-space.
%     data; data-struct for optimization problem.
% Returns:
%     fitness; the measure to be minimized.
function fitness = ackley(x, data)
    n = length(x);

    fitness = exp(1) + 20 - 20 * exp(-0.2 * sqrtsum(x, n)) - cossum(x, n);
end

% ------------------------------------------------------

% Helper function.
function result = sqrtsum(x, n)
    result = sqrt(dot(x, x) / n);
end

% ------------------------------------------------------

% Helper function.
function result = cossum(x, n)
    result = exp(sum(cos(2*pi*x))/n);
end

% ------------------------------------------------------
