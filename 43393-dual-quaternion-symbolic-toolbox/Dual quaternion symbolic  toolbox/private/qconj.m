function q = qconj(p)

% QCONJ   Quaternion conjugate
%
%   Q = QCONJ(P)returns the quaternion conjugate 
%    q = CONJQ(p) returns the quaternion conjugate of the quaternion P. P
%    is a 4-vector representing a quaternion or an array 4*N (column i
%    represents quaternion i) where N is the number of quaternions. If P =
%    p0 + vecp, then P* = p0-vecp. Q has the same size as P.
%
% See also DQCONJ

sp = size(p);
if sp == [1 4]
    p = p.'; 
    sp = size(p); 
end

% wrong size
if sp(1) ~= 4 
    error('DualQuaternion:Qconj:wrongsize',...
        '%d rows in array p. It should be 4.',sp(1));
end

q = p;
q(2:4,:) = - q(2:4,:);