function ydot = j2eqm (t, y)

% first order equations of orbital motion

% j2 gravitational acceleration

% input

%  t = simulation time (seconds)
%  y = state vector

% output

%  ydot = integration vector

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global mu req j2

r2 = y(1) * y(1) + y(2) * y(2) + y(3) * y(3);

r1 = sqrt(r2);

r3 = r2 * r1;

r5 = r2 * r3;

d1 = -1.5 * j2 * req * req * mu / r5;

d2 = 1 - 5 * y(3) * y(3) / r2;

% integration vector

ydot = [y(4)
        y(5)
        y(6)
        y(1) * (d1 * d2 - mu / r3)
        y(2) * (d1 * d2 - mu / r3)
        y(3) * (d1 * (d2 + 2) - mu / r3)];
