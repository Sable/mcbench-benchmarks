function fval = pendulumFitFunction(t,y,params)
% pendulumFitFunction : returns the fit value of pendulum model to
% experimental data (t,y)

%   Copyright 2008-2009 The MathWorks, Inc.

% Predicted motion
[tout, yout] = pendulumDE(t,params(1),params(2));

% Fitness value
fval = norm(y - yout(:,1));
