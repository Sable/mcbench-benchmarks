% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Create data-struct for Griewank problem.
% Parameters:
%     dim; the dimensionality of the search-space, e.g. 10.
%     maxEvaluations; the maximum number of fitness evaluations
%                     to perform in optimization.
% Returns:
%     data; the data-struct.
function data = griewankdata(dim, maxEvaluations)
    data = benchmarkdata(dim, 0.001, maxEvaluations, 300, 600, -600, 600);

    % Array used by griewank function to save time.
    data.steps = sqrt([1:dim]);
end

% ------------------------------------------------------
