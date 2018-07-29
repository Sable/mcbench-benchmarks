% ANTIDIAG - Antidiagonal of matrix.
% GMR 2005
% ANTIDIAG(A, R, C) returns the antidiagonal of matrix where
% the diagonal is specified by the upper-right corner.
%
% Example
% A = [1 2 3; 4 5 6; 7 8 9];
%
% antdiag(A, 1, 3) produces [3; 5; 7] 
%
% antdiag(A, 2, 3) produces [6; 8]


function adiag = antidiag(A, r, c)

adiag = [];

if r+c-1 > size(A,1)
    lim = size(A,1) - r;
else
    lim = c - 1;
end

for d = 0:1:lim
    adiag = [adiag; A(r+d, c-d)];
end