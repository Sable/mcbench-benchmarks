function [U2] = mle_gam1(X,v1,PP,logPP,PnP,n,T);
%
%
% this function calculates the maximum likelihood function U2 
% (parameters lambda and nu of the gamma distribution) with 1 Fourier harmonic
%
nu=X(1)+X(3)*sin(n/T+X(4));
%x=find(nu <= 0);
%nu(x)=0.00001
%nu(220:229)
lbd=X(2)+X(5)*sin(n/T+X(6));
%y=find(lbd <= 0);
%lbd(y)=0.00001;
mnu=kron(nu,v1);   % produces a matrix with identical lines
mlbd=kron(lbd,v1);
A=PnP.*mnu.*log(mlbd);
B=(mnu-1).*logPP;
C=PP.*mlbd;
D=gammaln(mnu).*PnP;
%
U2=sum(sum(A))+sum(sum(B))-sum(sum(C))-sum(sum(D));
U2=-U2;