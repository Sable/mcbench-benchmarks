function dq = rotvel2dq(omega,axis)

% ROTVEL2DQ  constructs a rotational velocity dual quaternion 
%
%     DQ = ROTVEL2DQ(OMEGA,AXIS) returns the dual quaternion DQ which is
%     the dual quaternion representation of the rotational velocity of axis 
%     AXIS and of angular speed OMEGA [deg/s]. 
%       -   OMEGA represents the angular speed [deg/s]. It is a scalar or a
%               N-vector (the i-th element represents the angular speed of 
%               the i-th rotational velocity) where N is the number of
%               rotational velocities.
%       -   AXIS represents the rotational velocity axis. It is a 3-vector 
%               or a 3*N array (column i represents the rotation axis of 
%               the i-th rotational velocity).
%       -   DQ is a 8*N array representing the rotational velocity dual 
%              quaternion [rad/s] 
%               DQ = [0 axis'*omega 0 0 0 0]
%
% See also ROT2DQ, TRANSVEL2DQ

somega = size(omega);
saxis = size(axis);
if saxis == [1 3], axis = axis.'; saxis = size(axis); end
if somega(1) > 1, omega = omega.'; somega = size(omega); end

% wrong size
if somega(1) ~= 1 || saxis(1) ~= 3
    error('DualQuaternion:rotvel2dquat:wrongsize',...
        '%d rows in array omega and %d rows in array axis. It should be 1 for omega and 3 for axis.',...
        somega(1),saxis(1));
end

nomega = somega(2);
naxis = saxis(2);
if nomega ~= naxis
    error('DualQuaternion:rotvel2dquat:wrongFormat',...
        '%d elements in array omega and %d axis in array axis. It should be the same number for both.',...
        nomega,naxis);
end

% normalization of the axis vector (if necessary)
n = naxis; 
n2 = sum(axis.^2).^0.5;

indnot0 = find(n2~=0);
axis(:,indnot0) = axis(:,indnot0)./repmat(n2(:,indnot0),3,1);

% construction of the rotation dual quaternion
dq = sym(zeros(8,n));
omegatab = repmat(omega,3,1)*pi/180;
dq(2:4,:) = omegatab.*axis;



