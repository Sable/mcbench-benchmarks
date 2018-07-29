function rotMatrix = fick2rotMatrix(vfick,varargin)

% FICK2ROTMATRIX  transforms Fick coordinates into a 3*3 rotation matrix
%
%     ROTMATRIX = FICK2ROTMATRIX(VFICK) returns the rotation matrix ROTMATRIX
%     corresponding to the Fick coordinates VFICK [deg].
%        - VFICK is a 3-vector or a 3*N array (column i represents 
%           rotation i) where N is the number of rotations. The 3-D
%           vector VFICK (or VFICK(:,i)) can be written as VFICK = [H V T]
%           where (from the subject's perspective):
%            - H is the horizontal fick angle (positive when to the left)
%            - V is the vertical fick angle (around the inter-aural axis).
%               It is positive when down.
%            - T is the torsional fick angle (around the line of signt). It
%               is positive when clockwise.
%        - ROTMATRIX is a 3*3 array or a 3*3*N tensor (in which case,
%            ROTMATRIX(:,:,ii) is a 3*3 matrix representing the rotation
%            matrix corresponding to rotation ii. 
%
%      ROTMATRIX = FICK2ROTMATRIX(VFICK,OPTION) returns the rotation matrix
%        ROTMATRIX under the form specified by the OPTION string:
%           - 'tensor': ROTMATRIX is a 3*3*N tensor (the default)
%           - 'cell': ROTMATRIX is a 1*N cell and each cell component
%                  ROTMATRIX{1,ii} is the 3*3 rotation matrix of rotation
%                  ii
%
% Useful reference: T. Haslwanter (1995), Mathematics of three-dimensional 
%    eye rotations, Vision research, 35(12), 1727-39 
%
% See also ROTMATRIX2DQUAT, DQUAT2ROTMATRIX, ROTMATRIX2FICK

sv = size(vfick);
if sv == [1 3], vfick = vfick'; sv = size(vfick); end

% wrong format
if sv(1) ~= 3 
    error('DualQuaternion:fick2rotMatrix:wrongsize',...
        '%d rows in the VFICK array. It should be 3.',sv(1));
end
vfick = vfick./180.*pi; % expressed in radians
n = sv(2);

% rotation matrix components (in Fick convention)
t = vfick(1,:); % Horizontal angle : + when to the left (see Haslwanter95)
f = vfick(2,:); % Vertical angle: + when down
p = vfick(3,:); % Torsional angle: + when clockwise

a11 = cos(t).*cos(f);
a22 = sin(t).*sin(f).*sin(p)+cos(t).*cos(p);
a33 = cos(f).*cos(p);
a23 = sin(t).*sin(f).*cos(p) - cos(t).*sin(p);
a32 = cos(f).*sin(p);
a31 = -sin(f);
a13 = cos(t).*sin(f).*cos(p) + sin(t).*sin(p);
a12 = cos(t).*sin(f).*sin(p)-sin(t).*cos(p);
a21 = sin(t).*cos(f);

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

if choice == 0 % tensor
    rotMatrix = zeros(3,3,n);
    rotMatrix(1,1,:) = a11;
    rotMatrix(1,2,:) = a12;
    rotMatrix(1,3,:) = a13;
    rotMatrix(2,1,:) = a21;
    rotMatrix(2,2,:) = a22;
    rotMatrix(2,3,:) = a23;
    rotMatrix(3,1,:) = a31;
    rotMatrix(3,2,:) = a32;
    rotMatrix(3,3,:) = a33;
elseif choice == 1 % cell
    rotMatrix = cell(1,n);
    for ii=1:n
       rotMatrix{1,ii} = [a11(ii) a12(ii) a13(ii);...
                          a21(ii) a22(ii) a23(ii);...
                          a31(ii) a32(ii) a33(ii)]; 
    end
end
    


