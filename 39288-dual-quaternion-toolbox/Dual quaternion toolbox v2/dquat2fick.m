function [vfick,vfick2] = dquat2fick(dquat)

% DQUAT2FICK  transforms a rotation dual quaternion into Fick coordinates
%
%     [VFICK,VFICK2] = DQUAT2FICK(ROTMATRIX) returns the Fick coordinates 
%       VFICK and VFICK2 [deg] corresponding to the rotation dual
%       quaternion DQUAT.
%        - DQ is a rotation dual quaternion. It is a 8*N array (column i
%            represents the rotation i). DQ = cos(theta/2)+n*sin(theta/2)
%            has the unitary n vecor expressed in the following reference
%            frame:
%            The positive rotation around x corresponds to a clockwise 
%            torsional rotation. The positive rotation around y corresponds 
%            to a downward rotation. The positive rotation about z 
%            corresponds to a leftward rotation.
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
% See also DQUAT2ROTMATRIX, ROTMATRIX2FICK, FICK2DQUAT

rotMatrix = dquat2rotMatrix(dquat);
[vfick,vfick2] = rotMatrix2fick(rotMatrix);

    


