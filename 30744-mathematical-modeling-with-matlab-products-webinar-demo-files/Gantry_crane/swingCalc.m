function swingint = swingCalc(x, ptotal, r)
% swingCalc  Calculate integral of residual swing after completion
%
%   This is the objective function for the optimization problem

% Copyright 2011 The MathWorks, Inc.

% Solve ODE
sol = solveCraneODE(x, ptotal, r);
    
% Interpolate from tf (x(3)) to end of simulation
t = linspace(x(3), sol.T(end))';
yf = interp1(sol.T, sol.Y, t);

% Integrate
swingint = trapz(t, abs(yf(:, 1)));