% NOLM_Stability_Curves.
% Copyright Springer 2013 A.L. Steele and S. Lynch.
syms x
lambda=1.55E-6;n2=3.2E-20;Aeff=30E-12;L=80;
k1=0.25;k2=0.8;k3=0.8;
K=sqrt((1-k2)*(1-k3));
B1=2*pi*n2*L*(2-k1)/(lambda*Aeff);
B2=2*pi*n2*L*(1+k1)/(lambda*Aeff);
A=x+2*K*x*(k1*cos(B1*x)-(1-k1)*cos(B2*x))+K^2*(k1^2*x+(1-k1)^2*x-2*(1-k1)*k1*x*cos(B1*x-B2*x));
DA=diff(A,x);
Dminus1=4*K*(k1*cos(B1*x)-x*B1*k1*sin(B1*x)-(1-k1)*cos(B2*x)+x*B2*(1-k1)*sin(B2*x));
hold on
s1=ezplot(DA,[0 40]);
set(s1,'Color','b');
s2=ezplot(Dminus1,[0 40]);
set(s2,'Color','r');
s3=ezplot('0',[0,40]);
set(s3,'Color','k');
hold off
title('Stability Curves for the NOLM')
