function [v,r] = dq2line(dq)

% DQ2LINE    Transforms a line position dual quaternion into 
%            its vector representation (orientation + position).
%
%         [V,R] = DQ2LINE(DQ) transforms the dual quaternion
%         representation of a line position (in the euclidean space) into a
%         vector V which represents the line orientation (unitary vector) 
%         and a vector R which is the coordinates of the nearest point from
%         the origin belonging to the line (it could be another r, it is
%         NOT unique).
%         DQ is either a vector of size 8 or an array of size 8*N (each
%         column represents a line position dual quaternion) where N is the
%         number of lines. V and R have the same size. They are either a
%         vector of size 3 or an array of size 3*N depending on the input
%         format.
%
% See also DQ2POS, DQ2VEL, DQ2LINEVEL, LINE2DQ

sdq = size(dq);
if sdq == [1 8]
    dq = dq.'; 
    sdq = size(dq); 
end

% wrong format
if sdq(1) ~= 8 
    error('DualQuaternion:dquat2line:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end

v = dq(2:4,:);
w = dq(6:8,:);

normv2 = sum(v.^2);

% r is the position vector of the point belonging to the line such that
% this point is the nearest point from the origin (it is orthogonal to the
% line orientation)
normv2 = repmat(normv2,3,1);
r = cross(v,w)./normv2;