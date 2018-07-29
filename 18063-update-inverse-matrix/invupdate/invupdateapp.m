function M=invupdateapp(A,x,y,r)

%INVUDEXP   Update the inverse of a matrix appending one column and one row.
%
% Assume you have a very large matrix, B, you have known its inverse. Now,
% for some reason, you expand B with one coulmn and one row, C = [B x;y r]
% and wish to know the inverse of C. This function calculate the inverse of
% C using block matrix inverse formular, hence much faster than directly
% using inv(C).
%
%Usage:     M=invupdateapp(A,x,y,r)     
%Input:     A = inv(B), n x n matrix (non-singular)
%           x column vector, n x 1
%           y row vector,    1 x n
%           r scalar
%Output:    M = inv(C)
%
%Example:
% N = 1000;
% B = randn(N);
% A = inv(B);
% x = randn(N,1);
% y = randn(1,N);
% r = randn;
% tic, M = invupdateapp(A,x,y,r); toc  % 0.070196 seconds
% C = [B x;y r];
% tic, M1 = inv(C); toc                % 1.408355 seconds
% norm(M-M1)                           % 9.2611-12
%
% By Yi Cao, 20-12-2007, at Cranfield University
%

% Input checks.
error(nargchk(4,4,nargin))
[n,m] = size(A);
if n~=m
    error('A should be square.');
end
if ~isequal(size(x),[n 1])
    error('x should be an n x 1column vector.');
end
if ~isequal(size(y),[1,n])
    error('y should be a 1 x n row vector.');
end
if ~isscalar(r)
    error('r should be a scalar.');
end

yA=y*A;                     %the product for repeated use
q = 1/(r-yA*x);             %the (2,2)th block
Ax=A*x*q;                   %the (1,2)th block 
M=[A+Ax*yA -Ax; -yA*q q];   %updated inverse
