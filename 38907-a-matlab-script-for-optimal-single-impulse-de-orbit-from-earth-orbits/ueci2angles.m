function [pitch, yaw] = ueci2angles(reci, veci, ueci)

% convect eci unit vector to rtn angles

% input

%  reci = eci position vector (kilometers)
%  veci = eci velocity vector (kilometers/second)
%  ueci = eci unit vector

% output

%  pitch = pitch angle (radians)
%          positive above the local horizon
%  yaw   = yaw angle (radians)
%          positive in the direction of the angular momentum vector

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compute radial frame unit vectors

rmag = norm(reci);

xrdl = reci / rmag;

zrdl = cross(reci, veci);

hmag = norm(zrdl);

zrdl = zrdl / hmag;

yrdl = cross(zrdl, xrdl);

% unit vector in radial-tangential-normal frame

umee(1) = dot(ueci, xrdl);

umee(2) = dot(ueci, yrdl);

umee(3) = dot(ueci, zrdl);

% pitch angle (radians)

pitch = asin(umee(1));

% yaw angle (radians)

yaw = atan2(umee(3), umee(2));



