function [theta,d,axis,axispoint] = dq2screw(dq)

% DQ2SCREW    extracts the screw motion parameters of a screw motion dual 
%             quaternion
% 
%     [THETA,D,AXIS,AXISPOINT] = DQ2SCREW(DQ) returns the rotation 
%     angle, THETA [deg], around the screw motion unitary axis, AXIS, 
%     and the translation distance, D, along the screw motion axis.  
%     AXISPOINT specifies the coordinates of the point belonging to the 
%     screw motion axis line which is the nearest from the origin.
%       - DQ is a screw motion dual quaternion. It is a 8-vector or an 8*N
%       array (each column is a screw motion dual quaternion) where N is 
%       the number of screw motion dual quaternions. 
%       - THETA is the rotation angle [deg]. It is comprised between 0 and
%          180deg. THETA is a scalar or an 1*N array (element i is the 
%          rotation angle of dual quaternion i).
%       - D is the distance along the screw motion axis. It is a scalar or
%          1*N array (element i is the translation distance of dual
%          quaternion i).
%       - AXIS is the unitary (norm equal to 1) screw motion axis. It is a
%           3-vector or an 3*N array (column i is the screw motion axis of
%           dual quaternion i).
%       - AXISPOINT is the point belonging to the screw motion axis which
%           is the closest from the origin (AXISPOINT is orthogonal to
%           AXIS). It is a 3-vector or an 3*N array (column i is the screw 
%           motion axispoint of dual quaternion i).
%
% See also DQ2TRANS, SCREW2DQ, DQ2ROT

sdq = size(dq);
if sdq == [1 8]
    dq = dq.'; 
    sdq = size(dq); 
end
n = sdq(2);

% wrong format
if sdq(1) ~= 8 
    error('DualQuaternion:dquat2screw:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end

% Extraction of the screw motion parameters

% theta
theta = 2*acos(dq(1,:)); % acosd: [-1,1] --> [0,180]
indthetaOK = find(theta ~= 0);
ind0 = find(theta == 0);

% d
if ~isempty(indthetaOK)
    d(indthetaOK) = -2*dq(5,indthetaOK)./sin(theta(indthetaOK)/2);
end
d(ind0) = 2*sqrt(sum(dq(6:8,ind0).^2));
inddOK = find(d~=0);
% axis
axis = sym([ones(1,n) ; zeros(2,n)]);
repsin = repmat(sin(theta(indthetaOK)/2),3,1);
if ~isempty(indthetaOK)
    axis(:,indthetaOK) = dq(2:4,indthetaOK)./repsin;
end
ind2 = intersect(inddOK,ind0);
axis(:,ind2) = 2*dq(6:8,ind2)./repmat(d(ind2),3,1);

% axispoint
axispoint = sym(zeros(3,n));
m_axis = sym(zeros(3,n));
repcos = repmat(cos(theta(indthetaOK)/2),3,1);
repd = repmat(d(indthetaOK),3,1);
if ~isempty(indthetaOK)
    m_axis(:,indthetaOK) = (dq(6:8,indthetaOK)-repd/2.*repcos.*axis(:,indthetaOK))./repsin;
    axispoint(:,indthetaOK) = cross(axis(:,indthetaOK),m_axis(:,indthetaOK));
end




