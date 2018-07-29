% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% 
% solution of the difference equation
% y[n]=0.5y[n-1]-0.1y[n-2]+0.1x[n]-0.5x[n-1]+x[n-2],
% y[-1]=0.3,y[-2]=0.5,x[-1]=x[-2]=0.4


%response to x[n]=[1,2,-1],n=0,1,2
a=[1 -0.5 0.1];
b=[0.1 -0.5 1];
yit=[0.3 0.5];
xit=[0.4 0.4];
zi=filtic(b,a,yit,xit)
n=0:9;
x=[1 2 -1 zeros(1,7)];
y=filter(b,a,x,zi);
stem(n,y);
xlim([-.3 9.3]);
title('y[n] with initial conditions');

%2nd way
figure
 L=10;
x=[1 2 -1 zeros(1,7)];
y=[ 0.4 0.27 zeros(1,8)];
 for m=3:L
y(m)=0.5*y(m-1)-0.1*y(m-2) +0.1*x(m)-0.5*x(m-1)+x(m-2);
end
stem(0:L-1,y);
xlim([-.3 9.3]);
legend('y[n]');
