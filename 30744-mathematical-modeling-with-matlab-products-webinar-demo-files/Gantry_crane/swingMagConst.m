function [c, ceq] = swingMagConst(x, ptotal, r, maxAng)
% Compute nonlinear inequalities at x.
% Compute nonlinear equalities at x.

% Copyright 2011 The MathWorks, Inc.

sol = solveCraneODE(x, ptotal, r);

% Compute the maximum absolute angle of oscillation
swingmax = max(abs(sol.Y(:,1)))*180/pi;

c = swingmax - maxAng;
ceq = [];

end

