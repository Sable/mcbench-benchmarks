function dq = DQconj(dv,WHICHCONJ)

% DQCONJ   Dual quaternion conjugate
%
%    DQ = DQCONJ(DV) returns the dual quaternion conjugate of the dual
%      quaternion DV. DV (resp. DQ) is a 8-vector representing a dual 
%      quaternion or an array 8*N (column i represents dual quaternion i)
%      where N is the number of dual quaternions. The default type of 
%      conjugate is 'point' (see below). DQ has the same size as DV.
%
%    DQ = DQCONJ(DV,WHICHCONJ) returns the type of dual quaternion conjugate
%       corresponding to WHICHCONJ (DV = Q0+eps*Q1):
%         - 'point': mixed conjugate: dV* = Q0*-eps*Q1* (used for point
%         transformations).
%         - 'line': quaternion conjugate: dV* = Q0*+eps*Q1* (used for line
%         transformations).
%         - 'other': dual number conjugate: dV* = Q0-eps*Q1
%
% See also QCONJ, DQMULT

if nargin < 2
    WHICHCONJ = 'point'; % default is 'mixed' conjugate' (point transformation)
end


sdv = size(dv);
if sdv == [1 8], dv = dv'; sdv = size(dv); end

% wrong size
if sdv(1) ~= 8 
    error('DualQuaternion:DQconj:wrongsize',...
        '%d rows in array dv. It should be 8.',sdv(1));
end

n = sdv(2);
dq = zeros(8,n);
switch WHICHCONJ
    case 'point' % % case of point transformation
        dq(1:4,:) = Qconj(dv(1:4,:));
        dq(5:8,:) = -Qconj(dv(5:8,:));
    case 'line' % case of line transformation
        dq(1:4,:) = Qconj(dv(1:4,:));
        dq(5:8,:) = Qconj(dv(5:8,:));
    case 'other' % dual number conjugate
        dq(1:4,:) = dv(1:4,:);
        dq(5:8,:) = -dv(5:8,:);
    otherwise
        error('DualQuaternion:DQconj:wrongsize',...
            'WHICHCONJ must be ''point'', ''line'' or ''other'' ');
end
