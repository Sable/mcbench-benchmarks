function [U2] = mle_lam4(X,phi2,v1,PP,PnP,n,T);
%
%
% this function calculates the maximum likelihood function U2 
% (lambda) with 4 Fourier harmonics
%
b=phi2(1)+phi2(2)*sin(n/T+phi2(3))+phi2(4)*sin(2*n/T+phi2(5))...
    +phi2(6)*sin(3*n/T+phi2(7))+X(1)*sin(4*n/T+X(2));
mb=kron(b,v1);   % produces a matrix with identical lines
A=PnP.*log(mb);
B=PP.*mb;
%
U2=sum(sum(A))-sum(sum(B));
U2=-U2;
