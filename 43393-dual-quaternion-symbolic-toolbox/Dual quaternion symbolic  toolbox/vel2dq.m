function dq = vel2dq(v)

% VEL2DQ     Transforms a point velocity expressed in vector notation into 
%            its dual quaternion representation.
%
%       DQ = VEL2DQ(V) transforms the point velocity, a vector V into a 
%       dual quaternion DQ.  V is either a vector of size 3 (one single 
%       velocity) or an array of size 3*N (each column represents one
%       velocity coordinates) where N is the number of points. 
%       DQ is either a vector of size 8, either an array of size (8*N) 
%       depending on V format. Each column of DQ represents the dual 
%       quaternion representation 0+\epsilon dotx of the corresponding 
%       point velocity dotx.
%
% See also POS2DQ, LINE2DQ, LINEVEL2DQ

sv = size(v);
if sv == [1 3]
    v = v.';
    sv = size(v);
end

if sv(1) ~= 3 
    error('DualQuaternion:vel2dquat:wrongsize',...
        '%d rows in the V array. It should be 3. ',sv(1));
end

n = size(v,2); 
dq = sym(zeros(8,n));
dq(6:8,:) = v;
