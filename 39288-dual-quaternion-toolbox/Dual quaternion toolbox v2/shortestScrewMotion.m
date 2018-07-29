function varargout = shortestScrewMotion(L1,L2,varargin)

% SHORTESTSCREWMOTION  returns the smallest screw motion from line L1 to
%                      line L2
%
%    [THETA,D,AXIS,AXISPOINT] = SHORTESTSCREWMOTION(L1,L2) returns the 
%      parameters of the shortest (the smallest THETA and D among all 
%      possible solutions) screw motion from dual quaternion line L1
%      to dual quaternion line L2.
%      - L1 (resp. L2) is a line position dual quaternion. It is a 8-vector
%          or a 8*N array (column i represents line position dual 
%          quaternion i) where N is the number of lines in array L1 (resp. 
%          L2). See also LINE2DQUAT.
%      - THETA is the rotation angle [deg] around the screw motion axis
%           AXIS. It is a 1*N array.
%      - D is the distance along the screw motion axis AXIS. It is a 1*N
%           array.
%      - AXIS is the unitary screw motion axis. It is a 3*N array.
%      - AXISPOINT is the point of the screw motion axis line which is at
%           mid-distance between lines L1 and L2. If L1 and L2 intersect,
%           AXISPOINT is the intersection point of the two lines.
%
%    [THETA,D,AXIS,AXISPOINT] = SHORTESTSCREWMOTION(L1,L2,OPTION) returns
%        the same parameters but the point of the screw motion axis can be
%        specified by OPTION. If OPTION is:
%         - 'orthogonal': AXISPOINT is the point of the screw motion axis
%                line which is orthogonal to the screw motion axis AXIS (It
%                is the point of the screw motion axis line the closest
%                from the origin).
%         - 'intersection' (default): AXISPOINT is the point of the screw 
%                motion axis line which is at mid-distance between lines L1
%                and L2. If L1 and L2 intersect, AXISPOINT is the 
%                intersection point of the two lines.
%
%    DQ = SHORTESTSCREWMOTION(L1,L2) returns the screw motion dual
%        quaternion which represents the smallest screw motion between
%        lines L1 and L2.
%         - DQ is a screw motion dual quaternion. It is a 8*N array. 
%
% See also DQUAT2SCREW, SHORTESTROTATION, SCREW2DQUAT, LINE2DQUAT

sL1 = size(L1);
sL2 = size(L2);
if sL1 == [1 3], L1 = L1'; sL1 = size(L1); end
if sL2 == [1 3], L2 = L2'; sL2 = size(L2); end

% wrong size
if sL1(1) ~= 8 || sL2(1) ~= 8
    error('DualQuaternion:shortestScrewMotion:wrongsize',...
        '%d rows in array L1 and %d rows in array L2. It should be 8 for both.',...
        sL1(1),sL2(1));
end

np1 = sL1(2);
np2 = sL2(2);
if np1 ~= np2
    error('DualQuaternion:shortestScrewMotion:wrongFormat',...
        '%d lines in array L1 and %d lines in array L2. It should be the same number for both.',...
        np1,np2);
end

dqt = DQmult(DQconj(L1,'line'),L2);

% Extraction of the screw motion parameters
% theta
costheta = dqt(1,:);
theta = acosd(costheta); % acosd: [-1,1] --> [0,180]
sintheta = sind(theta);
indthetaOK = find(sintheta ~= 0);
ind0 = find(sintheta == 0);

% d
d = zeros(1,np1);
if ~isempty(indthetaOK)
    d(indthetaOK) = -dqt(5,indthetaOK)./sintheta(indthetaOK);
end
d(ind0) = sqrt(sum(dqt(6:8,ind0).^2));
inddOK = find(d>0);

% axis
axis = [ones(1,np1) ; zeros(2,np1)];
repsin = repmat(sintheta(indthetaOK),3,1);
if ~isempty(indthetaOK)
    axis(:,indthetaOK) = dqt(2:4,indthetaOK)./repsin;
end
ind2 = intersect(inddOK,ind0);
axis(:,ind2) = dqt(6:8,ind2)./repmat(d(ind2).*costheta(ind2),3,1);

% axispoint
soptargin = size(varargin,2); % number of optional input arguments
choice_ascrew = 'intersection';
if soptargin == 1
    choice_ascrew = varargin{1,1}; % 'orthogonal','intersection'
    bool = strcmp(choice_ascrew,{'orthogonal','intersection'});
    if max(bool) == 0
        error('DualQuaternion:shortestScrewMotion:wrongOptionName',...
            'The specified option is not correctly encoded. It must be ''orthogonal'' or ''intersection''. ');
    end
elseif soptargin > 1
    error('DualQuaternion:shortestScrewMotion:tooManyInputs',...
            'Too many inputs');
end

axispoint = zeros(3,np1);
m_axis = zeros(3,np1);
repcos = repmat(costheta(indthetaOK),3,1);
repd = repmat(d(indthetaOK),3,1);
if ~isempty(indthetaOK)
    m_axis(:,indthetaOK) = (dqt(6:8,indthetaOK)-repd.*repcos.*axis(:,indthetaOK))./repsin;
    axispoint(:,indthetaOK) = cross(axis(:,indthetaOK),m_axis(:,indthetaOK)); % gives the point orthogonal to the point orientation
    if strcmp(choice_ascrew,'intersection')
        [n1,r1] = dquat2line(L1(:,indthetaOK));
        [n2,r2] = dquat2line(L2(:,indthetaOK));
        paral = dot((r1+r2)/2,axis(:,indthetaOK));
        axispoint(:,indthetaOK) = axispoint(:,indthetaOK)+repmat(paral,3,1).*axis(:,indthetaOK);
    end
end

soptargout = nargout;
if soptargout == 1 % dq screw motion
    if soptargin > 0
        warning('DualQuaternion:shortestScrewMotion:wrongNumberInputs',...
            'If the desired output is a screw motion dual quaternion, there is no need to mention an option');
    end
    varargout{1,1} = screw2dquat(theta,d,axis,axispoint);
elseif soptargout == 4
     varargout{1,1} = theta;
     varargout{1,2} = d;
     varargout{1,3} = axis;
     varargout{1,4} = axispoint;
else
    error('DualQuaternion:shortestScrewMotion:wrongNumberOutputs',...
        'There should be 1 or 4 outputs and not %d',soptargout);
end





