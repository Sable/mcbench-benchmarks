% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Create data-struct for Rastrigin problem.
% Parameters:
%     dim; the dimensionality of the search-space, e.g. 10.
%     maxEvaluations; the maximum number of fitness evaluations
%                     to perform in optimization.
% Returns:
%     data; the data-struct.
function data = rastrigindata(dim, maxEvaluations)
    data = benchmarkdata(dim, 0.001, maxEvaluations, 2.56, 5.12, -5.12, 5.12);
end

% ------------------------------------------------------
