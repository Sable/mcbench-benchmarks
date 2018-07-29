function v = dq2vel(dq)

% DQ2VEL     Transforms a dual quaternion point velocity representation
%            into a vector representation.
%
%        V = DQ2VEL(DQ) transforms the dual quaternion representation of
%        a point velocity (in the euclidean space) into a vector v, which 
%        represents the point velocity coordinates.
%        DQ is either a vector of size 8 or an array of size 8*N (each 
%        column represents a point velocity dual quaternion) where N is the
%        number of points. V is a vector of size 3 or an array of size 3*N 
%        depending on the input format.
%
% See also VEL2DQ, DQ2POS, DQ2LINE, DQ2LINEVEL

sdq = size(dq);
if sdq == [1 8]
    dq = dq.'; 
    sdq = size(dq); 
end

% wrong format
if sdq(1) ~= 8 
    error('DualQuaternion:dquat2vel:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end

% extraction of the point velocity coordinates
v = dq(6:8,:);
