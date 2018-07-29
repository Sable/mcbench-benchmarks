function dq = rot2dquat(theta,axis)

% ROT2DQUAT   constructs a rotation dual quaternion (theta in [deg]!)
%
%    DQ = ROT2DQUAT(THETA,AXIS) returns the dual quaternion DQ which is the
%     dual quaternion representation of a rotation of angle THETA and of 
%     axis AXIS. 
%       -   THETA represents the rotation angle [deg]. It is a scalar or a
%               N-vector (the i-th element represents the angle of the i-th
%               rotation) where N is the number of rotations. 
%       -   AXIS represents the rotation axis. It is a 3-vector or a 3*N 
%               array (column i represents the rotation axis of the i-th
%               rotation) where N is the number of rotations.
%       -   DQ is a 8*N array representing the rotation dual quaternion: 
%       Several combinations are possible:
%           - THETA is a N-vector and AXIS is a 3-vector ==> DQ is a 8*N 
%             array where colum i represents a dual quaternion rotation of
%             angle THETA(i) and of axis AXIS.
%           - AXIS is a 3*N array and THETA is a scalar ==> DQ is a 8*N 
%             array where colum i represents a dual quaternion rotation of
%             angle THETA and of axis AXIS(:,i).
%           - THETA is a scalar and AXIS is a 3-vector
%           - THETA is a N-vector and AXIS is a 3*N array ==> DQ is a 8*N
%           array where column i represents a dual quaternion rotation of
%           angle THETA(i) and of axis AXIS(:,i).
%
% See also DQUAT2ROT, TRANS2DQUAT, SCREW2DQUAT

stheta = size(theta);
saxis = size(axis);
if saxis == [1 3], axis = axis'; saxis = size(axis); end
if stheta(1) > 1, theta = theta'; stheta = size(theta); end

% wrong size
if stheta(1) ~= 1 || saxis(1) ~= 3
    error('DualQuaternion:rot2dquat:wrongsize',...
        '%d rows in array theta and %d rows in array axis. It should be 1 for theta and 3 for axis.',...
        stheta(1),saxis(1));
end

ntheta = stheta(2);
naxis = saxis(2);
if ntheta ~= naxis && ntheta > 1 && naxis > 1
    error('DualQuaternion:rot2dquat:wrongFormat',...
        '%d elements in array theta and %d axis in array axis. It should be the same number for both or one of these should be 1.',...
        ntheta,naxis);
end

% normalization of the axis vector (if necessary)
n2 = sum(axis.^2).^0.5;
if min(n2) == 0 % one of the rotation axis is [0 0 0]
    error('DualQuaternion:rot2dquat:notAnAxis',...
        'One of the rotation axis (column of axis) is [0 0 0]. This is not a rotation axis. Please correct.');
elseif (max(n2)~=1 || min(n2)~=1)
    n2 = repmat(n2,3,1);
    axis =axis./n2;
end

% construction of the rotation dual quaternion
n = max(naxis,ntheta);
dq = zeros(8,n);
if ntheta == naxis
    dq(1,:) = cosd(theta/2);
    sinrep = repmat(sind(theta/2),3,1);
    dq(2:4,:) = sinrep.*axis;
elseif naxis == 1
    dq(1,:) = cosd(theta/2);
    dq(2:4,:) = axis*sind(theta/2);
elseif ntheta == 1
    dq(1,:) = repmat(cosd(theta/2),1,naxis);
    dq(2:4,:) = axis*sind(theta/2);
end


