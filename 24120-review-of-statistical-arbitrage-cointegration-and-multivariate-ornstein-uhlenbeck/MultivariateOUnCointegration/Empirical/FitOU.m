function [Mu,Th,Sig]=FitOU(Y,tau)

[T,N]=size(Y);

X=Y(2:end,:);
F=[ones(T-1,1) Y(1:end-1,:)];
E_XF=X'*F/T;
E_FF=F'*F/T;
B=E_XF*inv(E_FF);

Th=-logm(B(:,2:end))/tau;
Mu=inv(eye(N)-B(:,2:end))*B(:,1);

U=F*B'-X;
Sig_tau = cov(U);

N=length(Mu);
TsT=kron(Th,eye(N))+kron(eye(N),Th);

VecSig_tau=reshape(Sig_tau ,N^2,1);
VecSig = inv(eye(N^2)-expm(-TsT*tau))*TsT*VecSig_tau;
Sig=reshape(VecSig,N,N);



