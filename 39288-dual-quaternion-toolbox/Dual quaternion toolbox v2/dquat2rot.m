function [theta,axis] = dquat2rot(dq)

% DQUAT2ROT  extracts the rotation axis and angle of a rotation dual 
%            quaternion
%
%   [THETA,AXIS] = DQUAT2ROT(DQ) returns the rotation angle, THETA [deg], 
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
% See also DQUAT2TRANS, DQUAT2SCREW, ROT2DQUAT

sdq = size(dq);
if sdq == [1 8], dq = dq'; sdq = size(dq); end
n = sdq(2);

% wrong format
if sdq(1) ~= 8 
    error('DualQuaternion:dquat2rot:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end

% check that it is a rotation dual quaternion
tol = 1e-5;
[maxval,imax] = max(max(abs(dq(5:8,:))));
if maxval > tol
    warning('DualQuaternion:dquat2rot:wrongFormat',...
        'At least one dual quaternion is not a rotation dual quaternion (tol = %.1e).\n Indices of max values: %d \n Max value = %.2e',...
        tol,imax,maxval);
end
normDQ = sqrt(sum(dq(1:4,:).^2));
[maxval2,imax2] = max(abs(normDQ-1));
if maxval2 > tol 
       warning('DualQuaternion:dquat2rot:wrongFormatForRotation',...
        'At least one dual quaternion is not a rotation dual quaternion (is it a rotation dual quaternion?) (tol = %.1e).\n Indices of max values: %d \n Max value = %.2e',...
        tol,imax2,maxval2);
end

indpos = find(dq(1,:) > 1);
dq(1,indpos) = ones(1,length(indpos));
indneg = find(dq(1,:) < -1);
dq(1,indneg) = ones(1,length(indneg));

% Extraction of the rotation parameters
theta = 2*acosd(dq(1,:)); % acosd: [-1,1] --> [0,180]
theta = mod(theta,360);
indthetaOK = find(theta > 0);
axis = [ones(1,n) ; zeros(2,n)];
if length(indthetaOK > 0)
    repsin = repmat(sind(theta(indthetaOK)/2),3,1);
    axis(:,indthetaOK) = dq(2:4,indthetaOK)./repsin;
end
