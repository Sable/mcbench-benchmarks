function M=invupdatered(A,r,c)

%INVUPDATERED   Update the inverse of a matrix reducing one column and one row.
%
% Assume you have a very large matrix, B, you have known its inverse. Now,
% for some reason, you reduce B with one coulmn and one row,
% C = B(1:end-1,1:end-1)
% and wish to know the inverse of C. This function calculate the inverse of
% C using block matrix inverse formular, hence much faster than directly
% using inv(C).
%
%Usage:     
%   M=invupdatered(A) produces the inverse of C = B(1:end-1,1:end-1) with given
%   A = inv(B).
%
%   M=invupdatered(A,k) produces the inverse of C = B([1:k-1 k+1:end],[1:k-1 k+1:end]) 
%   with given A = inv(B).
%
%   M=invupdatered(A,r,c) produces the inverse of 
%   C = B([1:r-1 r+1:end],[1:c-1 c+1:end]) with given A = inv(B);
%
%Example:
% N = 1000;
% B = randn(N);
% A = inv(B);
% tic, M = invupdatered(A); toc     % 0.052239 seconds
% C = B(1:end-1,1:end-1);
% tic, M1 = inv(C); toc             % 1.414762 seconds
% norm(M-M1)                        % 5.8974e-12
% k=ceil(rand*N);
% tic, Mk = invupdatered(A,k); toc  % 0.057361 seconds
% Ck = B([1:k-1 k+1:N],[1:k-1 k+1:N]);
% tic, Mk1 = inv(Ck); toc           % 1.394408 seconds
% norm(Mk-Mk1)                      % 9.0083e-12
% r=ceil(rand*N);
% c=ceil(rand*N);
% tic, Mrc = invupdatered(A,r,c); toc   % 0.058112 seconds
% Crc = B([1:r-1 r+1:N],[1:c-1 c+1:N]);
% tic, Mrc1 = inv(Crc); toc             % 1.391317 seconds
% norm(Mrc-Mrc1)                        % 5.8026e-12
%
% By Yi Cao, 20-12-2007, at Cranfield University
%

% Input checks.
error(nargchk(1,3,nargin))
[n,m] = size(A);
if n~=m
    error('A should be square.');
end
switch nargin
    case 1
        r=n;
        c=n;
    case 2
        c=r;
end
if ~isscalar(r) || ~isscalar(c)
    error('Usage: M = invupdatered(A); where r and c are scarlar indices.');
end
    
q = A(c,r);             % A is inverse, hence swap column and row
c1 = [1:c-1 c+1:n];     % coulmn indices to keep
r1 = [1:r-1 r+1:n];     % row indices to keep
Ax=A(c1,r);             % the rth column vector in A
yA=A(c,r1);             % the cth row vector in A
M=A(c1,r1)-Ax/q*yA;     % updated inverse
