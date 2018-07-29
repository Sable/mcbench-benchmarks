function [U] = mle_p1(X,phi,a1,a2,n,T);
%
%
% this function calculates the maximum likelihood function U (U0 or U1)
% with 1 Fourier harmonic
%
b=phi+X(1)*sin(n/T+X(2));
U=sum(a1.*log(b)+a2.*log(1-b));
U=-U;  % to minimize function
