function [Y2,C0,C1,C2,D1,D2]=fourier(X,aY,t,T)
%
coef=X\aY';
C0=coef(1);
D1=atan(coef(3)/coef(2));
D2=atan(coef(5)/coef(4));
C1=coef(2)/cos(D1);
C2=coef(4)/cos(D2);
Y2=C0+C1*sin(t/T+D1)+C2*sin(2*t/T+D2);
