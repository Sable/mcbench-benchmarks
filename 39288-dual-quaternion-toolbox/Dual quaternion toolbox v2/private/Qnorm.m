function qn = Qnorm(q)

% QNORM  quaternion norm
%
%   QN = QNORM(Q) returns the norm QN of quaternion Q
%     - Q is a quaternion. It is a 4-vector or a 4*N array (column i
%        represents quaternion i) where N is the number of quaternions.
%     - QN is the quaternion norm of Q. It is a 1*N array.
%
% See also DQNORM, QCONJ, QINV

sq = size(q);
if sq == [1 4], q = q'; sq = size(q); end

% wrong format
if sq(1) ~= 4
    error('DualQuaternion:Qnorm:wrongsize',...
        '%d rows in the Q array. It should be 4.',sq(1));
end

qn = sum(q.^2).^0.5;
