function [B] = adj(A,mode)
%ADJ Matrix adjoint.
%
%   ADJ(A) is the adjoint matrix of matrix A.
%   A may be complex and any size, RxC
%
%   usage: B = adj(A)
%
%   If R <= C then the Right Adjoint is returned
%   If R >= C then the Left  Adjoint is returned
%
%   The inverse of A is: INV(A) = ADJ(A)/det(A).
%   Matrices that are not invertable still have an adjoint.
%
%   See also SVD, PINV, INV, RANK, SLASH, DETT

%Paul Godfrey, October, 2006

[r,c]=size(A);
[u,s,v]=svd(A);

k=det(u)*det(v');
if r==1 | c==1, s=s(1); end
s=diag(s);

if exist('mode','var')
    B=k*prod(s)*pinv(A);
else
    for n=1:length(s)
        p=s;
        p(n)=[];
        V(:,n)=k*prod(p)*v(:,n);
    end
    B=V*u(:,1:length(s))';
end

return




%Demos of this program are:
clc
a=rand(3,4)
aa=adj(a)
disp('Right adjoint')
a*aa

a=rand(4,3)
aa=adj(a)
disp('Left adjoint')
aa*a

a=rand(4,4)
aa=adj(a)
disp('Square adjoint')
a*aa
aa*a
det(a)
