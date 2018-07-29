function q = Qinv(p)

% QINV  quaternion inverse
%
%   Q = QINV(P) returns a quaternion Q which is the quaternion inverse of
%     quaternion P.
%     - P is a quaternion. It is a 4-vector or a 4*N array (column i
%        represents quaternion i) where N is the number of quaternions.
%     - Q is the quaternion inverse of quaternion P. It is a 4*N array.
%
% See also DQINV, QCONJ, DQCONJ, QNORM

sp = size(p);
if sp == [1 4], p = p'; sp = size(p); end

% wrong format
if sp(1) ~= 4
    error('DualQuaternion:Qinv:wrongsize',...
        '%d rows in the P array. It should be 4.',sp(1));
end

normp = Qnorm(p);
if min(normp) == 0
     error('DualQuaternion:Qinv:noInverse',...
        'One of the quaternions has 0 norm. Therefore it has no inverse');
end
q = Qconj(p)./repmat(normp.^2,4,1);
