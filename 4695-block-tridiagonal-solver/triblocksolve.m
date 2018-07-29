function x=triblocksolve(A,b,N)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% triblocksolve.m
%
% Solves the block tridiagonal system Ax=b, where A is composed of N by N blocks 
%
% Reference: G. Engeln-Muellges, F. Uhlig, "Numerical Algorithms with C"
%               Chapter 4. Springer-Verlag Berlin (1996)
%
% Written by: Greg von Winckel       03/29/04
% Contact:    gregvw@chtm.unm.edu 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[rows,cols]=size(A);

% Determine if number of rows is a multiple of N
if ~mod(N,rows)
    error('A must have an integer number of N by N blocks');
end

% Get number of blocks
nblk=rows/N;

% Convert rhs to matrix
b=reshape(b,N,nblk);

% Store solution as matrix
x=zeros(N,nblk);
c=x;

% Diagonal blocks 
D=zeros(N,N,nblk);
Q=D; G=D;

% subdiagonal blocks
C=zeros(N,N,nblk-1);

% superdiagonal blocks
B=C;

% Convert A into arrays of blocks
for k=1:nblk-1
    block=(1:N)+(k-1)*N;
    D(:,:,k)=A(block,block);
    B(:,:,k)=A(block+N,block);
    C(:,:,k)=A(block,block+N);
end

block=(1:N)+(nblk-1)*N;
D(:,:,nblk)=A(block,block);

% Ok up to here

Q(:,:,1)=D(:,:,1);
G(:,:,1)=Q(:,:,1)\C(:,:,1);

for k=2:nblk-1
    Q(:,:,k)=D(:,:,k)-B(:,:,k-1)*G(:,:,k-1);
    G(:,:,k)=Q(:,:,k)\C(:,:,k);
end

Q(:,:,nblk)=D(:,:,nblk)-B(:,:,nblk-1)*G(:,:,nblk-1);

c(:,1)=Q(:,:,1)\b(:,1);

for k=2:nblk
    c(:,k)=Q(:,:,k)\( b(:,k)-B(:,:,k-1)*c(:,k-1) );
end

x(:,nblk)=c(:,nblk);

for k=(nblk-1):-1:1
    x(:,k)=c(:,k)-G(:,:,k)*x(:,k+1);
end

% Revert to vector form
x=x(:);

    
    

