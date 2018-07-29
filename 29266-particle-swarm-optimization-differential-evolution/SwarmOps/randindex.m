% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Pick random index randomly and uniformly from {1, ..., n}
% Parameters:
%     n; maximum index that can be returned.
% Returns:
%     idx; the randomly picked index.
function idx = randindex(n)
    idx = ceil(n * rand(1,1));
end

% ------------------------------------------------------
