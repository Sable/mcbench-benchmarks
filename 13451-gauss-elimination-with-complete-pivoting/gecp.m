function [L, U, P, Q] = gecp(A)
%GECP calculate Gauss elimination with complete pivoting
%
% (G)aussian (E)limination (C)omplete (P)ivoting
% Input : A nxn matrix
% Output
% L = Lower triangular matrix with ones as diagonals 
% U = Upper triangular matrix
% P and Q permutations matrices so that P*A*Q = L*U 
% 
% See also LU
%
% written by : Cheilakos Nick 
[n, n] = size(A);
p = 1:n; 
q = 1:n;
for k = 1:n-1
    [maxc, rowindices] = max( abs(A(k:n, k:n)) );
    [maxm, colindex] = max(maxc);
    row = rowindices(colindex)+k-1; col = colindex+k-1;
    A( [k, row], : ) = A( [row, k], : );
    A( :, [k, col] ) = A( :, [col, k] );
    p( [k, row] ) = p( [row, k] ); q( [k, col] ) = q( [col, k] );
    if A(k,k) == 0
      break
    end
    A(k+1:n,k) = A(k+1:n,k)/A(k,k);
    i = k+1:n;
    A(i,i) = A(i,i) - A(i,k) * A(k,i);
end
L = tril(A,-1) + eye(n);
U = triu(A);
   P = eye(n);
   P = P(p,:);
   Q = eye(n);
   Q = Q(:,q);