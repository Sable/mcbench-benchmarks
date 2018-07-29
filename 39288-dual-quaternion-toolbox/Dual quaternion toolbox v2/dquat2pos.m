function v = dquat2pos(dq)

% DQUAT2POS  Transforms a double quaternion point position representation 
%            into a vector representation.
%
%     V = DQUAT2POS(DQ) transforms the double quaternion representation of
%        a point position (in the euclidean space) into a vector v, which
%        represents the point coordinates. DQ is either a vector of size 8 
%        or an array of size 8*N (each column represents a point position 
%        dual quaternion) where N is the number of point locations. V is a
%        vector of size 3 or an array of size 3*N depending on the input 
%        format.
%
% See also POS2DQUAT, DQUAT2VEL, DQUAT2LINE, DQUAT2LINEVEL

sdq = size(dq);
if sdq == [1 8], dq = dq'; sdq = size(dq); end

% wrong format
if sdq(1) ~= 8 
    error('DualQuaternion:dquat2pos:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end

% check point position dual quaternion
tol = 1e-6;
[maxval1,imax1] = max(abs(dq(1,:)-1));
[maxval2,imax2] = max(max(abs(dq(2:5,:))));
imax = union(imax1,imax2);
if maxval1 > tol || maxval2 > tol 
    warning('DualQuaternion:dquat2pos:wrongFormat',...
        'At least one dual quaternion is not a point position dual quaternion (tol = %.1e).\n Indices of max values: %d',...
        tol,imax);
end

% extraction of the point position coordinates
v = dq(6:8,:);
