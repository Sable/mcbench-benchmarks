function dp = dqinv(dq)

% DQINV  dual quaternion inverse
%
%   DP = DQINV(DQ) returns the dual quaternion DP which is the dual 
%     quaternion inverse of a dual quaternion DQ
%     - DQ is a dual quaternion. It is a 8-vector or a 8*N array (column i
%        represents dual quaternion i) where N is the number of dual 
%        quaternions. The non-dual quaternion part of DQ must be different
%        from 0.
%     - DP is a dual quaternion. It is a 8*N array (column i
%        represents the dual quaternion inverse of dual quaternion i).
%
% See also DQNORM, DQCONJ, QINV

sdq = size(dq);
if sdq == [1 8]
    dq = dq.'; 
    sdq = size(dq); 
end

% wrong format
if sdq(1) ~= 8
    error('DualQuaternion:DQinv:wrongsize',...
        '%d rows in the DQ array. It should be 8.',sdq(1));
end
n = sdq(2);

ndq = dqnorm(dq);
ndq_2 = dnmult(ndq,ndq); 
cdq = dqconj(dq,'line');

dp = sym(zeros(8,n));
for ii=1:8
    if ii <= 4
        temp = [cdq(ii,:); zeros(1,n)];
        res = dndiv(temp,ndq_2);
        dp(ii,:) = dp(ii,:)+res(1,:);
        dp(ii+4,:) = dp(ii+4,:)+res(2,:);
    else
        temp = [zeros(1,n) ; cdq(ii,:)];
        res = dndiv(temp,ndq_2);
        dp(ii,:) = dp(ii,:)+res(2,:);
        dp(ii-4,:) = dp(ii-4,:)+res(1,:);
    end
end


