function [theta,axis] = dq2rot(dq)

% DQ2ROT     extracts the rotation axis and angle of a rotation dual 
%            quaternion
%
%       [THETA,AXIS] = DQ2ROT(DQ) returns the rotation angle, THETA [deg], 
%       and the rotation axis, AXIS, of a rotation dual quaternion DQ. 
%       - DQ is a rotation dual quaternion. It is a 8-vector or an 8*N
%       array (each column is a rotation dual quaternion) where N is the 
%       number of rotation dual quaternions.     
%       - THETA is the rotation angle [deg]. It is comprised between 0 and
%       180deg. THETA is a scalar or an 1*N array (element i is the 
%       rotation angle of dual quaternion i).
%       - AXIS is the unitary (norm equal to 1) rotation axis. It is a
%       3-vector or an 3*N array (column i is the rotation axis of
%       dual quaternion i).
%
% See also DQ2TRANS, DQ2SCREW, ROT2DQ

sdq = size(dq);
if sdq == [1 8]
    dq = dq.'; 
    sdq = size(dq); 
end
n = sdq(2);

% wrong format
if sdq(1) ~= 8 
    error('DualQuaternion:dquat2rot:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end

% Extraction of the rotation parameters
theta = 2*acos(dq(1,:)); 
axis = sym([ones(1,n) ; zeros(2,n)]);
repsin = repmat(sin(theta(n)/2),3,1);
axis(:,n) = dq(2:4,n)./repsin;

