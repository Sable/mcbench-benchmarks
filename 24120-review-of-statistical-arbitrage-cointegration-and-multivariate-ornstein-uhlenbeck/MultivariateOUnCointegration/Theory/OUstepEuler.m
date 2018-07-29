function [X_t,Mu_t,Sig_t]=OUstepEuler(X_0,Dt,Mu,Th,Sig)

[NumSimul,N]=size(X_0);

% location
ExpM=expm(-Th*Dt);

Mu_t = repmat((Mu-ExpM*Mu)',NumSimul,1) +  X_0*ExpM';

% scatter
Sig_t=Sig*Dt;
Eps=mvnrnd(zeros(N,1),Sig_t,NumSimul/2);
Eps=[Eps; -Eps];

X_t=Mu_t+Eps;
Mu_t=mean(X_t)';
