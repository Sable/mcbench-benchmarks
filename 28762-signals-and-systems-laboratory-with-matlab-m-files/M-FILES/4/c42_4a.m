% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
%  convolution between h(t)=exp(-t)u(t) and x(t)=0.6 -1<t<0.5 
%                                                0.3  0.5<t<3


%analytical
figure 
th1=linspace(0,10,1001);
h1=exp(-th1);
h=[0 h1];
th=[0 th1];
tx=[-1 -1 0.5 0.5 3 3];
x=[0 0.6 0.6 0.3 0.3 0];
plot(tx,x, ':',th,h)
legend('x(\tau)','h(\tau)')
 
figure
t=-3
plot(tx,x,':',-th+t,h)
legend('x(\tau)','h(t-\tau)')

 figure
 t=-0.3
 plot(tx,x,':',-th+t,h)
 legend('x(\tau)','h(t-\tau)')
 syms t r
 f=0.6*exp(-(t-r));
 y=int(f,r,-1,t)

 
 figure
 t=1.4;
 plot(tx,x,':',-th+t,h)
 legend('x(\tau)','h(t-\tau)')
 
 syms t r
 f1=0.6*exp(-(t-r));
 f2=0.3*exp(-(t-r));
 y=int(f1,r,-1,0.5)+int(f2,r,0.5,t)
 
 
 figure
 t=3.9;
 plot(tx,x,':',-th+t,h)
 xlim([-8 6])
 legend('x(\tau)','h(t-\tau)')
 
 syms t r
 f1=0.6*exp(-(t-r));
 f2=0.3*exp(-(t-r));
 y=int(f1,r,-1,0.5)+int(f2,r,0.5,3)
 
 
 figure
 t1=-1:.1:0.5;
 y1=0.6*(1-exp(-1-t1));
 t2=0.5:.1:3;
 y2=0.3*exp(-t2).*(exp(t2)-2*exp(-1)+exp(0.5));
 t3=3:.1:10;
 y3=0.3*exp(-t3)*(exp(0.5)-2*exp(-1)+exp(3));
 t=[t1 t2 t3];
 y=[y1 y2 y3];
 plot(t,y)
 title('Output signal y(t)')
 
 
 %2nd method
figure
t1=[0:0.01:1.5];
t2=[1.5+0.01:0.01:4]
t3=[4.01:0.01:10]; 
x1=0.6*ones(size(t1));
x2=0.3*ones(size(t2));
x3=zeros(size(t3));
x=[x1 x2 x3];

h=exp(-[t1 t2 t3]);

y=conv(x,h)*0.01;

plot(-1:0.01:19, y)
title('Output signal y(t)')





%3rd method
figure
t1=[-1:0.01:0.5];
x1=.6*ones(size(t1));
t2=[.5+0.01:0.01:3];
x2=.3*ones(size(t2));
t3=[3.01:0.01:10];
x3=zeros(size(t3));
x=[x1 x2 x3];

t1=-1:.01:-.01;
t2=0:.01:10;
h1=zeros(size(t1));
h2=exp(-t2);
h=[h1 h2];

y=conv(x,h)*.01;

plot(-2:.01:20,y)





