function [Nu,C]=StrucTMLE(X,K,Tolerance)
% this function computes recursively the ML estimators of the correlation
% matrix and the d.o.g. of a t copula with isotropic structure
% see A. Meucci (2008) "Estimation of Structured T-Copulas"
% available at www.symmys.com > Research > Working Papers

Nus=[2 4 7 11 20 50]; % significant grid of potential degrees of freedom

LL=[]; % log-likelihood
[W,F,U]=SeparateMargCop(X); % extract copula
for s=1:length(Nus)
    Nu=Nus(s);
    Y=tinv(U,Nu);
    C = MleRecursionForT(Y,Nu,K,Tolerance);
    LL=[LL LogLik(Y,Nu,C)];
end

[a,Index]=max(LL);
Nu=Nus(Index);
C = MleRecursionForT(Y,Nu,K,Tolerance);

