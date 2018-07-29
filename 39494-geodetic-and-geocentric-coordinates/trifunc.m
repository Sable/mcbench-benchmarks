function fz = trifunc (z)

% triaxial objective function

% input

%  z = function argument

% output

%  fz = function value at z

% Orbital Mechanics with Matlab

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global cx cy cz vcon ucon caxis

den1 = (cz + vcon * z) ^ 2;

den2 = (cz + ucon * z) ^ 2;

fz = (1.0 + (cy / den1) + (cx / den2)) * z ^ 2 - caxis ^ 2;
