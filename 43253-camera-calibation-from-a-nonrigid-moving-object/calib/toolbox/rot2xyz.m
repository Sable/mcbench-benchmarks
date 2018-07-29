function xyz = rot2xyz(R)
%ROT2XYZ  Convert rotation matrix to XYZ Euler angles
%   [EX,EY,EZ] = ROT2XYZ(R) converts the rotation matrix R
%   to its corresponding Euler angle representation.
%
% © Copyright Phil Tresadern, University of Oxford, 2006

[xyz(1),xyz(2),xyz(3)] = quat2xyz(rot2quat(R));
