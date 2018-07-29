function [x,y]=simulate(a,b,c,d,x0,T)
%Simulation of dynamical system
x(1)=x0;
for t=2:T
x(t)=random('normal',mx(a,x(t-1)),vx(b,x(t-1)));
y(t)=random('normal',my(c,x(t)),vy(d,x(t-1)));
end
