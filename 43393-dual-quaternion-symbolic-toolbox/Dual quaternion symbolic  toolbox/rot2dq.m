function dq = rot2dq(theta,axis)

% ROT2DQ   constructs a rotation dual quaternion (theta in [deg]!)
%
%     DQ = ROT2DQ(THETA,AXIS) returns the dual quaternion DQ which is the
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
%           - N:1:THETA is a N-vector and AXIS is a 3-vector ==> DQ is a 8*N 
%             array where colum i represents a dual quaternion rotation of
%             angle THETA(i) and of axis AXIS.
%           - 1:N:AXIS is a 3*N array and THETA is a scalar ==> DQ is a 8*N 
%             array where colum i represents a dual quaternion rotation of
%             angle THETA and of axis AXIS(:,i).
%           - 1:1:THETA is a scalar and AXIS is a 3-vector
%           - N:N:THETA is a N-vector and AXIS is a 3*N array ==> DQ is a 8*N
%           array where column i represents a dual quaternion rotation of
%           angle THETA(i) and of axis AXIS(:,i).
%
% See also DQ2ROT, TRANS2DQ, SCREW2DQ

stheta = size(theta);
saxis = size(axis);

if saxis == [1 3]
    axis = axis.'; 
    saxis = size(axis); 
end
if stheta(1) > 1
    theta = theta.'; 
    stheta = size(theta); 
end

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
axis =axis./n2;

% construction of the rotation dual quaternion
n = max(naxis,ntheta);
dq = sym(zeros(8,n));
if ntheta == naxis
    dq(1,:) = (cos(theta/2));
    sinrep = sym(repmat(sin(theta/2),3,1));
    dq(2:4,:) = sinrep.*axis;
elseif naxis == 1
    dq(1,:) = sym(cos(theta/2));
    dq(2:4,:) = sym(axis*sin(theta/2));
elseif ntheta == 1
    dq(1,:) = sym(repmat(cos(theta/2),1,naxis));
    dq(2:4,:) = sym(axis*sin(theta/2));
end


