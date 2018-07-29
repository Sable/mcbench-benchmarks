function [Q,varargout]=ortha(A,X)
%ORTHA Orthonormalization Relative to matrix A
%  Q=ortha(A,X)
%  Q=ortha('Afunc',X)
%  Computes an orthonormal basis Q for the range of X, relative to the 
%  scalar product using a positive definite and selfadjoint matrix A.
%  That is, Q'*A*Q = I, the columns of Q span the same space as
%  columns of X, and rank(Q)=rank(X).
%
%  [Q,AQ]=ortha(A,X) also gives AQ = A*Q.
%
%  Required input arguments:
%  A : either an m x m positive definite and selfadjoint matrix A
%  or a linear operator A=A(v) that is positive definite selfadjoint;
%  X : m x n matrix containing vectors to be orthonormalized relative 
%  to A.
%
%  ortha(eye(m),X) spans the same space as orth(X)
%
%  Examples:
%  [q,Aq]=ortha(hilb(20),eye(20,5))
%  computes 5 column-vectors q spanned by the first 5 coordinate vectors,
%  and orthonormal with respect to the scalar product given by the
%  20x20 Hilbert matrix,
%  while an attempt to orthogonalize (in the same scalar product)
%  all 20 coordinate vectors using
%  [q,Aq]=ortha(hilb(20),eye(20))
%  gives 14 column-vectors out of 20. 
%  Note that rank(hilb(20)) = 13 in double precision. 
%
%  Algorithm:
%  X=orth(X), [U,S,V]=SVD(X'*A*X), then Q=X*U*S^(-1/2)
%  If A is ill conditioned an extra step is performed to
%  improve the result. This extra step is performed only
%  if a test indicates that the program is running on a
%  machine that supports higher precison arithmetic
%  (greater than 64 bit precision).
%
%  See also ORTH, SVD
%
%  Copyright (c) 2000 
%  Andrew Knyazev, Rico Argentati
%  License: BSD (free software)  
%  Contact email: knyazev@na-net.ornl.gov
%  $Revision: 1.5.8 $  $Date: 2001/8/28
%  Tested under MATLAB R10-12.1

% Check input parameter A
[m,n] = size(X);
if ~isstr(A)
  [mA,mA] = size(A);
  if any(size(A) ~= mA)
    error('Matrix A must be a square matrix or a string.')
  end
  if size(A) ~= m
    error(['The size ' int2str(size(A)) ...
           ' of the matrix A does not match with ' int2str(m) ...
           ' - the number of rows of X'])
  end
end

% Normalize, so ORTH below would not delete wanted vectors
for i=1:size(X,2),
  normXi=norm(X(:,i),inf);
  %Adjustment makes tol consistent with experimental results
  if normXi > eps^.981
    X(:,i)=X(:,i)/normXi;
    % Else orth will take care of this
  end
end

% Make sure X is full rank and orthonormalize 
X=orth(X); %This can also be done using QR.m, in which case
           %the column scaling above is not needed 

%Set tolerance           
[m,n]=size(X);
tol=max(m,n)*eps;

% Compute an A-orthonormal basis
if ~isstr(A)
  AX = A*X;
else
  AX = feval(A,X);
end
XAX = X'*AX;

XAX = 0.5.*(XAX' + XAX);
[U,S,V]=svd(XAX);

if n>1 s=diag(S);
  elseif n==1, s=S(1);
  else s=0;
end

%Adjustment makes tol consistent with experimental results  
threshold1=max(m,n)*max(s)*eps^1.1;

r=sum(s>threshold1);
s(r+1:size(s,1))=1;
S=diag(1./sqrt(s),0);
X=X*U*S;
AX=AX*U*S;
XAX = X'*AX;

% Check error against tolerance 
error=normest(XAX(1:r,1:r)-eye(r));
% Check internal precision, e.g., 80bit FPU registers of P3/P4
precision_test=[1 eps/1024 -1]*[1 1 1]'; 
if error<tol | precision_test==0;
  Q=X(:,1:r);
  varargout(1)={AX(:,1:r)};
  return
end

% Complete another iteration to improve accuracy
% if this machine supports higher internal precision 
if ~isstr(A)
  AX = A*X;
else
  AX = feval(A,X);
end
XAX = X'*AX;

XAX = 0.5.*(XAX' + XAX);
[U,S,V]=svd(XAX);

if n>1 s=diag(S);
  elseif n==1, s=S(1);
  else s=0;
end
   
threshold2=max(m,n)*max(s)*eps;
r=sum(s>threshold2);
S=diag(1./sqrt(s(1:r)),0);
Q=X*U(:,1:r)*S(1:r,1:r);
varargout(1)={AX*U(:,1:r)*S(1:r,1:r)};
