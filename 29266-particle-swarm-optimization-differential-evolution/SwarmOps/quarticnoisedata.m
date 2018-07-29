% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Create data-struct for QuarticNoise problem.
% Parameters:
%     dim; the dimensionality of the search-space, e.g. 10.
%     maxEvaluations; the maximum number of fitness evaluations
%                     to perform in optimization.
% Returns:
%     data; the data-struct.
function data = quarticnoisedata(dim, maxEvaluations)
    data = benchmarkdata(dim, 1.0, maxEvaluations, 0.64, 1.28, -1.28, 1.28);

    % Array used by quarticnoise function to save time.
    data.steps = [1:dim];
end

% ------------------------------------------------------
