function [U] = mle_p4(X,phi,a1,a2,n,T);
%
%
% this function calculates the maximum likelihood function U (U0 or U1)
% with 4 Fourier harmonic
%
b=phi(1)+phi(2)*sin(n/T+phi(3))+phi(4)*sin(2*n/T+phi(5))...
    +phi(6)*sin(3*n/T+phi(7))+X(1)*sin(4*n/T+X(2));
U=sum(a1.*log(b)+a2.*log(1-b));
U=-U;  % to minimize function
