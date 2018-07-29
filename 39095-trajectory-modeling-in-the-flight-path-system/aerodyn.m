function [csubl, csubd] = aerodyn(alpha)

% aerodynamic properties

% input

%  alpha = angle-of-attack (radians)

% output

%  csubl = lift coefficient (non-dimensional)
%  csubd = drag coefficient (non-dimensional)

% STS aero - J. Betts model

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rtd = 180.0 / pi;

cl0 = -0.20704d0;

cl1 = 0.029244d0;

cd0 = 0.07854d0;

cd1 = -6.1592d-3;

cd2 = 6.21408d-4;

alphad = rtd * alpha;

csubl = cl0 + cl1 * alphad;

csubd = cd0 + (cd1 + cd2 * alphad) * alphad;
