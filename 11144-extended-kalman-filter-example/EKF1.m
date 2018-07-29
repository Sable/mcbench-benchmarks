% THIS PROGRAM IS FOR IMPLEMENTATION OF DISCRETE TIME PROCESS EXTENDED KALMAN FILTER
% FOR GAUSSIAN AND LINEAR STOCHASTIC DIFFERENCE EQUATION.
% By (R.C.R.C.R),SPLABS,MPL.
% (17 JULY 2005).
% Help by Aarthi Nadarajan is acknowledged.
% (drawback of EKF is when nonlinearity is high, we can extend the
% approximation taking additional terms in Taylor's series).

clc;  close all; clear all;

Xint_v = [1; 0; 0; 0; 0];
wk = [1 0 0 0 0];
vk = [1 0 0 0 0];

for ii = 1:1:length(Xint_v)
    
    Ap(ii) = Xint_v(ii)*2;
    W(ii) = 0;
    H(ii) = -sin(Xint_v(ii));
    V(ii) = 0;
    Wk(ii) = 0;
    
end

Uk = randn(1,200);
Qu = cov(Uk);
Vk = randn(1,200);
Qv = cov(Vk);
C = [1 0 0 0 0];
n = 100;

[YY XX] = EKLMNFTR1(Ap,Xint_v,Uk,Qu,Vk,Qv,C,n,Wk,W,V);

for it = 1:1:length(XX)
    MSE(it) = YY(it) - XX(it);
end

tt = 1:1:length(XX);

figure(1);   subplot(211);   plot(XX);   title('ORIGINAL SIGNAL');
subplot(212);   plot(YY);   title('ESTIMATED SIGNAL');

figure(2); plot(tt,XX,tt,YY); title('Combined plot'); legend('original','estimated');

figure(3);   plot(MSE.^2);   title('Mean square error');

