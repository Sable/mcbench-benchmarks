function v = dquat2vel(dq)

% DQUAT2VEL  Transforms a double quaternion point velocity representation
%            into a vector representation.
%
%     V = DQUAT2VEL(DQ) transforms the double quaternion representation of
%        a point velocity (in the euclidean space) into a vector v, which 
%        represents the point velocity coordinates.
%        DQ is either a vector of size 8 or an array of size 8*N (each 
%        column represents a point velocity dual quaternion) where N is the
%        number of points. V is a vector of size 3 or an array of size 3*N 
%        depending on the input format.
%
% See also VEL2DQUAT, DQUAT2POS, DQUAT2LINE, DQUAT2LINEVEL

sdq = size(dq);
if sdq == [1 8], dq = dq'; sdq = size(dq); end

% wrong format
if sdq(1) ~= 8 
    error('DualQuaternion:dquat2vel:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end

% check point velocity dual quaternion
tol = 1e-6;
[maxval,imax] = max(max(abs(dq(1:5,:))));
if maxval > tol 
   warning('DualQuaternion:dquat2vel:wrongFormat',...
        'At least one dual quaternion is not a point velocity dual quaternion (tol = %.1e).\n Indices of max values: %d',...
        tol,imax);
end

% extraction of the point velocity coordinates
v = dq(6:8,:);
