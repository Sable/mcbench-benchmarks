function [Mu_t,Sig_t]=ProjectOU(x_0,t,Mu,Th,Sig)

N=length(x_0);

% location
Mu_t = Mu + expm(-Th*t)*(x_0-Mu);

% scatter
TsT=kron(Th,eye(N))+kron(eye(N),Th);

VecSig=reshape(Sig,N^2,1);
VecSig_t=inv(TsT)*(eye(N^2)-expm(-TsT*t))*VecSig;
Sig_t=reshape(VecSig_t,N,N);
