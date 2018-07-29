function dn = dudiv(dn0,dn1)

% DDIV dual number division
%
%   DN = DDIV(DN0,DN1) returns the dual number DN which is the dual number
%     division DN0/DN1 of the dual numbers DN0 and DN1
%      - DN0 (resp. DN1) is a dual number (DN0 = a0 + eps*b0, eps^2 = 0).
%         It is a 2-vector or a 2*N array (column i represents dual number
%         i) where N is the number of dual numbers. DN0 and DN1 must have
%         the same size. The non-dual part of DN1 must be different from 0.
%      - DN is a dual number. It is a 2*N array (each column is the dual
%          multiplication of the corresponding columns in DN0 and DN1)

s0 = size(dn0);
s1 = size(dn1);
if s0 == [1 2]
    dn0 = dn0.';
    s0 = size(dn0);
end
if s1 == [1 2]
    dn1 = dn1.';
    s1 = size(dn1);
end

% wrong format
if s0(1) ~= 2 || s1(1) ~= 2
    error('DualQuaternion:Ddiv:wrongsize',...
        '%d rows in the DN0 array and %d rows in the DN1 array. It should be 2 for both.',...
        s0(1),s1(1));
end

% sizes do not match
n1 = s0(2);
n2 = s1(2);
if n1 ~= n2
    error('DualQuaternion:Ddiv:notMatch',...
        '%d dual numbers in DN0 array and %d dual numbers in DN1 array.They should be equal.',...
        n1,n2);
end

dn = sym(zeros(2,n1));
dn(1,:) = dn0(1,:)./dn1(1,:);
dn(2,:) = dn0(2,:)./dn1(1,:)-dn0(1,:).*dn1(2,:)./(dn1(1,:).^2);