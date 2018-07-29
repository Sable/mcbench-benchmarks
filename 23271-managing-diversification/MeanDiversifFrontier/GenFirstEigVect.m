function e = GenFirstEigVect(S,A)

N=size(S,1);

P=eye(N);

if rank(A)>0
    P=eye(N)-A'*inv(A*A')*A;
end

[E_,L_]=eig(P*S*P');

[m,I]=max(diag(L_));
e=E_(:,I);

