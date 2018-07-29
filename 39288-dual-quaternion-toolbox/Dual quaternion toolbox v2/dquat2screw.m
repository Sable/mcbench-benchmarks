function [theta,d,axis,axispoint] = dquat2screw(dq)

% DQUAT2SCREW extracts the screw motion parameters of a screw motion dual 
%             quaternion
% 
%  [THETA,D,AXIS,AXISPOINT] = DQUAT2SCREW(DQ) returns the rotation 
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
% See also DQUAT2TRANS, SCREW2DQUAT, DQUAT2ROT

if nargout < 4 || nargout > 4
    error('DualQuaternion:dquat2screw:wrongNumberOfOutputs',...
        'You specified %d outputs. It should be 4 (see documentation).',nargout);
end

sdq = size(dq);
if sdq == [1 8], dq = dq'; sdq = size(dq); end
n = sdq(2);

% wrong format
if sdq(1) ~= 8 
    error('DualQuaternion:dquat2screw:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end

% check that it is a screw motion dual quaternion (unitary dual quaternion)
tol = 1e-5;
Q0 = dq(1:4,:);
Q1 = dq(5:8,:);
Qcheck = Qmult(Qconj(Q0),Q1)+Qmult(Qconj(Q1),Q0);
check = Qcheck(1,:);
normQ0 = sqrt(sum(Q0.^2));
tabcheck = [abs(check) ; abs(normQ0-1)];
[maxval,imax] = max(max(tabcheck));
if maxval > tol
    warning('DualQuaternion:dquat2screw:wrongFormat',...
        'At least one dual quaternion is not a screw motion dual quaternion (tol = %.1e).\n Indices of max values: %d \n Max value = %.2e',...
        tol,imax,maxval);
end

indpos = find(dq(1,:) > 1);
dq(1,indpos) = ones(1,length(indpos));
indneg = find(dq(1,:) < -1);
dq(1,indneg) = ones(1,length(indneg));

% Extraction of the screw motion parameters
% theta
theta = 2*acosd(dq(1,:)); % acosd: [-1,1] --> [0,180]
theta = mod(theta,360);
indthetaOK = find(theta > 0);
ind0 = find(theta == 0);

% d
d = zeros(1,n);
if ~isempty(indthetaOK)
    d(indthetaOK) = -2*dq(5,indthetaOK)./sind(theta(indthetaOK)/2);
end
d(ind0) = 2*sqrt(sum(dq(6:8,ind0).^2));
inddOK = find(d>0);

% axis
axis = [ones(1,n) ; zeros(2,n)];
repsin = repmat(sind(theta(indthetaOK)/2),3,1);
if ~isempty(indthetaOK)
    axis(:,indthetaOK) = dq(2:4,indthetaOK)./repsin;
end
ind2 = intersect(inddOK,ind0);
axis(:,ind2) = 2*dq(6:8,ind2)./repmat(d(ind2),3,1);

% axispoint
axispoint = zeros(3,n);
m_axis = zeros(3,n);
repcos = repmat(cosd(theta(indthetaOK)/2),3,1);
repd = repmat(d(indthetaOK),3,1);
if ~isempty(indthetaOK)
    m_axis(:,indthetaOK) = (dq(6:8,indthetaOK)-repd/2.*repcos.*axis(:,indthetaOK))./repsin;
    axispoint(:,indthetaOK) = cross(axis(:,indthetaOK),m_axis(:,indthetaOK));
end




