function v = dq2pos(dq)

% DQ2POS     Transforms a dual quaternion point position representation 
%            into a vector representation.
%
%        V = DQ2POS(DQ) transforms the dual quaternion representation of
%        a point position (in the euclidean space) into a vector v, which
%        represents the point coordinates. DQ is either a vector of size 8 
%        or an array of size 8*N (each column represents a point position 
%        dual quaternion) where N is the number of point locations. V is a
%        vector of size 3 or an array of size 3*N depending on the input 
%        format.
%
% See also POS2DQ, DQ2VEL, DQ2LINE, DQ2LINEVEL

sdq = size(dq);
if sdq == [1 8]
    dq = dq.'; 
    sdq = size(dq); 
end

% wrong format
if sdq(1) ~= 8 
    error('DualQuaternion:dquat2pos:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end

% extraction of the point position coordinates
v = dq(6:8,:);
