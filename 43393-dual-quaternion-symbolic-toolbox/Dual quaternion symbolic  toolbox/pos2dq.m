function dq = pos2dq(v)

% POS2DQ     Transforms a point position expressed in vector notation into 
%            its dual quaternion representation.
%
%       DQ = POS2DQ(V) transforms the point position, a vector V into a 
%       dual quaternion DQ.  V is either a vector of size 3 (one single 
%       position) or an array of size 3*N (each column represents one
%       point coordinates) where N is the number of points. DQ is either a
%       vector of size 8, either an array of size (8*N) depending on V
%       format. Each column of DQ represents the dual quaternion
%       representation 1+\epsilon x of the corresponding point position x.
%
% See also VEL2DQ, LINE2DQ, LINEVEL2DQ, POS2DQ

sv = size(v);
if sv == [1 3]
    v = v.'; 
    sv = size(v);
end

if sv(1) ~= 3 
    error('DualQuaternion:pos2dquat:wrongsize',...
        '%d rows in the V array. It should be 3. ',sv(1));
end
n = size(v,2);
dq = sym(zeros(8,n));
dq(1,:) = ones(1,n);
dq(6:8,:) = v;
