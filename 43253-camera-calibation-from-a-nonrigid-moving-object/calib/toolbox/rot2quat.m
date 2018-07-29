function Q = rot2quat(R)
%ROT2QUAT  Convert rotation matrix to quaternion
%   ROT2QUAT(R) converts the rotation matrix R to its
%   quaternion representation.
%
%   see also QUAT2ROT
%
% © Copyright Phil Tresadern, University of Oxford, 2006

t			= real(logm(R));
ax		= [t(6); t(7); t(2)];
theta	= norm(ax);
ax		= ax / norm(ax);
st		= sin(theta/2);
twopi = 2*pi;
 
Q			= [st*ax(1); st*ax(2); st*ax(3); cos(theta/2)];
