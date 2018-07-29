% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Example optimization problem. You may use this as
% a starting point for custom problems.
% Parameters:
%     x; position in the search-space.
%     data; data-struct for optimization problem.
% Returns:
%     fitness; the measure to be minimized.
function fitness = myproblem(x, data)
    % Retrieve data from struct.
    r = data.MyExtraData;

    % Displace position.
    t = x-r;

    % Compute and return fitness.
    fitness = (2*t(1)-t(2))^2 + ...
              (3*t(2)-2*t(3))^2 + ...
              (4*t(3)-3*t(4))^2 + ...
              (t(4)-4*t(1))^2 + ...
              sum(t.^2);
end

% ------------------------------------------------------
