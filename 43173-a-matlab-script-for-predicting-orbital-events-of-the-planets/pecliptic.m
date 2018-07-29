function [r, v] = pecliptic(jdtdb, ntarg, ncent)

% planet position and velocity vectors
% in mean ecliptic and equinox of j2000

% input

%  jdtdb = TDB julian date

%  ntarg = integer number of 'target' point

%  ncent = integer number of center point

% output

%  r = position vector (mean ecliptic and equinox of j2000)

%  v = velocity vector (mean ecliptic and equinox of j2000)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global eq2000

% compute eme2000 state vector

sv = jplephem(jdtdb, ntarg, ncent);

% transform to mean ecliptic and equinox of j2000

r = eq2000 * sv(1:3);

v = eq2000 * sv(4:6);

end

