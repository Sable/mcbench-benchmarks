function dq = trans2dquat(vec,d)

% TRANS2DQUAT   constructs a translation dual quaternion.
%
%    DQ = TRANS2DQUAT(VEC) returns the dual quaternion DQ which is the
%     dual quaternion representation of a translation of vector VEC. 
%       -   VEC represents the translation vector. It is a 3-vector or a 
%               3*N array (column i represents the translation vector of 
%               the i-th translation) where N is the number of translations.
%       -   DQ is a 8*N array representing the translation dual quaternion.
%
%    DQ = TRANS2DQUAT(AXIS,D) returns the dual quaternion DQ which is the
%     dual quaternion representation of a translation of distance D and of
%     axis AXIS. 
%       -   D represents the translation distance. It is a scalar or a
%               N-vector (the i-th element represents the distance of the 
%               i-th translation) where N is the number of translations. 
%       -   AXIS represents the translation axis. It is a 3-vector or a 3*N 
%               array (column i represents the translation axis of the i-th
%               translation) where N is the number of translations.
%       -   DQ is a 8*N array representing the translation dual quaternion. 
%
% See also DQUAT2TRANS, ROT2DQUAT, SCREW2DQUAT

svec = size(vec);
if svec == [1 3], vec = vec'; svec = size(vec); end

% wrong size
if svec(1) ~= 3
    error('DualQuaternion:trans2dquat:wrongsize',...
        '%d rows in array vec. It should be 3.',svec(1));
end
n = svec(2);
dq = zeros(8,n);
dq(1,:) = ones(1,n);
if nargin < 2 % encoding of the translation vector only
    dq(6:8,:) = vec/2;
else
    sd = size(d);
    if sd(1)>1,d=d';sd = size(d);end
    % wrong size
    if sd(1) ~= 1
        error('DualQuaternion:trans2dquat:wrongsize',...
            '%d rows in array d. It should be 1.',sd(1));
    end
    nd = sd(2);
    if nd ~= n
        error('DualQuaternion:trans2dquat:wrongFormat',...
            '%d elements in array d and %d axis in array vec. It should be the same number for both.',...
            nd,n);
    end 
    
    % normalization of the axis vector (if necessary)
    n2 = sum(vec.^2).^0.5;
    if min(n2) == 0 % one of the rotation axis is [0 0 0]
        error('DualQuaternion:trans2dquat:notAnAxis',...
            'One of the translation axis (column of vec) is [0 0 0]. This is not an axis. Please correct or use dq = trans2dquat(vec) instead of dq = trans2dquat(vec,d).');
    elseif (max(n2)~=1 || min(n2)~=1)
        n2 = repmat(n2,3,1);
        vec =vec./n2;
    end
    
    dq(6:8,:) = repmat(d/2,3,1).*vec;
end
        




