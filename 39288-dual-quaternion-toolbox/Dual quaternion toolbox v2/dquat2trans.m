function [vec,d] = dquat2trans(dq)

% DQUAT2TRANS extracts the translation parameters of a translation dual 
%            quaternion
%
%    VEC = DQUAT2TRANS(DQ) returns the translation vector VEC of a
%      translation dual quaternion DQ. 
%       - DQ is a translation dual quaternion. It is a 8-vector or an 8*N
%            array (each column is a translation dual quaternion) where N 
%            is the number of translation dual quaternions.     
%       - VEC is the translation vector. VEC is a scalar or an 1*N array 
%            (element i is the translation vector of dual quaternion i)
%
%    [AXIS,D] = DQUAT2TRANS(DQ) returns the translation axis AXIS and the 
%      translatio distance D of a translation dual quaternion DQ.
%       - AXIS is the unitary (norm equal to 1) translation axis. It is a
%           3-vector or an 3*N array (column i is the translation axis of 
%           dual quaternion i).
%       - D is the translation distance. It is a scalar or a 1*N array
%           (element i is the translation distance of dual quaternion i).
%
% See also DQUAT2ROT, DQUAT2SCREW, TRANS2DQUAT

sdq = size(dq);
if sdq == [1 8], dq = dq'; sdq = size(dq); end
n = sdq(2);

% wrong format
if sdq(1) ~= 8 
    error('DualQuaternion:dquat2trans:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end

% check that it is a translation quaternion
tol = 1e-5;
tabcheck = [abs(dq(1,:)-1) ; abs(dq(2:5,:))];
[maxval,imax] = max(max(tabcheck));
if maxval > tol
    warning('DualQuaternion:dquat2trans:wrongFormat',...
        'At least one dual quaternion is not a translation dual quaternion (tol = %.1e).\n Indices of max values: %d \n Max value = %.2e',...
        tol,imax,maxval);
end

% Extraction of the translation parameters
if nargout == 1
    vec = 2*dq(6:8,:);
else
    vec = 2*dq(6:8,:);
    d = sqrt(sum(vec.^2));
    indnot0 = find(d > 0);
    vec(:,indnot0) = vec(:,indnot0)./repmat(d(indnot0),3,1);
end

