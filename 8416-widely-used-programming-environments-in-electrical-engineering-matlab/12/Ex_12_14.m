clear all, clc, clf
syms x y
ec1=x^2+y^2-5;
ec2=x^2+2*y-5;
[x,y]=solve(ec1,ec2)
ezplot(ec1)
hold on 
ezplot(ec2)
grid
axis([-4,4,-3,3])
X=double(x); Y=double(y);
plot(X,Y,'rd')