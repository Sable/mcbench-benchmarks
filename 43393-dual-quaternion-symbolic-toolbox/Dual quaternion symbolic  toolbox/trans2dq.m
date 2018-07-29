function dq = trans2dq(vec,d)

% TRANS2DQ   constructs a translation dual quaternion.
%
%    DQ = TRANS2DQ(VEC) returns the dual quaternion DQ which is the
%     dual quaternion representation of a translation of vector VEC. 
%       -   VEC represents the translation vector. It is a 3-vector or a 
%               3*N array (column i represents the translation vector of 
%               the i-th translation) where N is the number of translations.
%       -   DQ is a 8*N array representing the translation dual quaternion.
%
%    DQ = TRANS2DQ(AXIS,D) returns the dual quaternion DQ which is the
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
% See also DQ2TRANS, ROT2DQ, SCREW2DQ

svec = size(vec);
if svec == [1 3]
    vec = vec.'; 
    svec = size(vec); 
end

% wrong size
if svec(1) ~= 3
    error('DualQuaternion:trans2dquat:wrongsize',...
        '%d rows in array vec. It should be 3.',svec(1));
end

n = svec(2);
dq = sym(zeros(8,n));
dq(1,:) = ones(1,n);
if nargin < 2 % encoding of the translation vector only
    dq(6:8,:) = vec/2;
else
    sd = size(d);
    if sd(1)>1
        d=d.';
        sd = size(d);end
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
    vec =vec./n2;
   
    dq(6:8,:) = repmat(d/2,3,1).*vec;
end
        




