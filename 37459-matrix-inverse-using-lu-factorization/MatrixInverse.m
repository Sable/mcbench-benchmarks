function Ainv=MatrixInverse(A)
% A=rand(7,7); 
%
% Ainv1=inv(A);
% Ainv2=MatrixInverse(A);
%
% Ainv1-Ainv2
%

% Do Lu decompositon to obtain triangle matrices (can easily be inverted)
[L,U,P] = Lu(A);

% Solve linear system for Identity matrix
I=eye(size(A));
s=size(A,1);
Ainv=zeros(size(A));
for i=1:s
    b=I(:,i);
    Ainv(:,i)=TriangleBackwardSub(U,TriangleForwardSub(L,P*b));
end
