% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% QuarticNoise benchmark problem.
% Parameters:
%     x; position in the search-space.
%     data; data-struct for optimization problem.
% Returns:
%     fitness; the measure to be minimized.
function fitness = quarticnoise(x, data)
    x2 = x .* x;
    x4 = x2 .* x2;

    fitness = sum(data.steps .* x4 + rand(1, data.Dim));
end

% ------------------------------------------------------
