function [dx, y] = throttleODE(t, x, F, c, k, K, b, varargin)
% ODE function for throttle body dynamics.
% Represent equation of motion by a set of first order equations (state-space) 
%
%	dx: state derivatives at time t
%	y: output at time t
%	
%	t: time value (scalar)
%	x: state vector at time t
%	F: input (step command) at time t
%	c, k, K, b: parameters to be estimated

%   Copyright 2009-2010 The MathWorks, Inc.

NLx = max(90,x(1))-90+min(x(1),15)-15; % nonlinear displacement value

% State equations
dx(1) = x(2);
dx(2) = b*F - c*x(2) - k*x(1) - K*NLx;

% Output equation
y = x(1);

end

