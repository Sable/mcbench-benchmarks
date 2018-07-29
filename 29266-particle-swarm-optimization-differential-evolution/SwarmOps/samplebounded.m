% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Pick a random point from a bounded range.
% Parameters:
%     n; dimensionality of the search-space.
%     x; center position of the sampling-range.
%     range; desired sampling-range.
%     lowerBound; search-space lower-boundary.
%     upperBound; search-space upper-boundary.
% Returns:
%     fitness; the measure to be minimized.
function y = samplebounded(n, x, range, lowerBound, upperBound)

    % Adjust sampling range so it does not exceed bounds.
    l = max(x - range, lowerBound);
    u = min(x + range, upperBound);

    % Pick a sample from within the bounded range.
    y = initagent(n, l, u);
end

% ------------------------------------------------------
