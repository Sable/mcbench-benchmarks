function rotMatrix = dq2rotmat(dq,varargin)

% DQ2ROTMAT       transforms a rotation dual quaternion into a 3*3
%                 rotation matrix 
%
%       ROTMATRIX = DQ2ROTMAT(DQ) returns the 3*3 rotation matrix 
%       ROTMATRIX corresponding to the rotation dual quaternion DQ.
%        - DQ is a rotation dual quaternion. It is a 8-vector or an 8*N
%            array (column i represents the rotation dual quaternion i) 
%            where N is the number of rotations.
%        - ROTMATRIX is a 3*3 array or a 3*3*N tensor (in which case,
%            ROTMATRIX(:,:,ii) is a 3*3 matrix representing the rotation
%            matrix corresponding to rotation ii. 
%
%      ROTMATRIX = DQ2ROTMAT(DQ,OPTION) returns the rotation matrix
%        ROTMATRIX under the form specified by the OPTION string:
%           - 'tensor': ROTMATRIX is a 3*3*N tensor (the default)
%           - 'cell': ROTMATRIX is a 1*N cell and each cell component
%                  ROTMATRIX{1,ii} is the 3*3 rotation matrix of rotation
%                  ii
%
% See also ROTMAT2DQ
sdq = size(dq);
if sdq == [1 8]
    dq = dq.'; 
    sdq = size(dq); 
end
n = sdq(2);

% wrong format
if sdq(1) ~= 8 
    error('DualQuaternion:dquat2rotMatrix:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end

% number of inputs
choice = 0;
soptargin = size(varargin);
if soptargin(2) > 1
    error('DualQuaternion:fick2rotMatrix:toomanyInputs',...
        'Too Many Inputs');
elseif soptargin(2) == 1
    opt = varargin{1,1};
    if strcmp(opt,'cell') % option is 'cell'
        choice = 1;
    end
end

% rotation matrix components
r11 = 1-2.*(dq(3,:).^2+dq(4,:).^2);
r22 = 1-2.*(dq(2,:).^2+dq(4,:).^2);
r33 = 1-2.*(dq(2,:).^2+dq(3,:).^2);

r12 = 2*(dq(2,:).*dq(3,:)-dq(1,:).*dq(4,:));
r13 = 2*(dq(1,:).*dq(3,:)+dq(2,:).*dq(4,:));
r21 = 2*(dq(1,:).*dq(4,:)+dq(2,:).*dq(3,:));
r23 = 2*(dq(3,:).*dq(4,:)-dq(1,:).*dq(2,:));
r31 = 2*(dq(2,:).*dq(4,:)-dq(1,:).*dq(3,:));
r32 = 2*(dq(1,:).*dq(2,:)+dq(3,:).*dq(4,:));

if choice == 0 % tensor
    rotMatrix = sym(zeros(3,3,n));
    rotMatrix(1,1,:) = r11;
    rotMatrix(1,2,:) = r12;
    rotMatrix(1,3,:) = r13;
    rotMatrix(2,1,:) = r21;
    rotMatrix(2,2,:) = r22;
    rotMatrix(2,3,:) = r23;
    rotMatrix(3,1,:) = r31;
    rotMatrix(3,2,:) = r32;
    rotMatrix(3,3,:) = r33;
elseif choice == 1 % cell
        rotMatrix = cell(1,n);
    for ii=1:n
       rotMatrix{1,ii} = [r11(ii) r12(ii) r13(ii);...
                          r21(ii) r22(ii) r23(ii);...
                          r31(ii) r32(ii) r33(ii)]; 
    end
end
