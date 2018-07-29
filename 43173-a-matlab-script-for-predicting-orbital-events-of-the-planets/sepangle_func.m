function y = sepangle_func(x)

% separation angle function

% input

%  x = simulation time argument (days)

% output

%  y = separation angle (radians)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global tisaved jdtdbi drsaved 

global iplanet1 iplanet2

% compute planet state vectors

jdtdb = jdtdbi + x;

[r1, v1] = pecliptic(jdtdb, iplanet1, 11);

[r2, v2] = pecliptic(jdtdb, iplanet2, 11);

% compute separation angle (radians)

up1 = r1 / norm(r1);

up2 = r2 / norm(r2);

sep_angle = acos(dot(up1, up2));

drsaved = abs(sep_angle);

% objective function value and current time

y = sep_angle;

tisaved = x;

