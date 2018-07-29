function dq = transvel2dq(speed,axis)

% TRANSVEL2DQ  constructs a translational velocity dual quaternion 
%
%     DQ = TRANSVEL2DQ(SPEED,AXIS) returns the dual quaternion DQ which 
%     is the dual quaternion representation of the translational velocity 
%     of speed SPEED along the axis AXIS. 
%       -   SPEED represents the translational speed. It is a scalar or a
%               N-vector (the i-th element represents the translational
%               speed of the i-th translational velocity) where N is the
%               number of translational velocities.
%       -   AXIS represents the translational velocity axis. It is a 3-vector 
%               or a 3*N array (column i represents the rotation axis of 
%               the i-th rotation) where N is the number of translational .
%       -   DQ is a 8*N array representing the translational velocity dual 
%              quaternion [rad/s]. NB: DQ is not a unitary dual quaternion.
%               DQ = [0 0 0 0 0 axis'*speed]
%
% See also ROTVEL2DQ, TRANS2DQ

sspeed = size(speed);
saxis = size(axis);
if saxis == [1 3], axis = axis.'; saxis = size(axis); end
if sspeed(1) > 1, speed = speed.'; sspeed = size(sspeed); end

% wrong size
if sspeed(1) ~= 1 || saxis(1) ~= 3
    error('DualQuaternion:transvel2dquat:wrongsize',...
        '%d rows in array speed and %d rows in array axis. It should be 1 for speed and 3 for axis.',...
        sspeed(1),saxis(1));
end

nspeed = sspeed(2);
naxis = saxis(2);
if nspeed ~= naxis
    error('DualQuaternion:transvel2dquat:wrongFormat',...
        '%d elements in array speed and %d axis in array axis. It should be the same number for both.',...
        nspeed,naxis);
end

% normalization of the axis vector (if necessary)
n = naxis; 
n2 = sum(axis.^2).^0.5;

indnot0 = find(n2~=0);
axis(:,indnot0) = axis(:,indnot0)./repmat(n2(:,indnot0),3,1);

% construction of the rotation dual quaternion
dq = sym(zeros(8,n));
speedtab = repmat(speed,3,1);
dq(6:8,:) = speedtab/2.*axis;



