function [x,Iteration,Error] = bandSOR(A,x0,b,omega,epsilon)
% Goal: This code solves the linear system Ax=b, where A is a symmetric banded
%      matrix, using banded SOR. A is first stored in compact storage mode
%      and next SOR is applied to the compact storage.
% Input: This code accepts a symmetric banded matrix A, initial guess x0, 
%       vector b, SOR parameter omega and tolerance epsilon.
% Output: This code outputs the SOR-computed solution x, number of iteration
%        called Iteration and error called Error, which is the Euclidean
%        distance between kth iterate and k+1 iterate just when Error <
%        epsilon.
% Author: Michael Akinwumi
%  (c) 2011
Error=1;
Iteration=0;
x=x0;
x=x(:);b=b(:);
B=compactstorage(A);
dim=size(B);
while Error>epsilon
    Iteration=Iteration+1;
    temp = x;
     for i=1:length(x)
        before = 0;
        for j=1:(i-1)
            if dim(2)>=i+1-j 
                before = before + B(j,i+1-j)*x(j);
            end;
        end;
        after = 0;
        for j=(i+1):length(x)
            if dim(2)>=j+1-i 
                after = after + B(i,j+1-i)*x(j);
            end;
        end
        x(i) = (omega/B(i,1))*(b(i)- before - after) + (1-omega)*x(i);
    end;
Error = norm(x-temp);
end;
function B = compactstorage(A)
% This function stores symmetric banded matrix A in a 
% compact form bA in such a way that only the main diagonal,
% and the nonzero superdiagonals are stored. The first column 
% of bA corresponds to the main diagonal of A and the subsequent 
% columns of bA correspond to superdiagonals of A.
% Input:upper or lower bandwidth p and a symmetric matrix A
% Output: bA, compressed form of A
dim=size(A);
if ~(dim(1)==dim(2))
    error('A must be square')
end
if (all((all(A)~=all(A'))))
    error('A must be symmetric')
end
if ~(all(eig(A))> 0)
    error('Matrix is at least not positive definite')
end
c=find(A(1,1:dim(1))~=0);
B=zeros(dim(1),c(end));
n=dim(1);p=c(end)-1;
for i=1:n
if i<=n-p
for j=i:p+i
B(i,j-i+1)=A(i,j);
end
else 
for j=i:n
B(i,j-i+1)=A(i,j);
end
end
end

