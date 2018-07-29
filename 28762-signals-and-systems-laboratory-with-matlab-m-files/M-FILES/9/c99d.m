% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% 
% 
%  partial fraction expansions



%problem 4
num=[3 2 1];
den=[1 0 1 0]

[R,P,K]=residue(num,den)

X=R(1)/(s-P(1))+R(2)/(s-P(2))+R(3)/(s-P(3))

pretty(X)


%problem 5
num=[1 5 4];
den=[1 0 0 0 1];
[R,P,K]=residue(num,den)

syms s
X1=R(1)/(s-P(1))+R(2)/(s-P(2))+R(3)/(s-P(3))+R(4)/(s-P(4));
x1=ilaplace(X1,t);
ezplot(x1,[0 10])
title('y(t) from partial fraction form')


figure
X2=(s^2+5*s+4)/(s^4+1);
x2=ilaplace(X2,t)
ezplot(x2,[0 10])
title('y(t) from rational form')



%problem 6
num=[1 3 -8 7 13];
den=[1 2 1];
[R,P,K]=residue(num,den)
% b) 
[num,den]=residue(R,P,K)
% c) 
syms s
X=R(1)/(s-P(1))+R(2)/((s-P(2))^2) +K(1)*s^2+K(2)*s+K(3);
[n,d]=numden(X);
X=n/d


