function [k, yInf, y0, yFit] = fitExponential(x, y)

% FITEXPONENTIAL fits a time series to a single exponential curve. 
% [k, yInf, y0] = fitExponential(x, y)
%
% The fitted curve reads: yFit = yInf + (y0-yInf) * exp(-k*(x-x0)).
% Here yInf is the fitted steady state value, y0 is the fitted initial
% value, and k is the fitted rate constant for the decay. Least mean square
% fit is used in the estimation of the parameters.
% 
% Outputs:
% * k: Relaxation rate
% * yInf: Final steady state
% * y0: Initial state
% * yFit: Fitted time series
% 
% Last modified on 06/26/2012
% by Jing Chen

% improve accuracy by subtracting large baseline
yBase           = y(1);
y               = y - y(1); 

fh_objective    = @(param) norm(param(2)+(param(3)-param(2))*exp(-param(1)*(x-x(1))) - y, 2);

initGuess(1)    = -(y(2)-y(1))/(x(2)-x(1))/(y(1)-y(end));
initGuess(2)    = y(end);
initGuess(3)    = y(1);
param           = fminsearch(fh_objective,initGuess);

k               = param(1);
yInf            = param(2) + yBase;
y0              = param(3) + yBase;

yFit            = yInf + (y0-yInf) * exp(-k*(x-x(1)));