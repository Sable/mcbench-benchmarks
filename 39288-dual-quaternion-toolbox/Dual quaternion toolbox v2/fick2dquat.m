function dquat = fick2dquat(vfick)

% FICK2DQUAT  transforms Fick coordinates into a rotation dual quaternion
%
%     DQUAT = FICK2DQUAT(VFICK) returns the rotation dual quaternion DQUAT
%       corresponding to the Fick coordinates VFICK [deg].
%        - VFICK is a 3-vector or a 3*N array (column i represents 
%           rotation i) where N is the number of rotations. The 3-D
%           vector VFICK (or VFICK(:,i)) can be written as VFICK = [H V T]
%           where (from the subject's perspective):
%            - H is the horizontal fick angle (positive when to the left)
%            - V is the vertical fick angle (around the inter-aural axis).
%               It is positive when down.
%            - T is the torsional fick angle (around the line of signt). It
%               is positive when clockwise.
%        - DQ is a rotation dual quaternion. It is a 8*N array (column i
%            represents the rotation i). DQ = cos(theta/2)+n*sin(theta/2)
%            has the unitary n vecor expressed in the following reference
%            frame:
%            The positive rotation around x corresponds to a clockwise 
%            torsional rotation. The positive rotation around y corresponds 
%            to a downward rotation. The positive rotation about z 
%            corresponds to a leftward rotation.
%
% Useful reference: T. Haslwanter (1995), Mathematics of three-dimensional 
%    eye rotations, Vision research, 35(12), 1727-39 
%
% See also ROTMATRIX2DQUAT, FICK2ROTMATRIX, DQUAT2FICK

rotMatrix = fick2rotMatrix(vfick);
dquat = rotMatrix2dquat(rotMatrix);
    


