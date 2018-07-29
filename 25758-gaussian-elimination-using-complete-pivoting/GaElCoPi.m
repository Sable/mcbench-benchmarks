function [P L U Q]=GaElCoPi(A)

%Gaussian Elimination with Complete Pivoting
%version 1.0

%P*A*Q=L*U
%Alvaro Moraes
%KAUST 2009

%Example of usage:
%A=randn(40);
%[P L U Q]=GaElCoPi(A);
%norm(P*A*Q-L*U)

% or this (it takes some time)
% choose the size of A and 
% the number of simulations
% for k=1:1000
%  k
%  A=randn(128);
%  [P L U Q]=GaElCoPi(A);
%  N1(k) =norm(P*A*Q-L*U);
%  %compute the growth factor
%  %rho(k)=max(max(abs(U)))/max(max(abs(A)))
% end
% plot(N1)
% max(abs(N1)) %must be small xxe-014

%and also check the worst scenario for the Partial Pivoting:
% m=128; %(matrix 22.4 from Trefethen and Baum)
% A=-1*tril(ones(m))+2*eye(m);
% A(:,m)=ones(m,1);
%[P L U Q]=GaElCoPi(A);
%norm(P*A*Q-L*U)

[n n]=size(A); 
L=zeros(n); 
%v and w record the permutations
%of the rows and cols respect.
v=1:n; w=1:n;

for k=1:n-1
     %in the next three lines 
     %we obtain  the max of abs(A(v(k:n),w(k:n)))
     %and its coordinates (imr,imc)
     [m,mc]=max(abs(A(v(k:n),w(k:n)))); 
     [m,c]=max(m);
     imc=c; imr=mc(c);
     %next we transform this coordinates to the
     %coordinates of A
     imr=imr+k-1;
     imc=imc+k-1;
     %now, we perform the permutations
     v([k imr])=v([imr k]);
     w([k imc])=w([imc k]);
     %next, the gaussian elimination step
    for i=k+1:n 
        L(v(i),w(k))=A(v(i),w(k))/A(v(k),w(k));
        A(v(i),:)=A(v(i),:)-L(v(i),w(k))*A(v(k),:);
    end  
end
%by last, we use v and w to define P, Q, L and U
P=eye(n);P=P(v,:); 
Q=eye(n);Q=Q(:,w); 
L=L(v,w)+ eye(n);
U=A(v,w); 
