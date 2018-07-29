% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
%
% 
% Problem 9
% Solve the difference equation 
% y[n]-3y[n-1]+y[n-2]=x[n]-x[n-1] , x[n]=0.9^n u[n]
% and y[-1]=-1 , y[-2] =-2 

syms n z Y
x=0.9^n;
X=ztrans(x,z);
X1=z^(-1)*X;

y_1=-1;
y_2=-2
Y1=z^(-1)*Y+y_1;
Y2=z^(-2)*Y+y_2+(z^-1)*y_1;

G=2*Y-3*Y1+Y2-X+X1;
SOL=solve(G,Y);
y=iztrans(SOL,n)

n1=0:50;
y_n=subs(y,n,n1);
stem(n1,y_n)
title('y[n] from z-Transform ');

% a)
xn=0.9^(n);
xn_1=.9^(n-1);
yn=-9/8*(1/2)^n+9/8*(9/10)^n;
yn_1=-9/8*(1/2)^(n-1)+9/8*(9/10)^(n-1);
yn_2=-9/8*(1/2)^(n-2)+9/8*(9/10)^(n-2);

test=2*yn-3*yn_1+yn_2-xn+xn_1;
simplify(test)

% b)
a=[2 -3 1];
b=[1 -1];
yit=[-1 -2];
zi=filtic(b,a,yit)

figure
n=0:50;
x=0.9.^n;
y=filter(b,a,x,zi);
stem(n,y);
title('y[n] from filter');


