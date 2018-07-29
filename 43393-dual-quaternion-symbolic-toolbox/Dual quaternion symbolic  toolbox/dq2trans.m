function [vec,d] = dq2trans(dq)

% DQ2TRANS   extracts the translation parameters of a translation dual 
%            quaternion
%
%      VEC = DQ2TRANS(DQ) returns the translation vector VEC of a
%      translation dual quaternion DQ. 
%       - DQ is a translation dual quaternion. It is a 8-vector or an 8*N
%            array (each column is a translation dual quaternion) where N 
%            is the number of translation dual quaternions.     
%       - VEC is the translation vector. VEC is a scalar or an 1*N array 
%            (element i is the translation vector of dual quaternion i)
%
%    [AXIS,D] = DQ2TRANS(DQ) returns the translation axis AXIS and the 
%      translatio distance D of a translation dual quaternion DQ.
%       - AXIS is the unitary (norm equal to 1) translation axis. It is a
%           3-vector or an 3*N array (column i is the translation axis of 
%           dual quaternion i).
%       - D is the translation distance. It is a scalar or a 1*N array
%           (element i is the translation distance of dual quaternion i).
%
% See also DQ2ROT, DQ2SCREW, TRANS2DQ

sdq = size(dq);
if sdq == [1 8]
    dq = dq.'; 
    sdq = size(dq); 
end
n = sdq(2);

% wrong format
if sdq(1) ~= 8 
    error('DualQuaternion:dquat2trans:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end

% Extraction of the translation parameters
if nargout == 1
    vec = 2*dq(6:8,:);
else
    vec = 2*dq(6:8,:);
    d = sqrt(sum(vec.^2));
    vec = vec./repmat(d,3,1);
end

