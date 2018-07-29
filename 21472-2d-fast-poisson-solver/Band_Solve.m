%
% Written by M. Harper Langston - 5/10/00
% harper@cims.nyu.edu
%
% For this sparse LU solver of Ax = b, A has band s.
% For example, the following matrix has band s = 1
%
%   x x 0 0 0 0
%   x x x 0 0 0
%   0 x x x 0 0
%   0 0 x x x 0
%   0 0 0 x x x
%   0 0 0 0 x x
%
%
function [x] = Band_Solve(A,b)
% Here, s is the band number
[m,n] = size(A);
if m~=n
   error('Matrix not sqaure') % Want square matrix for simplicity
end
% Find the band of A
for l = 1:n
   if A(m,l)~=0
      s = n-l;
      break;
   end
end
% Do the sparse LU decomposition for a matrix of band s
for j = 1:m
   if j >= m-s
      L(j:m,j) = A(j:m,j)./A(j,j);
		U(j,j:m) = A(j,j:m);
   	A(j:m,j:m) = A(j:m,j:m) - L(j:m,j)*U(j,j:m);
   else
   	L(j:j+s,j) = A(j:j+s,j)./A(j,j);
   	U(j,j:j+s) = A(j,j:j+s);
   	A(j:j+s,j:j+s) = A(j:j+s,j:j+s) - L(j:j+s,j)*U(j,j:j+s);
   end
end
L = sparse(L);
U = sparse(U);
% Call backsolve routine, which I wrote to pay heed to sparsity.
[y] = Back_Solve(L,b);
[x] = Back_Solve(U,y);
%
% Written by M. Harper Langston - 5/10/00
%  