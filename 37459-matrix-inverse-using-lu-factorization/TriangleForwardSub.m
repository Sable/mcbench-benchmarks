function C=TriangleForwardSub(L,b)
% Triangle Matrix Forward Substitution
%
% Solves C = L \ b
%
%          |1|         |1 0 0|
% With b = |2| and L = |2 1 0|
%          |3|         |3 4 1|
%
s=length(b);
C=zeros(s,1);
C(1)=b(1)/L(1,1);
for j=2:s
    C(j)=(b(j) -sum(L(j,1:j-1)'.*C(1:j-1)))/L(j,j);
end
