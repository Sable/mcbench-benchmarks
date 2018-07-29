function y = capproach_func(x)

% closest approach function

% input

%  x = simulation time argument (days)

% output

%  y = separation distance (kilometers)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global tisaved jdtdbi drsaved 

global iplanet1 iplanet2

% compute planet state vectors

jdtdb = jdtdbi + x;

[r1, v1] = pecliptic(jdtdb, iplanet1, 11);

[r2, v2] = pecliptic(jdtdb, iplanet2, 11);

% separation distance vector (kilometers)

deltar = r2 - r1;

% scalar separation distance (kilometers)

srange = norm(deltar);

drsaved = abs(srange);

% objective function value and current time

y = srange;

tisaved = x;

