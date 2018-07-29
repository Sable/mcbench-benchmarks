function y = applanet_func(x)

% heliocentric distance function

% input

%  x = simulation time argument (days)

% output

%  y = heliocentric distance (kilometers)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global tisaved jdtdbi drsaved iap_flg iplanet1

% compute planet state vector

jdtdb = jdtdbi + x;

[r, v] = pecliptic(jdtdb, iplanet1, 11);

% heliocentric scalar distance (kilometers)

srange = iap_flg * norm(r);

drsaved = abs(srange);

% save objective function value and current time

y = srange;

tisaved = x;

