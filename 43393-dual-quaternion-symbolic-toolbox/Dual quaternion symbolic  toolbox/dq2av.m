function AV = dq2av(dq)

% DQ2AV     transforms a rotation dual quaternion into its angular vecor
%           representation
%
%       AV = DQ2AV(DQ) returns the angular vector AV [deg] of a rotation 
%       dual quaternion DQ. 
%       - DQ is a rotation dual quaternion. It is a 8-vector or an 8*N
%          array (each column is a rotation dual quaternion) where N is the 
%          number of rotation dual quaternions.   
%       - AV is the angular vector representation of a rotation of angle
%          theta and unitary vecotr n. AV = theta*n = theta*[nx ny nz]. It
%          is expressed in [deg]. AV is a 3*N array (where column i is the
%          angular vector representation of rotation i).
%
% See also AV2DQ, DQ2ROT

[theta,axis] = dquat2rot(dq);
AV = repmat(theta,3,1).*axis;

