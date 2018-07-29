function M=pinvupdateapp(A,B,x)

%PINVUDEXP   Update the pseudo-inverse of a matrix by appending one column. 
%
% Assume you have a very large m x n matrix, B, you have known its pseudo-inverse. 
% Now, for some reason, you expand B with one coulmn, C = [B x] and wish to 
% know the pseudo-inverse of C. This function calculate the pseudo-inverse of
% C using block matrix pseudo-inverse formular, hence much faster than directly
% using pinv(C).
%
%Usage:     M=pinvupdateapp(A,B,x)     
%Input:     B: m x n matrix
%           A=pinv(B);
%           x column vector, m x 1 to append B 
%
%Output:    M = inv(C)
%
%Example 1: fat matrix
% N = 1000;
% M = 500;
% B = randn(M,N);
% A = pinv(B);
% x = randn(M,1);
% tic, M = pinvupdateapp(A,B,x); toc   % 0.410221 seconds
% C = [B x];
% tic, M1 = pinv(C); toc               % 4.613383 seconds
% norm(M-M1)                           % 1.6709-15
%
%Example 2: tall matrix
% M = 1000;
% N = 500;
% B = randn(M,N);
% A = pinv(B);
% x = randn(M,1);
% tic, M = pinvupdateapp(A,B,x); toc  % 0.688336 seconds
% C = [B x];
% tic, M1 = pinv(C); toc              % 4.613339 seconds
% norm(M-M1)                          % 1.6040-15
%
%Example 3: square rank-deficient matrix
% M = 1000;
% N = 500;
% B = randn(M,N)*randn(N,M);
% A = pinv(B);
% x = randn(M,1);
% tic, M = pinvupdateapp(A,B,x); toc  % 1.342931 seconds
% C = [B x];
% tic, M1 = pinv(C); toc              % 14.446551 seconds
% norm(M-M1)                          % 2.7644-15
%
% By Yi Cao, 21-12-2007, at Cranfield University
%
% Reference:
% Greville, T.N.E. (1960), "Some applications of 
% pseudoinverse of a matrix, SIAM Review, Vol. 2, pp. 15--22. 

% Input checks.
error(nargchk(3,3,nargin))
[n,m] = size(A);
if ~isequal(size(B),[m,n])
    error('Input matrix dimension mismatch.');
end
if ~isequal(size(x),[m 1])
    error('x should be an m x 1column vector.');
end

Ax = A*x;
P=eye(m)-B*A;
Px = P*x;
alpha=x'*Px;
if alpha<1e-9
    eta = Ax'*Ax;
    b = A'*(Ax/(1+eta));
else
    b = Px/alpha;
end
M = [A - Ax*b'; b'];
