function dqn = dqnorm(dq)

% DQNORM  dual quaternion norm
%
%     DQN = DQNORM(DQ) returns the norm DQN of a dual quaternion DQ
%     - DQ is a dual quaternion. It is a 8-vector or a 8*N array (column i
%        represents dual quaternion i) where N is the number of dual 
%        quaternions.
%     - DQN is a dual number (DQN = a0 + epsilon*b0 where a and b are real 
%        numbers) representing the dual quaternion norm of DQ. It exists 
%        only if DQ(1:4) is different from 0.  It is a 2*N array:
%        For a column i, the first component is the non-dual part a0 and
%        the second component is the dual part, b0.
%
% See also QNORM, DQCONJ, DQINV

sdq = size(dq);
if sdq == [1 8]
    dq = dq.'; 
    sdq = size(dq); 
end

% wrong format
if sdq(1) ~= 8
    error('DualQuaternion:DQnorm:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end
n = sdq(2);

q0 = dq(1:4,:);
q1 = dq(5:8,:);
normq0 = qnorm(q0);

dqn = sym(zeros(2,n));
dqn(1,:) = normq0;

prod = qmult(q0,qconj(q1))+qmult(q1,qconj(q0));
dqn(2,:) = prod(1,:)./(2*normq0);  %dual number square root formula


