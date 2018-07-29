function [U2] = mle_lam1(X,phi2,v1,PP,PnP,n,T);
%
%
% this function calculates the maximum likelihood function U2 
% (lambda) with 1 Fourier harmonic
%
b=phi2+X(1)*sin(n/T+X(2));
mb=kron(b,v1);   % produces a matrix with identical lines
A=PnP.*log(mb);
B=PP.*mb;
%
U2=sum(sum(A))-sum(sum(B));
U2=-U2;

