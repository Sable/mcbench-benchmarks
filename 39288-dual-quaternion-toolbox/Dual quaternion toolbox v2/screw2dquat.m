function dq = screw2dquat(theta,d,varargin)

% SCREW2DQUAT   constructs a screw motion dual quaternion (theta in [deg]!)
%
%    DQ = SCREW2DQUAT(THETA,D,AXIS,AXISPOINT) returns the dual quaternion 
%     DQ which is the dual quaternion representation of a screw motion of 
%     angle THETA and distance D around a line of axis AXIS and comprising 
%     the point AXISPOINT. 
%       -   THETA represents the rotation angle [deg] around the screw axis
%               AXIS. It is a scalar or a N-vector (the i-th element 
%               represents the angle of the i-th screw motion) where N is 
%               the number of screw motions.
%       -   D represents the translation distance along the screw axis AXIS.
%               It is a scalar or a N-vector (the i-th element represents 
%               the distance D of the i-th screw motion) where N is the
%               number of screw motions.
%       -   AXIS represents the screw motion axis. It is a 3-vector or a 
%               3*N array (column i represents the rotation axis of the 
%               i-th screw motion).
%       -   AXISPOINT represents one point of the screw motion axis line.
%               It can be any point on the line. It is a 3-vector or a 
%               3*N array (column i represents the point coordinates of a 
%               point of the i-th screw motion axis line).
%       -   DQ is a 8*N array representing the screw motion dual quaternion
%
%    DQ = SCREW2DQUAT(THETA,D,DQLINE) returns the dual quaternion 
%     DQ which is the dual quaternion representation of a screw motion of 
%     angle THETA and distance D around a line DQLINE. THETA,D and DQ are
%     similar as above. 
%       -   DQline is a line position dual quaternion. It is a 8-vector or
%           an 8*N array (column i represents line i). 
%
% See also DQUAT2SCREW, TRANS2DQUAT, ROT2DQUAT, LINE2DQUAT

stheta = size(theta);
sd = size(d);
if stheta(1) > 1, theta = theta'; stheta = size(theta); end
if sd(1) > 1, d = d'; sd = size(d); end
ntheta = stheta(2);
nd = sd(2);

% wrong size
if stheta(1) ~= 1 || sd(1) ~= 1
    error('DualQuaternion:screw2dquat:wrongsize',...
        '%d rows in array theta and %d rows in array d. It should be 1 for both.',...
        stheta(1),sd(1));
end
if ntheta ~= nd
    error('DualQuaternion:screw2dquat:wrongFormat',...
        '%d elements in array theta and %d elements in array d. It should be the same number for both.',...
        ntheta,nd);
end
n = ntheta;

soptargin = size(varargin,2); % number of optional arguments
if soptargin == 0
    error('DualQuaternion:screw2dquat:tooFewInputs',...
        'There are only 2 inputs. There should be 3 or 4 inputs.');
elseif soptargin > 2
        error('DualQuaternion:screw2dquat:tooManyInputs',...
        'Too many input arguments.');
elseif soptargin == 1 % line encoding
    DQline = varargin{1,1};
    sdq = size(DQline);
    if sdq == [1 8], DQline = DQline'; sdq = size(DQline); end
    % wrong size
    if sdq(1) ~= 8      
        error('DualQuaternion:screw2dquat:wrongsize',...
            '%d rows in array DQline. It should be 8.',sdq(1));
    end
    
    axis = DQline(2:4,:);
    mom = DQline(6:8,:);    
elseif soptargin == 2 % axis, axispoint encoding
    axis = varargin{1,1};
    axispoint = varargin{1,2};
    saxis = size(axis);
    saxispoint = size(axispoint);
    if saxis == [1 3], axis = axis'; saxis = size(axis); end
    if saxispoint == [1 3], axispoint = axispoint'; saxispoint = size(axispoint); end
    
    % wrong size
    if saxispoint(1) ~= 3 || saxis(1) ~= 3
        error('DualQuaternion:screw2dquat:wrongsize',...
            '%d rows in array axis and %d rows in array axispoint. It should be 3 for both.',...
            saxis(1),saxispoint(1));
    end
    naxispoint = saxispoint(2);
    naxis = saxis(2);
    if ntheta ~= naxis || ntheta ~= naxispoint
        error('DualQuaternion:screw2dquat:wrongFormat',...
            '-  %d elements in array theta \n -  %d axis in array axis \n -  %d axispoints in array axispoint \n It should be the same number.',...
            ntheta,naxis,naxispoint);
    end
    
    % normalization of the axis vector (if necessary)
    n2 = sum(axis.^2).^0.5;
    if min(n2) == 0 % one of the rotation axis is [0 0 0]
        error('DualQuaternion:screw2dquat:notAnAxis',...
            'One of the screw motion axis (column of axis) is [0 0 0]. This is not a screw motion axis. Please correct.');
    elseif (max(n2)~=1 || min(n2)~=1)
        n2 = repmat(n2,3,1);
        axis =axis./n2;
    end
    mom = cross(axispoint,axis);
end

% Construction of the screw motion dual quaternion
dq = zeros(8,n);
dq(1,:) = cosd(theta/2);
sinrep = repmat(sind(theta/2),3,1);
dq(2:4,:) = sinrep.*axis;
dq(5,:) = -d/2.*sind(theta/2);
dq(6:8,:) = repmat(d/2.*cosd(theta/2),3,1).*axis+mom.*sinrep; % ok si typecross = '+'

