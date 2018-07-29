function s = Qmult(q,r)

%  QMULT Multiplies 2 quaternions
%
%    S = QMULT(Q,R) returns the quaternion product of Q and R. Q (resp. R,
%      S)is a vector of size 4 represeting a quaternion or an array of size
%      4*N (column i represents quaternion i) where N is the number of
%      quaternions. There are several combinations possible:
%       - Q is a 4-vector and R is an array 4*N ==> S is an array 4*N. Q is
%       multiplied with each column (quaternion) of R.
%       - Q is an array 4*N and R is a 4-vector ==> S is an array 4*N. Each
%       column (quaternion) of Q is multiplied with R.
%       - Q and R are both arrays of size 4*N  ==> S is an array 4*N. The
%       quaternion muliplication is carried out on corresponding columns.
%      THE ORDER MATTERS: the quaternion muliplication is NOT commutative.
%      QMULT(Q,R) is different from QMULT(R,Q)
%
% See also DQMULT, QCONJ

sq = size(q);
sr = size(r);
if sq == [1 4], q = q'; sq = size(q); end
if sr == [1 4], r = r'; sr = size(r); end

% wrong size
if sq(1) ~= 4 || sr(1) ~= 4 
    error('DualQuaternion:Qmult:wrongsize',...
        '%d rows in array q and %d rows in array r. It should be 4 for both.',...
        sq(1),sq(2));
end

nq = sq(2);
nr = sr(2);

% wrong format for the inputs
if nq ~= nr && nq > 1 && nr > 1 
    error('DualQuaternion:Qmult:wrongFormat',...
        '%d columns in array q and %d columns in array r. It should be the same number for both, or one of these should be 1.',...
        nq,nr);
end

% Implementation of the quaternion multiplication
q0 = q(1,:);
qv = q(2:4,:);
r0 = r(1,:);
rv = r(2:4,:);
if nq == nr
    s0 = q0.*r0-dot(qv,rv);
    sv = repmat(r0,3,1).*qv+repmat(q0,3,1).*rv-cross(qv,rv);
elseif nq == 1
    s0 = q0*r0-qv'*rv; 
    sv = qv*r0+q0*rv-cross(repmat(qv,1,nr),rv); 
elseif nr == 1
    s0 = r0*q0-rv'*qv;
    sv = rv*q0+r0*qv-cross(qv,repmat(rv,1,nq));
end
s = [s0 ; sv];