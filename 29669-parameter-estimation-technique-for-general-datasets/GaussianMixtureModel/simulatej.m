function [x,y,l]=simulatej(a,b,c,d,g,h,lambda,x0,T)
%Simulation of dynamical system
x(1)=x0;
for t=2:T
if rand>lambda
l(t)=0;   
x(t)=random('normal',mx(a,x(t-1)),b);
else
l(t)=1;
x(t)=random('normal',mx([a,g],x(t-1)),sqrt((1+h))*b);
end
y(t)=random('normal',my(c,x(t)),d);
end