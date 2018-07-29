function Q = gorth(A, B, orderingflag)
%GORTH   Generalized orthogonalization.
%   Q = GORTH(A,B) Orthonormal basis with for the range of a set vectors
%   with respect to the scalar product defined by a positive-definite
%   matrix B
%
%INPUT
%   A: (m x n) matrix
%   B: (m x m) matrix, symmetric positive-definite
%OUTPUT
%   Q : (m x k), where k is the rank of A
%   span<Q> = span<A> the columns of Q span the same space as the
%   columns of A, and the number of columns of Q is the rank of A.
%   Q satisfies: Q'*B*Q = I, 
% 
% Q = gorth(..., orderingflag)
%   orderingflag can be 'descend' or 'ascend':
%   Ordering columns of Q according to eigenvalues of inv(B)*A, i.e.,
%   generalized singular values of A relative to B respectively in
%   descending or ascending order. Otherwise the default order is as
%   returned by GSVD (not documented).
%   
% Limitation: full matrix only (gsvd does not support sparse)
%
% Note: there is no checking for symmetric B; it is up for users to ensure
%       this requirement is meet.
%
% EXAMPLE:
%   m=4;
%   n=5;
%   k=2; % rank
% 
%   % Generate A: m x n
%   A=rand(m,k)+1i*rand(m,k);
%   A = [A A*rand(k,n-k)];
%   A=A(:,randperm(n));
% 
%   % Generate B: m x n
% 
%   L=rand(m,m)+1i*rand(m,m);
%   B=L'*L; % m x m
% 
%   % Engine
%   Q = gorth(A, B)
% 
%   % Check for range
%   rank(Q)
%   % Check for orthogonality
%   I = Q'*B*Q
%   norm(I-eye(size(I)))
%   % Check for span space: Projection(Q) on <A> = Q
%   Qp = A*pinv(A)*Q;
%   norm(Qp-Q)/norm(Q)
%
% Bruno Luong <brunoluong@yahoo.com>
% History
%   05-May-2009: original version
%   06-May-2009: correct bug when C is a column matrix
%   26-May-2009: ordering flag

[m,n] = size(A);
if ~isequal(size(B),[m m])
    error('GORTH: A must be (m x n) and B (m x m) arrays')
end

if isempty(A)
    Q = zeros(m,0);
    return
end

if nargin<3 || isempty(orderingflag)
    orderingflag = 'default';
end
    
% A = X*C'*U'
% B = X*S'*V'
% size are:
%   U (n x n)
%   V (m x m)
%   X (m x m)
%   C (n x m)
%   S (m x m)
[U,V,X,C,S] = gsvd(A',B',0);

d = max(m-n,0);
s = diag(S);
if isvector(C) % Attention: Matlab diag() on row/column matrix 
               % leads to unexpected result 
    c = C(1,1+d);
else
    c = diag(C,d);
end
sigma = c./s(1+d:m); % n in size
if m > 1
    s = sigma;
elseif m == 1
    s = sigma(1);
else
    s = 0;
end
tol = max(m,n) * max(s) * eps(class(A));
switch lower(orderingflag)
    case 'default'
        ikeep = find(s > tol);
    case {'descend' 'decreasing'}
        [ss isorted] = sort(s, 1, 'descend');
        icut = find(ss > tol, 1, 'last');
        ikeep = isorted(1:icut);
    case {'ascend' 'increasing'}
        [ss isorted] = sort(s, 1, 'ascend');
        icut = find(ss > tol, 1, 'first');
        ikeep = isorted(icut:end);
    otherwise
        error('GORTH: unknown orderingflag');
end
    
X = X(:,ikeep+d);
Y = X'*B*X;
Y = 0.5*(Y+Y'); % symmetrize to avoid numerical inaccuracy
R = chol(Y);
Q = X/R;

end % gorth
