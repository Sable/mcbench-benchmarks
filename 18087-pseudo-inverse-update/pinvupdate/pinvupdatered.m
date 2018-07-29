function M=pinvupdatered(A,B,c)

%PINVUPDATERED   Update the pseudo-inverse of a matrix by reducing one column.
%
% Assume you have a very large m x n matrix, B, you have known its 
% pseudo-inverse. Now, for some reason, you reduce B with one coulmn, 
% C = B(:,[1:r-1 r+1:end]) and wish to know the pseudo-inverse of C. This 
% function calculate the inverse of C using block matrix inverse formular, 
% hence much faster than directly using pinv(C).
%
%Usage:     
%   M=pinvupdatered(A,B) produces the pseudo-inverse of the submatrix of B obtained by
%   eliminating the last column of B. Input argument, A = pinv(B);
%
%   M=invupdatered(A,B,k) produces the pseudo-inverse of the submatrix of B obtained
%   by eliminating the k-th column of B. Input argument, A = pinv(B);
%
%Example 1: tall matrix
% N = 500;
% M = 1000;
% B = randn(M,N);
% A = pinv(B);
% tic, M = pinvupdatered(A,B); toc     % 0.052239 seconds
% C = B(:,1:end-1);
% tic, M1 = pinv(C); toc             % 1.414762 seconds
% norm(M-M1)                         % 5.8974e-12
% k=ceil(rand*N);
% tic, Mk = pinvupdatered(A,B,k); toc  % 0.057361 seconds
% Ck = B(:,[1:k-1 k+1:N]);
% tic, Mk1 = pinv(Ck); toc           % 1.394408 seconds
% norm(Mk-Mk1)                       % 9.0083e-12
%
%Example 2: fat matrix
% M = 500;
% N = 1000;
% B = randn(M,N);
% A = pinv(B);
% tic, M = pinvupdatered(A,B); toc   % 0.688520 seconds
% C = B(:,1:end-1);
% tic, M1 = pinv(C); toc             % 4.475970 seconds
% norm(M-M1)                         % 1.2889e-15
% k=ceil(rand*N);
% tic, Mk = pinvupdatered(A,B,k); toc  % 0.736935 seconds
% Ck = B(:,[1:k-1 k+1:N]);
% tic, Mk1 = pinv(Ck); toc           % 4.439608 seconds
% norm(Mk-Mk1)                       % 1.2889e-15
%
%Example 3: square rank-deficient matrix
% N = 1000;
% M = 500;
% B = randn(N,M)*randn(M,N);
% A = pinv(B);
% tic, M = pinvupdatered(A,B); toc   % 1.306564 seconds
% C = B(:,1:end-1);
% tic, M1 = pinv(C); toc             % 13.920764 seconds
% norm(M-M1)                         % 8.9197e-17
% k=ceil(rand*N);
% tic, Mk = pinvupdatered(A,B,k); toc  % 1.314358 seconds
% Ck = B(:,[1:k-1 k+1:N]);
% tic, Mk1 = pinv(Ck); toc           % 13.920764 seconds
% norm(Mk-Mk1)                       % 8.9197e-17
%
% By Yi Cao, 21-12-2007, at Cranfield University
%
% Reference: Cline, R.E., “Representations for the generalized inverse of a 
% partitioned matrix,” Journal of the SIAM, vol. 12, no. 3, pp. 588–600, 1964.
%

% Input checks.
error(nargchk(2,3,nargin))
[n,m] = size(A);
% if n<=m
%     error('A should be tall.');
% end
if ~isequal(size(B),[m,n])
    error('Input matrices, A and B mismatch.');
end
if nargin<3
    c=n;
end
    
g1=A(c,:);
g=B(:,c);
alpha=g1*g;
if alpha<1-1e-9
    M=A([1:c-1 c+1:n],:)*(eye(m)+g/(1-alpha)*g1);
else
    M=A([1:c-1 c+1:n],:)*(eye(m)-g1'/(g1*g1')*g1);
end
