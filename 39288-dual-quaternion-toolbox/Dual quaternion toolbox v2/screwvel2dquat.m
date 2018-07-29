function dq = screwvel2dquat(omega,omega_axis,speed,apdot,varargin)

% SCREWVEL2DQUAT constructs a screw motion velocity dual quaternion 
%
% DQVELSCREW = SCREWVEL2DQUAT(OMEGA,OMEGA_AXIS,SPEED,APDOT,DQSCREW) 
%     returns the dual quaternion DQ which is the dual quaternion 
%     representation of a screw motion velocity with an angular speed OMEGA
%     [deg/s] around an axis OMEGA_AXIS, with a translation speed SPEED 
%     along the line L (which is the screw motion axis line of the screw 
%     motion dual quaternion DQSCREW) orientation, and with an offset 
%     velocity APDOT of the line L.  DQVELSCREW is the derivative of
%     DQSCREW.
%       -  OMEGA represents the angular speed [deg/s]. It is a scalar or a
%               N-vector (the i-th element represents the angular speed of 
%               the i-th screw motion velocity) where N is the number of
%               screw motion velocities.
%       -  OMEGA_AXIS represents the instantaneous rotational velocity axis.
%               It is a a 3-vector or a 3*N array (column i represents the
%               rotational velocity axis i).
%       -  SPEED represents the translational speed. It is a scalar or a
%               N-vector (the i-th element represents the translational
%               speed of the i-th screw motion velocity).
%       -  APDOT represents the offset velocity (orthogonally to the line
%               L). It is a 3 vector or a 3*N array (column i represents
%               the offset velocity of the i-th screw motion axis line).
%       -   DQSCREW is a screw motion dual quaternion. It is a 8-vector or
%               an 8*N array (column i represents screw motion dual 
%               quaternion i). 
%       -   DQVELSCREW is a 8*N array representing the screw motion velocity 
%               dual quaternion.
%
%  DQVELSCREW = SCREWVEL2DQUAT(OMEGA,OMEGA_AXIS,SPEED,APDOT,THETA,D,DQLINE)
%     returns the dual quaternion DQ which is the dual quaternion 
%     representation of a screw motion velocity with an angular speed OMEGA
%     [deg/s] around an axis OMEGA_AXIS, with a translation speed SPEED 
%     along the line DQLINE (which is the screw motion axis line of the 
%     screw motion dual quaternion generated with THETA, D and DQLINE)
%     orientation, and with an offset velocity APDOT of the line DQLINE. 
%     DQVELSCREW is the derivative of DQSCREW = SCREW2DQUAT(THETA,D,DQLINE) 
%     where THETA [deg] represents the rotation angle around the line 
%     DQLINE of the screw motion and D represents the distance along the 
%     screw motion axis line DQLINE.
%       -   THETA represents the rotation angle [deg] around the screw axis
%               line DQLINE. It is a scalar or a N-vector (the i-th element 
%               represents the angle of the i-th screw motion).
%       -   D represents the translation distance along the screw axis line
%               DQLINE. It is a scalar or a N-vector (the i-th element represents 
%               the distance D of the i-th screw motion).
%
%  DQVELSCREW = SCREWVEL2DQUAT(OMEGA,OMEGA_AXIS,SPEED,APDOT,THETA,D,AXIS,AXISPOINT)
%      returns the same dual quaternion as above but the screw motion axis
%      line is expressed in terms of its parameters: its orientation, AXIS,
%      and one of its points, AXISPOINT. DQLINE =
%      LINE2DQUAT(AXIS,AXISPOINT).
%       -   AXIS represents the screw motion axis. It is a 3-vector or a 
%               3*N array (column i represents the rotation axis of the 
%               i-th screw motion).
%       -   AXISPOINT represents one point of the screw motion axis line.
%               It can be any point on the line. It is a 3-vector or a 
%               3*N array (column i represents the point coordinates of a 
%               point of the i-th screw motion axis line).
%
% See also SCREW2DQUAT, TRANSVEL2DQUAT, ROTVEL2DQUAT, LINE2DQUAT

somega = size(omega);
somegaaxis = size(omega_axis);
sspeed = size(speed);
sapdot = size(apdot);
if somega(1) > 1, omega = omega'; somega = size(omega); end
if sspeed(1) > 1, speed = speed'; sspeed = size(speed); end
if sapdot == [1 3], apdot = apdot'; sapdot = size(apdot); end
if somegaaxis == [1 3], omega_axis = omega_axis'; somegaaxis = size(omega_axis); end
nomega = somega(2);
nspeed = sspeed(2);
napdot = sapdot(2);
nomegaaxis = somegaaxis(2);

% wrong size
if somega(1) ~= 1 || sspeed(1) ~= 1 || sapdot(1) ~= 3 || somegaaxis(1) ~= 3
    error('DualQuaternion:screwvel2dquat:wrongsize',...
        '%d rows in array omega, %d rows in array omega_axis, %d rows in array speed and %d rows in array apdot. It should be respectively 1, 3, 1 and 3.',...
        somega(1),somegaaxis(1),sspeed(1),sapdot(1));
end
tabn = [nomega nspeed napdot nomegaaxis];
if max(tabn) ~= min(tabn)
    error('DualQuaternion:screwvel2dquat:wrongFormat',...
        '%d elements in array omega, %d vectors in array omega_axis, %d elements in array speed and %d vectors in array apdot. It should be the same number for all of them.',...
        nomega,nomegaaxis,nspeed,napdot);
end
n = nomega;

soptargin = size(varargin,2); % number of optional arguments
if soptargin == 0  || soptargin == 2 || soptargin > 4
    error('DualQuaternion:screwvel2dquat:WrongNumberInputs',...
        'There are %d inputs. There should be 4, 6 or 7 inputs.',...
        soptargin+3);
elseif soptargin == 1 % screw motion dual quaternion encoding
    DQscrewmotion = varargin{1,1};
    sdq = size(DQscrewmotion);
    if sdq == [1 8], DQscrewmotion = DQscrewmotion'; sdq = size(DQscrewmotion); end
    % wrong size
    if sdq(1) ~= 8      
        error('DualQuaternion:screwvel2dquat:wrongsize',...
            '%d rows in array DQSCREW. It should be 8.',sdq(1));
    end
    [theta,d,axis,axispoint] = dquat2screw(DQscrewmotion);  
elseif soptargin == 3 % screw motion line encoding
    theta = varargin{1,1};
    d = varargin{1,2};
    dqline = varargin{1,3};
    sdq = size(dqline);
    if sdq == [1 8], dqline = dqline'; sdq = size(dqline); end
    if sdq(1) ~= 8
        error('DualQuaternion:screwvel2dquat:wrongsize',...
            '%d rows in array DQLINE. It should be 8.',sdq(1));
    end
    [axis,axispoint] = dquat2line(dqline);
elseif soptargin == 4 % screw motion line parameters encoding
    theta = varargin{1,1};
    d = varargin{1,2};
    axis = varargin{1,3};
    axispoint = varargin{1,4};
end
stheta = size(theta);
sd = size(d);
saxis = size(axis);
saxispoint = size(axispoint);
if stheta(1)>1, theta = theta';stheta = size(theta);end
if sd(1)>1, d = d'; sd = size(d);end
if saxis == [1 3], axis = axis';saxis = size(axis);end
if saxispoint == [1 3], axispoint = axispoint';saxispoint = size(axispoint);end

% wrong size
if stheta(1) ~= 1 || sd(1) ~= 1 || saxis(1) ~= 3 || saxispoint(1) ~= 3
    error('DualQuaternion:screwvel2dquat:wrongsize2',...
        '%d rows in array theta, %d rows in array d, %d rows in array axis and %d rows in array axispoint. It should be respectively 1,1,3 and 3.',...
        stheta(1),sd(1),saxis(1),saxispoint(1));
end
tabn2 = [stheta(2) sd(2) saxis(2) saxispoint(2) n];
if max(tabn2) ~= min(tabn2)
    error('DualQuaternion:screwvel2dquat:wrongFormat',...
        '%d elements in array theta, %d elements in array d, %d vectors in array axis, %d vectors in array axispoint and %d elements for omega, speed and apdot. It should be the same number for all of them.',...
        stheta(2),sd(2),saxis(2),saxispoint(2),n);
end  

% Construction of the screw motion velocity dual quaternion
R = rot2dquat(theta,axis);
T_L = trans2dquat(axispoint);
T = trans2dquat(axis,d);
Omega = rotvel2dquat(omega,omega_axis);
n_apdot = sqrt(sum(apdot.^2));
apdot_axis = [ones(1,n); zeros(2,n)];
indnot0 = find(n_apdot > 0);
if ~isempty(indnot0)
    apdot_axis(:,indnot0) = apdot(:,indnot0)./repmat(n_apdot(indnot0),3,1);
end
T_L_dot = transvel2dquat(n_apdot,apdot_axis);
T_dot = transvel2dquat(speed,axis);

trans = DQmult(T_dot,R);
offset = DQmult(DQconj(T_L_dot,'line'),R)+DQmult(R,T_L_dot);
rota = 0.5*DQmult(T,DQconj(T_L,'line'),R,Omega,T_L);
dq = trans+offset+rota;

