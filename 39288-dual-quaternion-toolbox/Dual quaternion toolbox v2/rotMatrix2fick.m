function [vfick,vfick2] = rotMatrix2fick(rotMatrix)

% ROTMATRIX2VFICK  transforms a 3*3 rotation matrix into Fick coordinates
%
%     [VFICK,VFICK2] = ROTMATRIX2FICK(ROTMATRIX) returns the Fick 
%       coordinates VFICK and VFICK2 [deg] corresponding to the rotation 
%       matrix ROTMATRIX.
%        - ROTMATRIX is a 3*3 array or a 3*3*N tensor (in which case,
%            ROTMATRIX(:,:,ii) is a 3*3 matrix representing the rotation
%            matrix corresponding to rotation ii) where N is the number of 
%            rotations. ROTMATRIX can also be a 1*N cell and each cell 
%            component ROTMATRIX{1,ii} is the 3*3 rotation matrix of 
%            rotation ii. 
%            The following reference frame must be used for the rotation
%            matrix! The positive rotation around x corresponds to a
%            clockwise torsional rotation. The positive rotation around y
%            corresponds to a downward rotation. The positive rotation
%            about z corresponds to a leftward rotation.
%        - VFICK (resp. VFICK2) is a 3*N array (column i represents 
%           rotation i). VFICK(:,i) can be written as VFICK = [H V T] where
%           (from the subject's perspective):
%            - H is the horizontal fick angle (positive when to the left)
%            - V is the vertical fick angle (around the inter-aural axis).
%               It is positive when down and is comprise between -90 and
%               90deg.
%            - T is the torsional fick angle (around the line of signt). It
%               is positive when clockwise.
%         - VFICK2 is the second solution VFICK2 = [H2 V2 T2] and V2 is
%             comprised between 90 and 270deg.
%
% Useful reference: T. Haslwanter (1995), Mathematics of three-dimensional 
%    eye rotations, Vision research, 35(12), 1727-39 
%
% See also FICK2ROTMATRIX, DQUAT2ROTMATRIX, ROTMATRIX2DQUAT

if nargout < 2 || nargout > 2
    error('DualQuaternion:rotMatrix2fick:wrongNumberOfOutputs',...
        'You specified %d outputs. It should be 2 (see documentation).',nargout);
end

A = rotMatrix; % just to make it shorter
isrotMcell = iscell(A);

if isrotMcell == 1
    n = length(A);
    newA = zeros(3,3,n);
    for ii=1:n
        curM = A{1,ii};
        sM = size(curM);
        if sM(1) ~= 3 || sM(2) ~= 3
            error('DualQuaternion:rotMatrix2fick:wrongsize',...
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
        error('DualQuaternion:rotMatrix2fick:wrongsize',...
            'The input is not a rotation matrix');
    else
        if sM(1) ~= 3 || sM(2) ~= 3
            error('DualQuaternion:rotMatrix2fick:wrongsize',...
            'First two dimensions of the tensor are %d and %d. It should be 3 and 3.',...
            sM(1),sM(2));
        end
    end    
end
% construction of the Fick coordinates
r31 = A(3,1,:); % = -sin(f)
V1 = asind(-r31); % V between [-90 90] deg (it could be between [90 and 270]
V2 = 180-V1; % alternative solution

r11 = A(1,1,:);
r21 = A(2,1,:);
r32 = A(3,2,:);
r33 = A(3,3,:);
if min(abs(cosd(V1))) > 0
    H1 = 180/pi*atan2(r21,r11);
    T1 = 180/pi*atan2(r32,r33);
    H2 = 180/pi*atan2(-r21,-r11);
    T2 = 180/pi*atan2(-r32,-r33);
else
    error('DualQuaternion:rotMatrix2fick:singularity',...
        'At least one of the rotation matrices has a singularity: T and H can not be determined independently');
end
vfick = [H1;V1;T1];
vfick2 = [H2;V2;T2];






