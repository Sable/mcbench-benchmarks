% ------------------------------------------------------
% SwarmOps - Heuristic optimization for Matlab
% Copyright (C) 2003-2010 Magnus Erik Hvass Pedersen.
% Please see the file license.txt for license details.
% SwarmOps on the internet: http://www.Hvass-Labs.org/
% ------------------------------------------------------

% Enforce boundaries:
%     if x<lower then y=lower
%     elseif x>upper then y=upper
%     else y=x
% The implementation below works for arrays as well.
% Parameters:
%     x; position to be bounded.
%     lower; lower boundary.
%     upper; upper boundary;
% Returns:
%     y; bounded position.
function y = bound(x, lower, upper)
    y = min(upper, max(lower, x));
end

% ------------------------------------------------------
