clear all
syms x lambda0 theta0 eta0 lambda theta eta
lambda0=sqrt(double(solve(4/x-9/(1-x)-16/(4-x)-1))); 
theta0=sqrt(double(solve(4/x+9/(x-1)-16/(4-x)-1))); 
eta0=sqrt(double(solve(4/x+9/(x-1)+16/(x-4)-1)));
lambda0,theta0,eta0
[X,t]=elipsod;
tn=real([lambda0(2),theta0(3),eta0(1)])
Xn=subs(X,{lambda,theta,eta},{tn(1),tn(2),tn(3)})