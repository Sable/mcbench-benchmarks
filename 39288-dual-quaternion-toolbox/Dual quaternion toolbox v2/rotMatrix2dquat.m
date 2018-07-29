function DQ = rotMatrix2dquat(rotMatrix)

% ROTMATRIX2DQUAT  transforms a 3*3 rotation matrix into its rotation dual
%                  quaternion representation
%
%     DQ = ROTMATRIX2DQUAT(ROTMATRIX) returns the rotation dual quaternion
%     corresponding to the rotation matrix ROTMATRIX.
%        - ROTMATRIX is a 3*3 array or a 3*3*N tensor (in which case,
%            ROTMATRIX(:,:,ii) is a 3*3 matrix representing the rotation
%            matrix corresponding to rotation ii. ROTMATRIX can also be a 
%            1*N cell and each cell component ROTMATRIX{1,ii} is the 3*3 
%            rotation matrix of rotation ii.
%        - DQ is a rotation dual quaternion. It is a 8*N array (column i
%            represents the rotation i) where N is the number of rotations.
%
% Useful reference: J. Funda, R. Taylor, R.Paul (1990), On homogeneous
% transforms, quaternions, and computational efficiency, IEEE transactions
% on robotics and automation, 6(3), 382-388
%
% See also FICK2ROTMATRIX, DQUAT2ROTMATRIX, ROTMATRIX2FICK

A = rotMatrix; % just to make it shorter
isrotMcell = iscell(A);
tol = 1e-5;
if isrotMcell == 1
    n = length(A);
    newA = zeros(3,3,n);
    for ii=1:n
        curM = A{1,ii};
        sM = size(curM);
        if sM(1) ~= 3 || sM(2) ~= 3
            error('DualQuaternion:rotMatrix2dquat:wrongsize',...
                'Matrix size of rotation %d is %d*%d. It should be 3 and 3.',...
                 ii,sM(1),sM(2));
        end
        newA(:,:,ii) = curM;
    end
    A = newA;
else
    sM = size(A);
    ntensor = length(sM);
    if ntensor < 2 || ntensor > 3
        error('DualQuaternion:rotMatrix2dquat:wrongsize',...
            'The input is not a rotation matrix');
    else
        if sM(1) ~= 3 || sM(2) ~= 3
            error('DualQuaternion:rotMatrix2dquat:wrongsize',...
            'First two dimensions of the tensor are %d and %d. It should be 3 and 3.',...
            sM(1),sM(2));
        end
        if ntensor == 3
            n = sM(3);
        else
            n = 1;
        end
    end    
end
% construction of the dual quaternion rotation
DQ = zeros(8,n);
cur = 1+A(1,1,:)+A(2,2,:)+A(3,3,:);
if min(cur) < 0 % which will lead to imaginary quaternions
    if min(cur) < -tol
        warning('DualQuaternion:rotMatrix2dquat:BadInput',...
            'At least one 3*3 matrix is not a rotation matrix');    
    else
        indneg = find(cur < 0);
        cur(indneg) = zeros(1,length(indneg));
    end
end
DQ(1,:) = sqrt(cur)/2; % cos(theta/2) component
DQ0 = DQ(1,:)';
DQ(2,:) = 0.25*squeeze(A(3,2,:)-A(2,3,:))./DQ0; % sin(theta/2)*n_x component
DQ(3,:) = 0.25*squeeze(A(1,3,:)-A(3,1,:))./DQ0; % sin(theta/2)*n_y component
DQ(4,:) = 0.25*squeeze(A(2,1,:)-A(1,2,:))./DQ0; % sin(theta/2)*n_z component





