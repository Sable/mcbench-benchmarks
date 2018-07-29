function [X_t,Mu_t,Sig_t]=OUstep(X_0,t,Mu,Th,Sig)

[NumSimul,N]=size(X_0);

% location
ExpM=expm(-Th*t);

Mu_t = repmat((Mu-ExpM*Mu)',NumSimul,1) +  X_0*ExpM';

% scatter
TsT=kron(Th,eye(N))+kron(eye(N),Th);

VecSig=reshape(Sig,N^2,1);
VecSig_t=inv(TsT)*(eye(N^2)-expm(-TsT*t))*VecSig;
Sig_t=reshape(VecSig_t,N,N);
Sig_t=(Sig_t+Sig_t')/2;

Eps=mvnrnd(zeros(N,1),Sig_t,NumSimul);

X_t=Mu_t+Eps;
Mu_t=mean(Mu_t,1)';

