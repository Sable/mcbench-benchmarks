function y = rz_func(x)

% nodal crossing function

% input

%  x = simulation time argument (days)

% output

%  y = z-component of unit position vector

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global jdtdbi iplanet1

% compute planet's state vector

jdtdb = jdtdbi + x;

[r, v] = pecliptic(jdtdb, iplanet1, 11);

% z-component of unit position vector

y = r(3) / norm(r);


