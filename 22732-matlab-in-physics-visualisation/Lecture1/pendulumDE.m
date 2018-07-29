function [tout,yout] = pendulumDE(tVals,omega0,startAngle)

%   Copyright 2008-2009 The MathWorks, Inc.

% Equations of motion
eqnsOfMotion = @(t,x) [x(2); -omega0^2*sin(x(1))];

[tout,yout] = ode45(eqnsOfMotion,tVals,[startAngle; 0]);
