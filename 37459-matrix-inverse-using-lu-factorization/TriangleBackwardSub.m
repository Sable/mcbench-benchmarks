function C=TriangleBackwardSub(U,b)
% Triangle Matrix Backward Substitution
%
% Solves C = U \ B;
%
%          |1|         |2 2 1|
% With b = |2| and U = |0 1 4|
%          |3|         |0 0 3|
%
s=length(b);
C=zeros(s,1);
C(s)=b(s)/U(s,s);
for j=(s-1):-1:1
    C(j)=(b(j) -sum(U(j,j+1:end)'.*C(j+1:end)))/U(j,j);
end

