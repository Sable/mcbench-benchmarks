function xdot = dto_rhs (t, x, u)

% first-order equations of motion

% required by dto_trap.m

% input

%  t = current time

%  x = current state vector

%  x(1) = r, x(2) = u, x(3) = v

%  u = current control vector

% output

%  xdot = rhs equations of motion

%  xdot(1) = r dot, xdot(2) = u dot, xdot(3) = v dot

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global acc beta

% current control variable

theta = u(1);

% current thrust acceleration

accm = acc / (1.0 - beta * t);

% evaluate equations of motion at current conditions

xdot(1) = x(2);

xdot(2) = (x(3) * x(3) - 1.0 / x(1)) / x(1) + accm * sin(theta);

xdot(3) = -x(2) * x(3) / x(1) + accm * cos(theta);



