function [L,U,P] = Lu(A)
%  LU factorization.
%
%   
% [L,U,P] = Lu(A) returns unit lower triangular matrix L, upper
% triangular matrix U, and permutation matrix P so that P*A = L*U.
%
% example,
%   A=rand(9,9);
%
%   [L,U,P] = Lu(A);
%   sum(sum(abs(P*A- L*U)))
%   
%   [L,U,P] = lu(A);
%   sum(sum(abs(P*A- L*U)))
%
%
s=length(A);
U=A;
L=zeros(s,s);
PV=(0:s-1)';
for j=1:s,
    % Pivot Voting (Max value in this column first)
    [~,ind]=max(abs(U(j:s,j)));
    ind=ind+(j-1);
    t=PV(j); PV(j)=PV(ind); PV(ind)=t;
    t=L(j,1:j-1); L(j,1:j-1)=L(ind,1:j-1); L(ind,1:j-1)=t;
    t=U(j,j:end); U(j,j:end)=U(ind,j:end); U(ind,j:end)=t;

    % LU
    L(j,j)=1;
    for i=(1+j):size(U,1)
       c= U(i,j)/U(j,j);
       U(i,j:s)=U(i,j:s)-U(j,j:s)*c;
       L(i,j)=c;
    end
end
P=zeros(s,s);
P(PV(:)*s+(1:s)')=1;

